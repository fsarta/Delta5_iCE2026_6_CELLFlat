"""content_cards.py — appendici: schede POU, schede step, esercizi, riferimento."""


def fmt(items):
    return [(0, a + "  " + b) for a, b in items]


POUS = [
    ("FB_MachineController", "FUNCTION_BLOCK · Machine/", [
        ("Ruolo:", "supervisore della macchina a stati: alimentazione, modo, arresti"),
        ("Dipendenze:", "FB_ErrorHandler, DATA_Delta, DATA_FeedIn/FeedOutAxis, HMI_Data, IO"),
        ("Metodi:", "11 handler di stato"),
        ("Da sapere:", "il cambio stato passa sempre da NextState + bTransition, tranne INIT→IDLE e l'ingresso in TeachFrame"),
        ("Rischio:", "modifica qui = modifica alla sicurezza logica della cella")],
     "Ogni modifica va provata su tutti gli stati, non solo su quello toccato."),
    ("FB_PickPlace_Sequencer1", "FUNCTION_BLOCK · Machine/", [
        ("Ruolo:", "motore del ciclo: playlist + dispatcher + 24 step + driver motion"),
        ("Dipendenze:", "FB_GroupController, DATA_Machine, MultiGrpProductData, HmiFramesData"),
        ("Metodi:", "43"),
        ("Da sapere:", "gli step non fanno transizioni: ritornano BUSY/DONE/ERROR/ACTIVE"),
        ("Rischio:", "un metodo che ritorna sempre BUSY blocca il ciclo senza errore")],
     "Ordine di lettura: Code.st (motore) → M_Dispatcher → M_ConfigSequence_Run → i M_Step_*."),
    ("FB_GroupController", "FUNCTION_BLOCK · Machine/Group/", [
        ("Ruolo:", "incapsula i FB di gruppo Delta e il conveyor tracking"),
        ("Dipendenze:", "DELTA (AXES_GROUP_REF), FeedIn_Axis, FeedOut_Axis"),
        ("Contiene:", "GroupReadStatus, GroupJogJoint/Linear, MoveLinearAbsolute ×4, MoveLinearRelative, GroupStop, SetPosition"),
        ("Da sapere:", "è la sola porta verso il motion di gruppo"),
        ("Rischio:", "cambiare la numerazione di un asse invalida i frame insegnati")],
     "Livello 'driver': nessuna decisione di processo, solo traduzione in chiamate di libreria."),
    ("FB_AxisController", "FUNCTION_BLOCK · Machine/Axis/", [
        ("Ruolo:", "driver generico di asse: FB PLCopen + letture diagnostiche"),
        ("Dipendenze:", "AXIS_REF dell'asse, ST_AxisData"),
        ("Sezioni:", "MAPPING_In, MOTION, MAPPING_Out, READINGS, WRITE_Parameters (SDO)"),
        ("Da sapere:", "la stessa istanza funziona su FeedIn, FeedOut e Virtual"),
        ("Rischio:", "il touch probe è configurato qui: toccarlo rompe il latch della visione")],
     "Aggiungere un asse = istanziare il FB, non scrivere una nuova catena di MC_*."),
    ("FB_ErrorHandler", "FUNCTION_BLOCK · Machine/Error/", [
        ("Ruolo:", "raccolta errori in buffer circolare globale con deduplica e severità"),
        ("Dipendenze:", "G_ErrorBuffer, G_udiErrorHead/Tail, Y_YA_RealTimeClock"),
        ("Metodi:", "AddUpdateError, Update, LogEvent, CheckAndEnqueue, GetErrorMessage, Init/Clear"),
        ("Da sapere:", "deduplica su (ErrorCode, ErrorSource); Ack ≠ Reset"),
        ("Rischio:", "LogEvent usato per condizioni persistenti riempie il buffer")],
     "Il buffer è globale, non per istanza: è la lista errori unica della macchina."),
    ("FB_KPI", "FUNCTION_BLOCK · Machine/", [
        ("Ruolo:", "calcolo metriche di turno e lifetime in KPI_Data"),
        ("Dipendenze:", "contatori G_udi*, G_bPieceInHand, G_bPickPlaceError, TouchProbeDone"),
        ("Metodi:", "tick 1 s/1 min, reset turno, calcolo ratei e tempi"),
        ("Da sapere:", "i contatori globali si leggono per delta rispetto al valore old"),
        ("Rischio:", "dopo riavvio i delta possono diventare negativi (UDINT)")],
     "Formule documentate anche in KPI/GUIDA_KPI.md, oltre che nei commenti del POU."),
    ("FB_VisionApplication", "FUNCTION_BLOCK · Machine/Vision/", [
        ("Ruolo:", "esegue il ciclo di visione: trigger, latch, lettura telegramma"),
        ("Dipendenze:", "FB_VisorDriver, FB_DistanceTrigger, DATA_FeedInAxis"),
        ("Ingressi:", "xEnable, xUsePhysTrigger, rLatchedPosition, xTouchProbeDone/Error"),
        ("Uscite:", "stCurrentResult, xPhysTrigger, xArmTouchProbe, rTriggeredPosition"),
        ("Rischio:", "cambiare l'ordine latch/lettura introduce errore di posizione")],
     "Un solo FB orchestra la visione: VisionManager vede la chiamata e gli handshake."),
    ("FB_VisorDriver", "FUNCTION_BLOCK · Machine/Vision/", [
        ("Ruolo:", "mapping del telegramma SensoPart VISOR su struttura tipizzata"),
        ("Dipendenze:", "VisorEIP_Receive/Transmit, FC_BytesToReal"),
        ("Metodi:", "6 (parsing campi, stato connessione)"),
        ("Da sapere:", "4 pezzi per foto: X[0..3], Y[0..3], Rz[0..3], Part_Count"),
        ("Rischio:", "endianness sbagliata = coordinate assurde")],
     "Tutto il protocollo è qui: cambiare telecamera significa cambiare questo blocco."),
    ("FB_ConveyorController", "FUNCTION_BLOCK · Utils/", [
        ("Ruolo:", "calcola setpoint di velocità/accelerazione/decelerazione del FeedIn"),
        ("Dipendenze:", "nessuna: parametri in ingresso, puro calcolo"),
        ("Zone:", "1 nominale, 2 v_min costante, 3 rampa finale, 4 fermo"),
        ("Da sapere:", "decelerazione sempre = dec_max, anche quando non abilitato"),
        ("Rischio:", "reintrodurre dec_min torna a frenare lentamente lo stop ciclo")],
     "Blocco 'puro': ottimo candidato per test unitari se si introdurrà un framework."),
    ("FB_TeachFrame", "FUNCTION_BLOCK · Machine/", [
        ("Ruolo:", "procedura 3 punti e calcolo del frame"),
        ("Dipendenze:", "HmiFramesData.aTeachFrame, GroupSetPosition, FrameTypeTransform"),
        ("Da sapere:", "funziona con servo ON (jog) o servo OFF (free-drag)"),
        ("Rischio:", "punti troppo vicini o non complanari danno frame mal condizionati")],
     "Collegato allo stato TEACH_FRAME, raggiungibile da IDLE e da MANUAL."),
    ("FB_RotatePosition", "FUNCTION_BLOCK · Utils/", [
        ("Ruolo:", "matrici di rotazione per il polso (B)"),
        ("Dipendenze:", "nessuna"),
        ("Metodi:", "9"),
        ("Da sapere:", "usato in EnablePickTracking per la rotazione Rz del TCP"),
        ("Rischio:", "convenzioni di segno diverse da quelle del frame")],
     "Se il robot prende 'ruotato' di un angolo fisso, il sospetto cade qui."),
    ("MyFormatProductData", "FUNCTION_BLOCK · Utils/", [
        ("Ruolo:", "converte il risultato visione in InputProductData"),
        ("Dipendenze:", "stCurrentResult di FB_VisionApplication"),
        ("Handshake:", "Execute / Busy / Done / Error / ErrorID"),
        ("Da sapere:", "riceve solo X, Y, Rz (Z, Rx, Ry commentati)"),
        ("Rischio:", "Error non gestito = pezzi persi silenziosamente"),],
     "L'errore di formattazione oggi non genera un allarme attivo (AddUpdateError commentato)."),
    ("McePosTable", "FUNCTION_BLOCK · Utils/", [
        ("Ruolo:", "tabella di posizioni per movimenti sequenziali (MCE)"),
        ("Dipendenze:", "nessuna"),
        ("Metodi:", "7 (add, clear, next, read)"),
        ("Da sapere:", "non usato nel ciclo pick&place attuale"),
        ("Rischio:", "codice non esercitato: da riverificare prima dell'uso")],
     "Utility riusabile per una eventuale sequenza di punti fissa."),
    ("HMI.pou", "PROGRAM · Cyclic/ · SlowTask", [
        ("Ruolo:", "unica mappatura fra HMI_Data e le strutture di macchina"),
        ("Dipendenze:", "HMI_Data, DATA_*, KPI_Data, MultiGrpProductData, FeedIn_Smooth*"),
        ("Sezioni:", "comandi, setting, status, mirror Tracking"),
        ("Da sapere:", "un solo scrittore per campo; mirror coda limitato a 8 righe"),
        ("Rischio:", "watchdog SlowTask 32 ms: nessun ciclo lungo")],
     "Volutamente lungo e piatto: si legge come una tabella di mappatura."),
    ("PickPlaceManager.pou", "PROGRAM · Cyclic/ · FastTask", [
        ("Ruolo:", "orchestrazione del ciclo: comandi, sequencer, rampa nastro, valvole"),
        ("Dipendenze:", "FB_PickPlace_Sequencer1, FB_ConveyorController1, MonitorStatusData"),
        ("Da sapere:", "gira a 2 ms: ciò che si aggiunge qui pesa sul motion"),
        ("Punti chiave:", "enable rampa = StartPickPlace AND G_bAutoCycleRunning; step in HMI_Data"),
        ("Rischio:", "valvole gripper forzate OFF in caso di errore step")],
     "La copia di eCurrentStepName sta qui perché il sequencer è locale a questo programma."),
    ("VisionManager.pou", "PROGRAM · Cyclic/ · MediumTask", [
        ("Ruolo:", "trigger, latch, chiamata visione, formattazione, distribuzione, monitor"),
        ("Dipendenze:", "fbVisionApp, fbFormatProductData, fbSequenceDistribution, fbMultiGrpProductMonitor"),
        ("Da sapere:", "ordine obbligato: latch → FB → copia risultati → distribuzione"),
        ("Punti chiave:", "rDistanceSetpoint 140 mm, tPhysTriggerPulse 10 ms, BufferSize 150"),
        ("Rischio:", "spostare la cattura del latch dopo la chiamata introduce errore")],
     "Catena a stadi con handshake Busy/Done: nessuno stadio sovrascrive il precedente."),
    ("Main.pou", "PROGRAM · Cyclic/ · MediumTask", [
        ("Ruolo:", "entry point: FB_MachineController, FB_KPI, parsing telegramma"),
        ("Dipendenze:", "fbMachineController, fbKPI, VisorEIP_Receive"),
        ("Da sapere:", "qui stanno le conversioni FC_BytesToReal del telegramma"),
        ("Rischio:", "logica pesante qui rallenta la supervisione di stato")],
     "Utile per capire quanto costa un ciclo di supervisione."),
    ("IO.pou", "PROGRAM · Cyclic/ · FastTask", [
        ("Ruolo:", "lettura ingressi e scrittura uscite"),
        ("Dipendenze:", "moduli SliceBus, io.* (struttura I/O)"),
        ("Da sapere:", "le valvole gripper sono pilotate da PickPlaceManager, non qui"),
        ("Rischio:", "forzature manuali di uscite durante la produzione")],
     "Separare l'IO permette di leggere gli ingressi una sola volta per ciclo."),
    ("Init.pou", "PROGRAM · Initialize/ · Warm e Cold start", [
        ("Ruolo:", "valori iniziali di tutti i parametri di macchina"),
        ("Dipendenze:", "DATA_Machine, DATA_*Axis, HMI_Data, MultiGrpProductData"),
        ("Da sapere:", "include TrackingWindowStart/End e OffsetCamera: richiede rebuild"),
        ("Rischio:", "default duplicati qui e in HMI_Data creano valori incoerenti")],
     "Regola: il tipo dichiara, Init assegna. Se un parametro non è in Init, vale quel che capita."),
]

STEPS = [
    ("M_Step_Initialize", "0 · PICK", [
        ("Scopo:", "prepara il ciclo: pinze chiuse, flag, tracking disarmato"),
        ("Entry:", "iGripperForThisCycle := iGripperToUse; bDoubleModeForThisCycle := bDoubleMode"),
        ("Azioni:", "disarma tracking FeedIn/FeedOut, CalcFrameOffset_Group.Enable := FALSE"),
        ("Esito:", "DONE se il ciclo può partire, BUSY se attende StartCycle"),
        ("Attenzione:", "qui si congela il modo singolo/doppio del ciclo")],
     "Se il doppio pick non parte, guardare prima questo step."),
    ("M_Step_CheckPickLimits", "1 · PICK", [
        ("Scopo:", "leggere il pezzo dalla coda e verificarne l'esistenza"),
        ("Entry:", "UsePointer/StorePointer di stPickPlaceProductData_Pick[GroupNumber]"),
        ("Azioni:", "ActProdX/Y/RZ_Raw ← ProductPosition[1]/[2]/[6]"),
        ("Esito:", "DONE se il pezzo esiste, BUSY se la coda è vuota"),
        ("Attenzione:", "i controlli su LimitPos sono commentati: oggi non bloccano")],
     "Punto di roadmap: ripristinare i limiti evita prese fuori area."),
    ("M_Step_CalcPickOffset", "2 · PICK", [
        ("Scopo:", "applicare l'offset del gripper ruotato di Rz"),
        ("Entry:", "scelta fra stGripper1_Offset e stGripper2_Offset"),
        ("Azioni:", "X' = X + (ox·cos − oy·sin), Y' = Y + (ox·sin + oy·cos)"),
        ("Esito:", "DONE immediato (solo calcolo)"),
        ("Attenzione:", "gli offset sono nel sistema del pezzo, non del mondo")],
     "Dimenticare la rotazione dà un errore di presa che dipende dall'orientamento."),
    ("M_Step_SetPickFrame_Tracking", "3 · PICK", [
        ("Scopo:", "calcolare il frame FeedIn dai 3 punti insegnati"),
        ("Entry:", "OO/XX/XY ← HmiFramesData.aTeachFrame[1]; Execute := TRUE"),
        ("Azioni:", "attesa Done/Error del FB di trasformazione"),
        ("Esito:", "BUSY → DONE"),
        ("Attenzione:", "un frame mal condizionato si propaga a tutto il ciclo")],
     "Stesso schema per il FeedOut con aTeachFrame[2]."),
    ("M_Step_ConvertPickToCartesian_Tracking", "4 · PICK", [
        ("Scopo:", "convertire il vettore frame in riferimento cartesiano"),
        ("Entry:", "VECTOR_TO_CARTESIANREF1(Vector := FrameCoordinates, CartesianRef => FeedIn_FrameOffset)"),
        ("Azioni:", "conversione sincrona"),
        ("Esito:", "DONE immediato"),
        ("Attenzione:", "vFeedIn_FrameOffset è usato anche dalla rampa nastro e dall'HMI")],
     "Unica funzione di conversione: cambiarla cambia motion e visualizzazione."),
    ("M_Step_SetPickOffsetAndPCS_Tracking", "5 · PICK", [
        ("Scopo:", "impostare il sistema di coordinate del pezzo (PCS)"),
        ("Entry:", "GroupSetFrameOffset_FeedIn con Offset := FeedIn_FrameOffset"),
        ("Azioni:", "ExecutionMode Immediately, RefCoordSystem MCS, SetCoordSystem PCS"),
        ("Esito:", "BUSY → DONE"),
        ("Attenzione:", "da qui i comandi in PCS seguono il pezzo")],
     "Passaggio concettuale chiave: il robot lavora 'nel sistema del pezzo'."),
    ("M_Step_EnablePickTracking", "6 · PICK · 132 righe", [
        ("Scopo:", "armare MC_TrackConveyorBelt sul FeedIn"),
        ("Entry:", "ConveyorBeltOrigin ← FeedIn_FrameOffset[1..6]"),
        ("Azioni:", "normalizzazione Rz oltre ±90°, RecordedPosition + OffsetCamera, StartDistance 10, EndDistance 500, SyncIn 10/5, SyncOut 15"),
        ("Esito:", "DONE quando TrackConveyorBelt_FeedIn.Active"),
        ("Attenzione:", "è lo step più lungo: qui si decide la finestra di tracking")],
     "Primo metodo da leggere insieme a FB_ConveyorController per problemi a fine corsa."),
    ("M_Step_ApproachPick_Tracking", "7 · PICK", [
        ("Scopo:", "avvicinamento in quota 0 sopra il pezzo, in inseguimento"),
        ("Entry:", "M_Driver_Motion_Cmd(X, Y, Z=0, Rz=offset, Vel=MinVelocity_Delta)"),
        ("Azioni:", "stMoveOption VelocityUnit 2, TrajectoryShape 1"),
        ("Esito:", "ACTIVE al primo riscontro (blending verso lo step successivo)"),
        ("Attenzione:", "non attende la fine: il movimento successivo è già armato")],
     "Esempio concreto del perché esiste il driver a 4 blocchi Blend."),
    ("M_Step_WaitForPickSync", "8 · PICK", [
        ("Scopo:", "attendere che il tracking sia in sync"),
        ("Entry:", "nessuna azione di comando"),
        ("Condizione:", "TrackConveyorBelt_FeedIn.InSync OR ActualPosition = 0.0"),
        ("Azioni:", "DATA_Machine.Status.InSyncPick_Delta := TRUE"),
        ("Attenzione:", "il fallback serve per i test a nastro fermo")],
     "Senza il fallback, un test in manuale resterebbe in BUSY per sempre."),
    ("M_Step_DescendAndPick", "9 · PICK", [
        ("Scopo:", "discesa a Z pick e attivazione della pinza"),
        ("Entry:", "bActivateGripper1 := (iGripperForThisCycle = 0)"),
        ("Azioni:", "M_Driver_Motion_Cmd a Z = Delta_Z_Pick (55 mm)"),
        ("Esito:", "ACTIVE → preso; salva TempPosConv"),
        ("Attenzione:", "la pinza si attiva prima della discesa: nessuna verifica di contatto")],
     "TempPosConv serve allo step WaitAfterPick per misurare la corsa minima."),
    ("M_Step_AscendAfterPick", "10 · PICK", [
        ("Scopo:", "risalita in quota 0 mantenendo il sync"),
        ("Entry:", "M_Driver_Motion_Cmd a Z = 0, Vel = ZPickPlaceSpeed"),
        ("Azioni:", "pinza invariata (chiusa)"),
        ("Esito:", "ACTIVE / DONE"),
        ("Attenzione:", "senza sensore pezzo, una presa mancata si vede solo sui KPI")],
     "Non esiste un controllo di presenza pezzo: la verifica è indiretta."),
    ("M_Step_MoveToParking_AfterPick", "11 · PICK", [
        ("Scopo:", "portare il robot sopra il FeedOut"),
        ("Entry:", "X/Y del frame FeedOut, Z = MIN(FeedIn.Z, FeedOut.Z), Rz = −45"),
        ("Azioni:", "transito con MinVelocity_Delta"),
        ("Esito:", "ACTIVE / DONE"),
        ("Attenzione:", "Rz = −45 è un orientamento di transito, non di processo")],
     "La quota Z usa il minimo dei due frame: scelta prudenziale."),
    ("M_Step_SelectNextProduct_Pick", "12 · PICK", [
        ("Scopo:", "decidere se c'è un secondo pezzo da prendere"),
        ("Entry:", "IF UsePointer <> StorePointer THEN xiSelectNextProduct_Pick := TRUE"),
        ("Azioni:", "altrimenti UsePointer := 0 e bGoToNextPhase := TRUE"),
        ("Esito:", "DONE con eventuale eRequestedJumpState := Initialize"),
        ("Attenzione:", "unico punto in cui il ciclo torna indietro nella playlist")],
     "Il jump esiste esattamente per il double pick."),
    ("M_Step_InitializePlace", "13 · PLACE", [
        ("Scopo:", "resetta i flag della fase di deposito"),
        ("Entry:", "preparazione variabili di place"),
        ("Azioni:", "bPlacePhaseActive := TRUE"),
        ("Esito:", "DONE immediato"),
        ("Attenzione:", "con bPlacePhaseActive TRUE il soft abort non è più permesso")],
     "Per questo uno Stop Cycle in fase place non abortisce il deposito."),
    ("M_Step_SetPlaceFrame_Tracking", "14 · PLACE", [
        ("Scopo:", "calcolare il frame del FeedOut"),
        ("Entry:", "OO/XX/XY ← aTeachFrame[2]; Execute := TRUE"),
        ("Azioni:", "attesa Done di FrameTypeTransform_FeedOut"),
        ("Esito:", "BUSY → DONE"),
        ("Attenzione:", "frame errato = depositi spostati, prese corrette")],
     "Sintomo distintivo: presa buona, deposito spostato → è il frame di uscita."),
    ("M_Step_ConvertPlaceToCartesian_Tracking", "15 · PLACE", [
        ("Scopo:", "conversione del frame di deposito"),
        ("Entry:", "conversione del frame FeedOut"),
        ("Azioni:", "nessuna logica di processo"),
        ("Esito:", "DONE / BUSY"),
        ("Attenzione:", "simmetrico allo step 4: le convenzioni vanno cambiate insieme")],
     "Pick e place sono speculari ma non identici: le finestre cambiano (500 vs 200)."),
    ("M_Step_EnablePlaceTracking", "16 · PLACE", [
        ("Scopo:", "armare il tracking sul FeedOut"),
        ("Entry:", "ConveyorBeltOrigin ← FeedOut_FrameOffset"),
        ("Azioni:", "EndDistance 200 mm, Rz iniziale = −FeedOut_FrameOffset.Rz"),
        ("Esito:", "DONE quando il tracking è attivo"),
        ("Attenzione:", "la finestra di uscita è più stretta della entrata")],
     "Se solo il deposito va 'fuori finestra', la causa è questa asimmetria."),
    ("M_Step_ApproachPlace_Tracking", "17 · PLACE", [
        ("Scopo:", "avvicinamento sopra il punto di deposito"),
        ("Entry:", "M_Driver_Motion_Cmd con X/Y di place, Z=0, Rz=−45"),
        ("Azioni:", "in inseguimento del FeedOut"),
        ("Esito:", "ACTIVE / DONE"),
        ("Attenzione:", "Rz di transito non è l'orientamento finale di deposito")],
     "Il place può essere anche in posizione fissa: il codice prevede entrambi i modi."),
    ("M_Step_WaitForPlaceSync", "18 · PLACE", [
        ("Scopo:", "attendere il sync sul nastro di uscita"),
        ("Entry:", "nessuna azione di comando"),
        ("Condizione:", "TrackConveyorBelt_FeedOut.InSync"),
        ("Azioni:", "DATA_Machine.Status.InSyncPlace_Delta := TRUE"),
        ("Attenzione:", "qui non c'è il fallback su ActualPosition = 0")],
     "Asimmetria con lo step 8: da valutare se il deposito debba poter essere testato a nastro fermo."),
    ("M_Step_DescendAndPlace", "19 · PLACE", [
        ("Scopo:", "discesa e rilascio del pezzo"),
        ("Entry:", "M_Driver_Motion_Cmd a Z = Delta_Z_Place (35 mm)"),
        ("Azioni:", "disattivazione della pinza"),
        ("Esito:", "ACTIVE / DONE"),
        ("Attenzione:", "Z place 35 < Z pick 55: il deposito è più basso")],
     "Il rilascio avviene in discesa: non c'è attesa di appoggio."),
    ("M_Step_WaitAfterPlace_Tracking", "20 · PLACE", [
        ("Scopo:", "garantire che il pezzo sia appoggiato prima di risalire"),
        ("Entry:", "nessuna azione di comando"),
        ("Condizione:", "corsa nastro minima dopo il rilascio"),
        ("Esito:", "DONE alla condizione"),
        ("Attenzione:", "se troppo corta, il pezzo può essere trascinato")],
     "Simmetrico a WaitAfterPick: si misura una corsa, non un tempo."),
    ("M_Step_AscendAfterPlace", "21 · PLACE", [
        ("Scopo:", "risalita dopo il deposito"),
        ("Entry:", "M_Driver_Motion_Cmd a Z = 0"),
        ("Azioni:", "pinze OFF"),
        ("Esito:", "ACTIVE / DONE"),
        ("Attenzione:", "un urto qui è tipico di Z di place troppo bassa")],
     "Dopo questo step ogni errore riguarda il robot, non il prodotto."),
    ("M_Step_MoveToParking_AfterPlace", "22 · PLACE", [
        ("Scopo:", "rientro verso la posizione di parcheggio"),
        ("Entry:", "movimento verso il parking"),
        ("Azioni:", "velocità MinVelocity_Delta"),
        ("Esito:", "ACTIVE / DONE"),
        ("Attenzione:", "il parking non deriva dai frame: è definito dalla playlist")],
     "Deve essere raggiungibile senza attraversare i nastri."),
    ("M_Step_CycleCompletitionAndChangeMode", "23 · PLACE", [
        ("Scopo:", "chiudere il ciclo"),
        ("Entry:", "bPlaceCycleComplete := TRUE"),
        ("Azioni:", "il manager azzera iPartOnGripper e ricarica Run o Parking"),
        ("Esito:", "DONE immediato"),
        ("Attenzione:", "la transizione non è dello step: la fa il motore")],
     "Qui il KPI chiude la piazzatura (fronte di discesa di G_bPieceInHand)."),
    ("M_Step_InitParking", "PARKING", [
        ("Scopo:", "disarmare tracking e azzerare lo stato di movimento"),
        ("Entry:", "tracking Execute := FALSE, gripper OFF"),
        ("Azioni:", "M_Driver_InitPointers() → riparte da Blend1"),
        ("Esito:", "DONE immediato"),
        ("Attenzione:", "senza InitPointers il primo movimento userebbe il blocco successivo")],
     "Reset del ring buffer: indispensabile dopo un abort."),
    ("M_Step_MoveToParking_SafePosition", "PARKING", [
        ("Scopo:", "portare il robot in posizione fuori ingombro"),
        ("Entry:", "movimento lineare verso la quota sicura"),
        ("Azioni:", "esito verificato con M_Driver_Motion_Check"),
        ("Esito:", "BUSY → DONE / ERROR"),
        ("Attenzione:", "48 righe: contiene la gestione dei casi di errore")],
     "Lo step più lungo della famiglia parking."),
    ("M_Step_FinalParkingCompletition", "PARKING", [
        ("Scopo:", "chiusura della sequenza di parking"),
        ("Entry:", "FrameTypeTransform_FeedIn/FeedOut.Execute := FALSE"),
        ("Azioni:", "CalcFrameOffset_Group.Enable := FALSE, GroupSetFrameOffset disarmati"),
        ("Esito:", "DONE immediato"),
        ("Attenzione:", "un Execute rimasto alto fa ricalcolare il frame a sorpresa")],
     "Il disarmo esplicito è ciò che rende il parking uno stato davvero a riposo."),
    ("M_Step_Error", "SERVIZIO", [
        ("Scopo:", "stato di attesa quando il sequencer è in errore"),
        ("Entry:", "bActivateGripper1/2 := FALSE"),
        ("Azioni:", "nessuna: resta BUSY"),
        ("Esito:", "BUSY fino al reset esterno"),
        ("Attenzione:", "è l'unico step che non esce da solo")],
     "Per questo il reset deve passare da M_ResetMachine."),
    ("M_Step_StartMovePath", "SERVIZIO · non in playlist", [
        ("Scopo:", "attesa di una corsa minima del nastro prima di risalire"),
        ("Stato:", "commentato in M_ConfigSequence_Run: non eseguito"),
        ("Logica:", "fbRotatePosition + io.bRun/io.bDone/io.bError"),
        ("Esito:", "BUSY / DONE / ERROR"),
        ("Attenzione:", "codice dormiente: non fa parte del ciclo produttivo")],
     "Codice storico: utile per capire l'evoluzione, fuorviante se considerato attivo."),
]


def add(d):
    B, T = d.bullets, d.table

    # ---------------------------------------------------------------- A
    d.section("A", "Appendice A · schede POU",
              "Un blocco per POU: ruolo, dipendenze, punti di attenzione",
              topics=["20 schede sintetiche", "Dipendenze", "Rischi di modifica"],
              notes="Consultazione durante gli esercizi, non da leggere tutto in aula.")
    for name, kind, items, note in POUS:
        d.two(name, kind, fmt(items[:3]), "Punti di attenzione",
              fmt(items[3:]), size=13, kicker="Appendice A · scheda POU", notes=note)

    # ---------------------------------------------------------------- B
    d.section("B", "Appendice B · schede step",
              "I 24 step del ciclo, uno per slide, più i servizi",
              topics=["13 step di pick", "11 step di place",
                      "Servizi: parking ed errore", "Esiti e criticità"],
              notes="Durante il debug si apre la scheda dello step indicato su "
                    "HMI_Data.Process.Status.Step.")
    tot = len(STEPS)
    for i, (name, tag, items, note) in enumerate(STEPS, start=1):
        d.two(name, tag, fmt(items[:3]), "Esito e punti critici", fmt(items[3:]),
              size=13, kicker=f"Appendice B · step {i}/{tot}", notes=note)

    T("Riepilogo: esiti attesi per step", ["Step", "Esito", "Condizione"], [
        ["Initialize", "DONE / BUSY", "StartCycle e modo valido"],
        ["CheckPickLimits", "DONE / BUSY", "pezzo presente in coda"],
        ["SetFrame / Convert / SetPCS", "DONE / BUSY", "Done dei FB di frame"],
        ["EnablePickTracking", "DONE", "TrackConveyorBelt.Active"],
        ["Approach / Ascend / MoveToParking", "ACTIVE / DONE", "riscontro del blocco di motion"],
        ["WaitForPickSync / PlaceSync", "DONE", "InSync (o ActualPosition = 0 per il pick)"],
        ["DescendAndPick / Place", "ACTIVE", "blocco di motion in esecuzione"],
        ["SelectNextProduct_Pick", "DONE + jump", "coda non vuota"],
        ["Error", "BUSY", "mai: richiede reset esterno"],
    ], size=11.5, col_widths=[4.2, 3.0, 5.0],
       notes="Se lo step è in BUSY, la colonna 'condizione' dice cosa manca.")

    # ---------------------------------------------------------------- C
    d.section("C", "Appendice C · esercizi in aula",
              "Otto esercizi guidati sul codice reale",
              topics=["Lettura del codice", "Parametri", "Diagnosi",
                      "Progettare una modifica"],
              notes="20-40 minuti ciascuno, in coppia, sul progetto aperto in iCube.")

    B("Esercizi 1-2: lettura e tracciamento", [
        (0, "1 — Il percorso di un comando:"),
        (1, "da HMI_Data.Axis.FeedIn.Command.JogPos fino a MC_Jog"),
        (1, "elencare tutti i passaggi; dire dove si valida il modo manuale"),
        (0, "2 — Il percorso di un dato:"),
        (1, "da Pos_X[0] del telegramma fino a HMI_Data.Tracking.X[0]"),
        (1, "elencare strutture attraversate e chi le scrive"),
        (0, "Cosa si impara:"),
        (1, "la mappa delle responsabilità e i punti di conversione"),
    ], size=16,
       notes="Correzione in plenaria: disegnare alla lavagna la catena completa "
             "dell'esercizio 2.")

    B("Esercizi 3-4: parametri e diagnosi", [
        (0, "3 — Effetto di un parametro:"),
        (1, "con TrackingWindowEnd 450 e EndDistance 500, calcolare la velocità a 420 e 448 mm"),
        (1, "dire cosa succede portando TrackingWindowEnd a 520"),
        (0, "4 — Diagnosi su carta:"),
        (1, "il ciclo si ferma sempre su EnablePickTracking: 5 cause in ordine di probabilità"),
        (1, "per ognuna, il tag da guardare sul pannello"),
        (0, "Cosa si impara:"),
        (1, "ragionare sull'invariante fisico prima che sul codice"),
    ], size=16,
       notes="Risposta dell'esercizio 3: con 520 il nastro non si ferma più prima "
             "della fine della finestra → rischio perdita di sync.")

    B("Esercizi 5-6: codice e modifiche", [
        (0, "5 — Scrivere uno step:"),
        (1, "aggiungere M_Step_CheckGripperPressure (fittizio)"),
        (1, "metodo + dispatcher + playlist; indicare cosa serve in M_ResetMachine"),
        (0, "6 — Modificare un parametro in sicurezza:"),
        (1, "spostare v_min e end_zone_margin da PickPlaceManager a DT_Machine"),
        (1, "elencare i file da toccare e i controlli successivi"),
        (0, "Cosa si impara:"),
        (1, "la checklist delle modifiche coordinate"),
        (1, "il costo reale di un parametro hardcoded"),
    ], size=16,
       notes="L'esercizio 6 porta al primo item della roadmap.")

    B("Esercizi 7-8: interfaccia e KPI", [
        (0, "7 — Nuova riga HMI:"),
        (1, "aggiungere alla pagina il tempo dall'ultima presa"),
        (1, "dove si dichiara il campo, dove si mappa, come si collega la pagina"),
        (1, "verificare che il dato esista davvero nel PLC"),
        (0, "8 — Verificare un KPI:"),
        (1, "ricostruire dal codice la formula del quality rate"),
        (1, "quali eventi lo incrementano e quali lo degradano"),
        (1, "trovare un caso in cui il valore è fuorviante"),
        (0, "Cosa si impara:"),
        (1, "la regola 'se il dato non esiste, non si inventa'"),
    ], size=16,
       notes="Risposta dell'esercizio 8: dopo un riavvio i delta negativi possono "
             "falsare il quality rate.")

    # ---------------------------------------------------------------- D
    d.section("D", "Appendice D · riferimento rapido",
              "Globali, unità, prefissi, indice dei file",
              topics=["Variabili globali", "Unità", "Prefissi", "File"],
              notes="Consultazione immediata.")

    T("Variabili globali più usate", ["Nome", "Tipo", "Chi la scrive"], [
        ["G_bAutoCycleRunning", "BOOL", "HandleAutomaticState (latch start/stop)"],
        ["G_bPieceInHand", "BOOL", "sequencer (prelievo/piazzatura)"],
        ["G_bPickPlaceError", "BOOL", "sequencer / manager"],
        ["G_bResetAllErrors / G_bAcknowledgeAllErrors", "BOOL", "HMI, azzerate da FB_ErrorHandler"],
        ["G_xKPI_ResetShift", "BOOL", "HMI, letta da FB_KPI"],
        ["G_ErrorBuffer[]", "array di struct", "FB_ErrorHandler"],
        ["G_udiErrorHead / G_udiErrorTail", "UDINT", "FB_ErrorHandler"],
        ["G_udiVisionCycles / EmptyPhotos / ProductsDetected", "UDINT", "VisionManager"],
        ["G_tVisionLastProcTime", "TIME", "VisionManager"],
    ], size=11.5, col_widths=[4.8, 2.4, 5.0],
       notes="Le G_ sono il bus interno: quando due parti devono comunicare, spesso "
             "passano da qui.")

    T("Unità e convenzioni", ["Grandezza", "Unità", "Note"], [
        ["Posizioni cartesiane", "mm", "frame MCS/WCS/PCS"],
        ["Angoli", "gradi", "deg → rad con DEG_TO_RAD"],
        ["Velocità assi", "mm/s", "VelocityUnit = 2 nei blocchi di motion"],
        ["Accelerazioni", "mm/s²", "ordine di 10^3–10^4"],
        ["Distanze visione", "mm", "telegramma ÷ 1000"],
        ["Tempi", "TIME (ms)", "TIME_TO_DINT per i KPI"],
        ["Angoli giunti", "gradi", "Feedback.Joint[0..4]"],
    ], size=12, col_widths=[3.6, 2.4, 6.0],
       notes="Errore classico: usare rad dove il resto del progetto usa gradi.")

    T("Prefissi e suffissi", ["Elemento", "Significato", "Esempio"], [
        ["i / udi / ui", "INT / UDINT / UINT", "iCurrentStepIndex, udiShPlaced"],
        ["r / lr", "REAL / LREAL", "rLatchedBeltPos, lrOffX"],
        ["b / x", "BOOL", "bStepInitialized, xVision_StartCycle"],
        ["st / e", "STRUCT / ENUM", "stMoveOption, eStepResult"],
        ["a / v", "ARRAY / VECTOR", "aBuffer_X, vFeedIn_FrameOffset"],
        ["G_ / DATA_ / HMI_", "globale / dati macchina / interfaccia", "G_bResetAllErrors"],
        ["FB_ / FC_ / M_", "function block / function / metodo", "FB_KPI, M_Step_Error"],
        ["_Old", "valore precedente (per i fronti)", "bFormatErrorOld"],
    ], size=12, col_widths=[2.6, 4.4, 5.2],
       notes="Se vedi una variabile Old, cerca il confronto che la aggiorna.")

    T("Indice dei file più consultati", ["File (content/)", "Contenuto"], [
        ["FB_PickPlace_Se~Code~0000.st", "motore del sequencer"],
        ["M_Step_*~Code~0000.st", "un file per step"],
        ["M_Driver_Motion~Code~0000.st", "porta unica verso il motion"],
        ["PickPlaceManage~Code~0000.st", "orchestrazione FastTask + rampa nastro"],
        ["FB_ConveyorC~Code~0000.st", "legge a 4 zone del nastro"],
        ["VisionManager.p~Code~0000.st", "catena di visione"],
        ["HMI.pou~Code~0000.st", "mappatura HMI + mirror Tracking"],
        ["~DT_HMI~0000.dt", "tipi dell'interfaccia HMI"],
        ["~DT_Machine~0000.dt", "DT_Machine e stati"],
        ["CFG_DAD2D28.dl", "DataList: flag OPC/RETAIN"],
    ], size=11.5, col_widths=[4.8, 7.2],
       notes="I nomi sono troncati dall'export di iCube: il riferimento certo è "
             "structure.xml.")
