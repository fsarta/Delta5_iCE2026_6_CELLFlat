(* =========================================================================
   FB_ConveyorController - Controllo velocita' nastro FeedIn (tracking)
   -------------------------------------------------------------------------
   Scopo del blocco: rallentare il nastro man mano che il pezzo si avvicina
   alla soglia di fine corsa (tracking_end), con una rampa proporzionale nella
   fascia finale, in modo che il robot riesca sempre a prendere il pezzo prima
   della EndDistance del blocco MC_TrackConveyorBelt.

   Zone (distance = posizione del pezzo, gia' riferita al frame FeedIn):

     ZONA 1  distance <= tracking_start
             nastro a v_nominal.

     ZONA 2  tracking_start < distance <= (tracking_end - ramp_margin)
             fascia di prelievo: velocita' ridotta COSTANTE v_min.

     ZONA 3  (tracking_end - ramp_margin) < distance < tracking_end
             rampa lineare proporzionale da v_min a 0:
                 v = v_min * (1 - ratio_end)

     ZONA 4  distance >= tracking_end
             nastro fermo.

   PERCHE' LA ZONA 2 E' COSTANTE E NON PROPORZIONALE
   La posizione usata e' quella del pezzo attualmente in tracking. Se la
   velocita' variasse in modo proporzionale per tutta la zona, OGNI pezzo
   della fila farebbe rallentare e riaccelerare il nastro (effetto "pompa"):
   rallenta mentre il pezzo attraversa la fascia, poi - preso il pezzo - il
   tracking passa al successivo (piu' indietro) e il nastro torna a v_nominal.
   Con una velocita' COSTANTE nella fascia di prelievo il nastro cambia
   velocita' una sola volta per pezzo (nominale -> v_min) e resta stabile
   durante il prelievo.
   La rampa proporzionale resta dove serve davvero: negli ultimi millimetri
   prima della soglia, per fermare il nastro in modo dolce e garantito sul
   pezzo che arriva troppo avanti.

   La DECELERAZIONE e' sempre dec_max (= CommandDeceleration di HMI): e' l'unico
   parametro che il drive usa quando il jog viene rilasciato. Prima veniva
   ridotta a dec_min e questo rendeva lo STOP CICLO del FeedIn lentissimo,
   mentre il FeedOut (che usa CommandDeceleration) si fermava subito. Ora i due
   nastri si arrestano con la stessa identica rampa.
   L'accelerazione e' acc_max, tranne nella ZONA 4 dove resta acc_min (come
   nella versione precedente) per evitare strappi in avanti se il setpoint
   risale (oscillazioni della distanza / buffer vuoto).
   ========================================================================= *)

(* -------------------------------------------------------------------------
   Lunghezza della zona di rallentamento e margine della rampa finale.
   Protezioni sui parametri: nessuna divisione per zero anche se in HMI
   vengono impostati valori non validi (zona nulla / margine >= zona).
   ------------------------------------------------------------------------- *)
zone_length := tracking_end - tracking_start;
IF zone_length < 2.0 THEN
    zone_length := 2.0;
END_IF

ramp_margin := MAX(1.0, MIN(end_zone_margin, zone_length - 1.0));

(* v_min deve restare sotto v_nominal, altrimenti la "rampa" diventerebbe una
   ri-accelerazione. Se in HMI la velocita' nominale viene abbassata sotto
   v_min, la rampa si appiattisce su v_nominal (nessun salto di velocita'). *)
v_ramp_min := MAX(0.0, MIN(v_min, v_nominal));

(* -------------------------------------------------------------------------
   Controllo disabilitato (ciclo automatico fermo, modo manuale, ...):
   il blocco non deve "frenare" l'asse. Si passano i valori nominali/massimi
   e la decelerazione di targa (dec_max), cosi' il jog resta identico a
   quello del FeedOut.
   ------------------------------------------------------------------------- *)
IF NOT enable THEN
    speed_setpoint  := v_nominal;
    acceleration    := acc_max;
    deceleration    := dec_max;
    tracking_active := FALSE;
    end_zone_active := FALSE;
    RETURN;
END_IF

(* ------------------------------- ZONE ---------------------------------- *)
(* La condizione "buffer vuoto" e' IMPORTANTE e va mantenuta: quando non ci sono
   piu' prodotti in coda il nastro deve tornare a velocita' nominale, altrimenti
   (ultimo pezzo fermo sulla soglia) resterebbe a 0 e non arriverebbero piu'
   pezzi dalla linea. *)
IF (distance <= tracking_start)
   OR (MultiGrpProductData[0].UsePointer = MultiGrpProductData[0].StorePointer) THEN

    (* ZONA 1: pezzo lontano (o nessun pezzo in coda) -> velocita' nominale *)
    speed_setpoint  := v_nominal;
    acceleration    := acc_max;
    tracking_active := FALSE;
    end_zone_active := FALSE;

ELSIF distance < (tracking_end - ramp_margin) THEN

    (* ZONA 2: fascia di prelievo -> velocita' ridotta COSTANTE (v_min).
       Volutamente COSTANTE e non proporzionale: e' la zona in cui il pezzo
       viene preso. Con una rampa continua qui, ogni volta che un pezzo
       attraversa la fascia il nastro rallenterebbe e riaccelererebbe (effetto
       "pompa") per OGNI pezzo della fila. Cosi' invece la velocita' cambia una
       sola volta all'ingresso in zona (nominale -> v_min, rampa gestita
       dall'accelerazione del drive) e resta stabile per tutto il prelievo. *)
    speed_setpoint  := v_ramp_min;
    acceleration    := acc_max;
    tracking_active := TRUE;
    end_zone_active := FALSE;

ELSIF distance < tracking_end THEN

    (* ZONA 3: rampa finale proporzionale v_min -> 0
       Il nastro arriva a 0 esattamente sulla soglia tracking_end, quindi il
       pezzo non supera mai il punto di stop (un po' prima della EndDistance
       del tracking) e il robot ha sempre il tempo di prenderlo. *)
    d_remaining := tracking_end - distance;
    ratio_end   := 1.0 - (d_remaining / ramp_margin);
    ratio_end   := MAX(0.0, MIN(1.0, ratio_end));

    speed_setpoint  := v_ramp_min * (1.0 - ratio_end);

    (* Ultimo millimetro: setpoint a zero secco.
       La rampa proporzionale, per definizione, tende a zero in modo asintotico:
       questo azzeramento garantisce l'arresto COMPLETO del nastro sulla soglia
       (lo scalino residuo e' < v_min / ramp_margin, trascurabile). *)
    IF d_remaining < 1.0 THEN
        speed_setpoint := 0.0;
    END_IF

    acceleration    := acc_max;
    tracking_active := TRUE;
    end_zone_active := TRUE;

ELSE

    (* ZONA 4: oltre la soglia -> nastro fermo.
       Accelerazione al minimo come nella versione precedente: se per oscillazioni
       della distanza o per il buffer vuoto il setpoint risale, il nastro riparte
       gradualmente invece di dare uno strappo in avanti. *)
    speed_setpoint  := 0.0;
    acceleration    := acc_min;
    tracking_active := TRUE;
    end_zone_active := TRUE;

END_IF

(* Decelerazione sempre "di targa" (CommandDeceleration): la rampa di velocita'
   e' data dal setpoint, non da una decelerazione artificialmente bassa. In questo
   modo, quando il jog viene rilasciato (Stop Ciclo), il FeedIn frena esattamente
   come il FeedOut. *)
deceleration := dec_max;

(* =========================================================================
   LEGACY - logica precedente tenuta come riferimento (NON eseguita).
   Usava due rampe separate con in_sync/max_error e combinava i risultati con
   MIN/MAX: sostituita dalla rampa unica continua descritta sopra.
   ========================================================================= *)
(*

IF NOT enable THEN
    speed_setpoint  := v_nominal;
    acceleration    := acc_max;
    deceleration    := dec_min;
    tracking_active := FALSE;
    end_zone_active := FALSE;
    RETURN;
END_IF

(* ---------------------------------------------------------
   FASE 1 - Correzione inizio zona
   Attiva quando distance supera tracking_start.
   Velocita' e decelerazione calate proporzionalmente all'errore.
   --------------------------------------------------------- *)
error_start := distance - tracking_start;

IF error_start > 0.0 THEN
    ratio_start     := MAX(0.0, MIN(1.0, error_start / max_error));
    spd_phase1      := MAX(v_min, v_nominal - ratio_start * (v_nominal - v_min));
    dec_phase1      := dec_min + ratio_start * (dec_max - dec_min);
    tracking_active := TRUE;
ELSE
    spd_phase1      := v_nominal;
    dec_phase1      := dec_min;
    tracking_active := FALSE;
END_IF

(* ---------------------------------------------------------
   FASE 2 - Controllo fine zona (solo se in_sync)
   --------------------------------------------------------- *)
IF in_sync THEN
    d_remaining := tracking_end - distance;

    IF d_remaining < end_zone_margin THEN
        ratio_end       := MAX(0.0, MIN(1.0, 1.0 - (d_remaining / end_zone_margin)));
        spd_phase2      := MAX(0.0,   v_nominal * (1.0 - ratio_end));
        dec_phase2      := dec_min  + ratio_end * (dec_max - dec_min);
        acc_phase2      := acc_max  - ratio_end * (acc_max - acc_min);
        end_zone_active := TRUE;
    ELSE
        spd_phase2      := v_nominal;
        dec_phase2      := dec_min;
        acc_phase2      := acc_max;
        end_zone_active := FALSE;
    END_IF
ELSE
    spd_phase2      := v_nominal;
    dec_phase2      := dec_min;
    acc_phase2      := acc_max;
    end_zone_active := FALSE;
END_IF

speed_setpoint := MIN(spd_phase1, spd_phase2);
deceleration   := MAX(dec_phase1, dec_phase2);
acceleration   := MIN(acc_max,    acc_phase2);
*)
