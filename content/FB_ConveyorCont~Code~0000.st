(* =========================================================
   LOGICA PRINCIPALE - CONTROLLO CONVEYOR A 3 ZONE
   ========================================================= *)

IF NOT enable THEN
    speed_setpoint  := v_nominal;
    acceleration    := acc_max;
    deceleration    := dec_min;
    tracking_active := FALSE;
    RETURN;
END_IF

(* ZONA 1: Prima della "Quota 1" (tracking_start)
   Il prodotto è lontano. Il nastro viaggia alla velocità nominale.
*)
IF (distance < tracking_start) OR (MultiGrpProductData[0].UsePointer = MultiGrpProductData[0].StorePointer) THEN

    speed_setpoint  := v_nominal;
    acceleration    := acc_max;
    deceleration    := dec_min;
    tracking_active := FALSE;

(* ZONA 2: Tra "Quota 1" e "Quota 2" (tracking_end)
   Calcolo della velocità "ottima". Rallenta progressivamente.
*)
ELSIF distance >= tracking_start AND distance < tracking_end THEN

    // 1. Calcoliamo un coefficiente "progress" da 0.0 (inizio zona) a 1.0 (fine zona)
    // Indica percentualmente quanto ci siamo avvicinati alla Quota 2
    zone_length := tracking_end - tracking_start;
    progress    := (distance - tracking_start) / zone_length;

    // 2. Calcolo Velocità Ottima:
    // Scende in modo fluido e proporzionale da v_nominal fino a v_min.
    // Usiamo v_min (es. 100 mm/s) e non 0 per evitare che il nastro si 
    // fermi prematuramente prima di raggiungere esattamente la Quota 2.
    speed_setpoint  := v_min; // v_nominal - (progress * (v_nominal - v_min));

    // 3. Adattamento dinamico delle Rampe:
    // Più ci avviciniamo alla fine, più "irrigidiamo" la frenata.
    deceleration    := dec_max; // dec_min + (progress * (dec_max - dec_min));
    acceleration    := acc_max; // L'accelerazione resta alta in caso serva correggere

    tracking_active := TRUE;

(* ZONA 3: Oltre la "Quota 2" (tracking_end)
   Il prodotto ha raggiunto il limite estremo. Stop assoluto.
*)
ELSE

    // Taglio netto a zero (Cut-off)
    speed_setpoint  := 0.0;
    
    // Abbassiamo l'accelerazione al minimo. Se la telecamera o l'encoder 
    // "sfarfallano" e la distanza oscilla, evitiamo che il nastro dia strappi in avanti.
    acceleration    := acc_min; 
    
    // Decelerazione al massimo per garantire un arresto tipo "emergenza/finecorsa"
    deceleration    := dec_max; 
    
    tracking_active := TRUE;

END_IF

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
   FASE 1 – Correzione inizio zona
   Attiva quando distance supera tracking_start.
   Velocità e decelerazione calate proporzionalmente all'errore.
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
   FASE 2 – Controllo fine zona (solo se in_sync)
   Attiva quando il prodotto entra nell'end_zone_margin.
   La velocità scende fino a 0, la decelerazione sale al massimo,
   l'accelerazione scende al minimo per evitare riaccelerate tardive.
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

(* ---------------------------------------------------------
   COMBINAZIONE – prende il valore più restrittivo tra le due fasi
   Speed e acceleration: MIN (il più cautelativo)
   Deceleration: MAX (la frenata più aggressiva vince)
   --------------------------------------------------------- *)
speed_setpoint := MIN(spd_phase1, spd_phase2);
deceleration   := MAX(dec_phase1, dec_phase2);
acceleration   := MIN(acc_max,    acc_phase2);
*)