(* ============================================================================
   POU      : FB_KPI
   Tipo     : FunctionBlock
   Progetto : Delta5_iCE2026_6_CELL - Yaskawa iCube Engineer 2026.6 (IC9226M-FSOE)
   Sorgente : NUOVO POU (implementazione KPI, 2026-10-12)
   Stato    : *** NUOVO: motore KPI (Key Performance Indicators) ***
   ----------------------------------------------------------------------
   NOTA: il file contiene il BODY del POU seguito da tutti i METODI,
   separati dai marcatori. Per reimportare in iCube Engineer: incollare
   il BODY nel foglio 'Code' del POU e ogni METHOD nel foglio del metodo.
   Le dichiarazioni sotto sono puramente informative: in iCE vanno
   ricreate nella tabella variabili del POU (e dei metodi per le TempVars).
   ============================================================================ *)

(*-------------------------------------------------------------------------
    FUNCTION_BLOCK FB_KPI - Motore KPI (Key Performance Indicators)

    Chiamato da Main (istanza fbKPI, retain). Legge i segnali globali e i
    contatori G_* (incrementati nei POU sorgente: VisionManager,
    FB_VisionApplication, FB_PickPlace_Sequencer1) e calcola i KPI in
    KPI_Data (globale ST_KPI_Data, RETAIN). HMI.st copia i valori da
    KPI_Data nei campi Status di HMI_Data, che il pannello legge.

    Turno = contatori resettabili (G_xKPI_ResetShift, es. a inizio turno);
    lifetime = contatori totali (mai resettati, conservati in warm start).

    Formule, sorgenti e campi HMI: vedi KPI/GUIDA_KPI.md.
    Nota: usa TIME_TO_DINT/TO_TIME (libreria standard iCE; TO_TIME
    e' gia' usata in FB_GroupController).
-------------------------------------------------------------------------*)

// --- 0. Abilitazione ---
IF NOT xEnable THEN
    KPI_Data.xKpiReady := FALSE;
    RETURN;
END_IF;
KPI_Data.xKpiReady := TRUE;

// --- 1. Rilevatori di fronte ---
rtPieceInHand(CLK := G_bPieceInHand);                       // prelievo completato (TRUE)
ftPieceInHand(CLK := G_bPieceInHand);                       // piazzatura completata (FALSE)
rtPickErr(CLK := G_bPickPlaceError);                        // errore pick&place
rtTrigger(CLK := xPhysTriggerCamera);                       // impulso trigger fisico
rtLatchDone(CLK := DATA_FeedInAxis.Status.TouchProbeDone);  // latch catturato
rtReset(CLK := xResetShift);                                // reset contatori turno

// --- 2. Tick 1 s e 1 min (free-running) ---
tonSec(IN := NOT tonSec.Q, PT := T#1S);
tonMin(IN := NOT tonMin.Q, PT := T#1M);

// --- 3. Avvio cronometri (prima scansione) ---
IF NOT bTimerInit THEN
    bTimerInit := TRUE;
    bCycleTimerRun := TRUE;
END_IF;

// --- 4. Reset contatori turno ---
IF rtReset.Q THEN
    udiShPlaced := 0; udiShPicked := 0; udiShCycles := 0; udiShCyclesGood := 0;
    udiShPickErr := 0; udiShVisionCycles := 0; udiShEmptyPhotos := 0; udiShDetected := 0;
    udiShTriggers := 0; udiShLatch := 0; udiShLatchTo := 0; udiShStray := 0;
    udiShErrors := 0; udiShStateAuto := 0; udiShStateManual := 0; udiShStateStopping := 0;
    udiShStateError := 0; udiShStateOther := 0; udiShTimeErrSec := 0; udiShUptimeSec := 0;
    udiShSinceErrSec := 0;
    udiPlacedThisSec := 0; udiPlacedThisMin := 0; iSecIdx := 0; iMinIdx := 0;
    rCycleSumMs := 0.0; rCycleMinMs := 999999999.0; rCycleMaxMs := 0.0; rCycleLastMs := 0.0;
    rPickSumMs := 0.0; rPickLastMs := 0.0;
    rProcSumMs := 0.0; rProcMinMs := 999999999.0; rProcMaxMs := 0.0; rProcLastMs := 0.0;
    rErrEpisodeSumMs := 0.0; udiErrEpisodes := 0;
    bCycleHadError := FALSE; bErrorEpisode := FALSE; bErrTimerRun := FALSE;
    bFirstCycle := TRUE; tProcOld := T#0MS;
    FOR i := 0 TO 59 DO
        aPlacedSec[i] := 0;
        aPlacedMin[i] := 0;
    END_FOR;
END_IF;

// --- 5. Contatori da eventi (fronti) ---
// Prelievo completato (G_bPieceInHand TRUE): avvia il tempo di prelievo
IF rtPieceInHand.Q THEN
    udiShPicked := udiShPicked + 1;
    udiLifePicked := udiLifePicked + 1;
    bPickTimerRun := TRUE;
END_IF;

// Piazzatura completata (G_bPieceInHand FALSE): fine ciclo
IF ftPieceInHand.Q THEN
    bPickTimerRun := FALSE;
    udiShPlaced := udiShPlaced + 1;
    udiLifePlaced := udiLifePlaced + 1;
    udiPlacedThisSec := udiPlacedThisSec + 1;
    udiPlacedThisMin := udiPlacedThisMin + 1;
    udiShCycles := udiShCycles + 1;
    udiLifeCycles := udiLifeCycles + 1;
    IF NOT bCycleHadError THEN
        udiShCyclesGood := udiShCyclesGood + 1;
    END_IF;
    bCycleHadError := FALSE;
    // tempo di ciclo (place -> place)
    IF NOT bFirstCycle THEN
        rCycleLastMs := TO_LREAL(TIME_TO_DINT(tonCycle.ET));
        rCycleSumMs := rCycleSumMs + rCycleLastMs;
        IF rCycleLastMs < rCycleMinMs THEN rCycleMinMs := rCycleLastMs; END_IF;
        IF rCycleLastMs > rCycleMaxMs THEN rCycleMaxMs := rCycleLastMs; END_IF;
    END_IF;
    bFirstCycle := FALSE;
    bCycleTimerRun := FALSE;
    // tempo di prelievo (pick -> place)
    rPickLastMs := TO_LREAL(TIME_TO_DINT(tonPick.ET));
    rPickSumMs := rPickSumMs + rPickLastMs;
END_IF;

// Errore pick&place
IF rtPickErr.Q THEN
    udiShPickErr := udiShPickErr + 1;
    bCycleHadError := TRUE;
END_IF;

// Impulso trigger fisico (sync SLIO)
IF rtTrigger.Q THEN
    udiShTriggers := udiShTriggers + 1;
    udiLifeTriggers := udiLifeTriggers + 1;
END_IF;

// Latch catturato (posizione nastro agganciata)
IF rtLatchDone.Q THEN
    udiShLatch := udiShLatch + 1;
    udiLifeLatch := udiLifeLatch + 1;
    KPI_Data.rLastLatchedPos := DATA_FeedInAxis.Feedback.TouchProbeRecPos;
END_IF;

// --- 6. Cronometri (chiamati con sintassi standard) ---
tonCycle(IN := bCycleTimerRun, PT := T#600S);
tonPick(IN := bPickTimerRun, PT := T#60S);
IF ftPieceInHand.Q THEN
    bCycleTimerRun := TRUE;   // riparte da zero dopo ogni piazzatura
END_IF;

// --- 7. Contatori da delta dei contatori G_ (visione / sync) ---
IF G_udiVisionCycles <> udiVisionCyclesOld THEN
    udiDelta := G_udiVisionCycles - udiVisionCyclesOld;
    udiShVisionCycles := udiShVisionCycles + udiDelta;
    udiLifeVision := udiLifeVision + udiDelta;
    udiVisionCyclesOld := G_udiVisionCycles;
END_IF;
IF G_udiVisionEmptyPhotos <> udiEmptyOld THEN
    udiDelta := G_udiVisionEmptyPhotos - udiEmptyOld;
    udiShEmptyPhotos := udiShEmptyPhotos + udiDelta;
    udiEmptyOld := G_udiVisionEmptyPhotos;
END_IF;
IF G_udiProductsDetected <> udiDetectedOld THEN
    udiDelta := G_udiProductsDetected - udiDetectedOld;
    udiShDetected := udiShDetected + udiDelta;
    udiDetectedOld := G_udiProductsDetected;
END_IF;
IF G_udiLatchTimeouts <> udiLatchToOld THEN
    udiDelta := G_udiLatchTimeouts - udiLatchToOld;
    udiShLatchTo := udiShLatchTo + udiDelta;
    udiLatchToOld := G_udiLatchTimeouts;
END_IF;
IF G_udiStrayLatches <> udiStrayOld THEN
    udiDelta := G_udiStrayLatches - udiStrayOld;
    udiShStray := udiShStray + udiDelta;
    udiStrayOld := G_udiStrayLatches;
END_IF;

// Tempo di elaborazione visione (aggiornato da VisionManager ad ogni ciclo)
IF G_tVisionLastProcTime <> tProcOld THEN
    rProcLastMs := TO_LREAL(TIME_TO_DINT(G_tVisionLastProcTime));
    rProcSumMs := rProcSumMs + rProcLastMs;
    IF rProcLastMs < rProcMinMs THEN rProcMinMs := rProcLastMs; END_IF;
    IF rProcLastMs > rProcMaxMs THEN rProcMaxMs := rProcLastMs; END_IF;
    tProcOld := G_tVisionLastProcTime;
END_IF;

// --- 8. Eventi errore (buffer) episodi MTTR ---
IF G_udiErrorHead <> udiErrorHeadOld THEN
    udiShErrors := udiShErrors + 1;
    udiLifeErrors := udiLifeErrors + 1;
    udiShSinceErrSec := 0;
    udiErrorHeadOld := G_udiErrorHead;
END_IF;
// episodio errore (attivo -> risolto) per MTTR
IF G_stOverallErrorStatus.udiActiveErrorCount > 0 THEN
    IF NOT bErrorEpisode THEN
        bErrorEpisode := TRUE;
        bErrTimerRun := TRUE;
    END_IF;
ELSE
    IF bErrorEpisode THEN
        bErrTimerRun := FALSE;
        rErrEpisodeSumMs := rErrEpisodeSumMs + TO_LREAL(TIME_TO_DINT(tonErrorEpisode.ET));
        udiErrEpisodes := udiErrEpisodes + 1;
        bErrorEpisode := FALSE;
    END_IF;
END_IF;
tonErrorEpisode(IN := bErrTimerRun, PT := T#24H);

// --- 9. Tick 1 s: uptime, stati, anelli rate, pareto errori ---
IF tonSec.Q THEN
    udiShUptimeSec := udiShUptimeSec + 1;
    udiLifeUptimeSec := udiLifeUptimeSec + 1;
    udiShSinceErrSec := udiShSinceErrSec + 1;
    IF G_stOverallErrorStatus.udiActiveErrorCount > 0 THEN
        udiShTimeErrSec := udiShTimeErrSec + 1;
    END_IF;
    // tempo per stato macchina (secondi)
    CASE State_MachineController OF
        E_MachineState#OPERATIONAL_AUTOMATIC: udiShStateAuto := udiShStateAuto + 1;
        E_MachineState#OPERATIONAL_MANUAL:    udiShStateManual := udiShStateManual + 1;
        E_MachineState#STOPPING:              udiShStateStopping := udiShStateStopping + 1;
        E_MachineState#ERROR:                 udiShStateError := udiShStateError + 1;
    ELSE
        udiShStateOther := udiShStateOther + 1;
    END_CASE;
    // anello pezzi al secondo (per pezzi/min)
    aPlacedSec[iSecIdx] := udiPlacedThisSec;
    udiPlacedThisMin := udiPlacedThisMin + udiPlacedThisSec;
    udiPlacedThisSec := 0;
    iSecIdx := (iSecIdx + 1) MOD 60;
    // anello pezzi al minuto (per pezzi/ora)
    IF tonMin.Q THEN
        aPlacedMin[iMinIdx] := udiPlacedThisMin;
        udiPlacedThisMin := 0;
        iMinIdx := (iMinIdx + 1) MOD 60;
    END_IF;
    // pareto errori: ultimi 50 nel buffer, per categoria (sorgente)
    udiParVision := 0; udiParTracking := 0; udiParMotion := 0;
    udiParMachine := 0; udiParPickPlace := 0; udiParOther := 0;
    
END_IF;

// --- 10. Rate e KPI calcolati ---
rPPM := 0.0;
rPerHour := 0.0;
FOR i := 0 TO 59 DO
    rPPM := rPPM + TO_REAL(aPlacedSec[i]);
    rPerHour := rPerHour + TO_REAL(aPlacedMin[i]);
END_FOR;

udiStateTotal := udiShStateAuto + udiShStateManual + udiShStateStopping + udiShStateError + udiShStateOther;
IF udiStateTotal > 0 THEN
    rAvailability := TO_REAL(udiShStateAuto + udiShStateManual) / TO_REAL(udiStateTotal);
ELSE
    rAvailability := 0.0;
END_IF;

IF udiShCycles > 0 THEN
    rCycleAvgMs := rCycleSumMs / TO_REAL(udiShCycles);
    rCycleSuccess := TO_REAL(udiShCyclesGood) / TO_REAL(udiShCycles);
ELSE
    rCycleAvgMs := 0.0;
    rCycleSuccess := 0.0;
END_IF;

IF udiShPicked > 0 THEN
    rPickAvgMs := rPickSumMs / TO_REAL(udiShPicked);
ELSE
    rPickAvgMs := 0.0;
END_IF;

IF (udiShPicked + udiShPickErr) > 0 THEN
    rPickSuccess := TO_REAL(udiShPicked) / TO_REAL(udiShPicked + udiShPickErr);
ELSE
    rPickSuccess := 0.0;
END_IF;

IF udiShVisionCycles > 0 THEN
    rDetRate := TO_REAL(udiShVisionCycles - udiShEmptyPhotos) / TO_REAL(udiShVisionCycles);
    rAvgPerPhoto := TO_REAL(udiShDetected) / TO_REAL(udiShVisionCycles);
    rProcAvgMs := rProcSumMs / TO_REAL(udiShVisionCycles);
ELSE
    rDetRate := 0.0;
    rAvgPerPhoto := 0.0;
    rProcAvgMs := 0.0;
END_IF;

IF udiShTriggers > 0 THEN
    rLatchRate := TO_REAL(udiShLatch) / TO_REAL(udiShTriggers);
ELSE
    rLatchRate := 0.0;
END_IF;

IF (udiShUptimeSec > 0) AND (udiShErrors > 0) THEN
    rMTBFms := TO_REAL(udiShUptimeSec) * 1000.0 / TO_REAL(udiShErrors);
ELSE
    rMTBFms := 0.0;
END_IF;

IF udiErrEpisodes > 0 THEN
    rMTTRms := rErrEpisodeSumMs / TO_REAL(udiErrEpisodes);
ELSE
    rMTTRms := 0.0;
END_IF;

// OEE: performance = ideal/actual (max 100%), quality = piazzati/(piazzati+errori prelievo)
rIdealMs := TO_REAL(TIME_TO_DINT(KPI_Data.tIdealCycleTime));
IF (rCycleAvgMs > 0.0) AND (rIdealMs > 0.0) THEN
    rPerformance := rIdealMs / rCycleAvgMs;
    IF rPerformance > 1.0 THEN rPerformance := 1.0; END_IF;
ELSE
    rPerformance := 0.0;
END_IF;
IF (udiShPlaced + udiShPickErr) > 0 THEN
    rQuality := TO_REAL(udiShPlaced) / TO_REAL(udiShPlaced + udiShPickErr);
ELSE
    rQuality := 0.0;
END_IF;
rOEE := rAvailability * rPerformance * rQuality;

IF udiShPlaced > 0 THEN
    rDetectedVsPlaced := TO_REAL(udiShDetected) / TO_REAL(udiShPlaced);
ELSE
    rDetectedVsPlaced := 0.0;
END_IF;

// Stato corrente (INT per HMI)
CASE State_MachineController OF
    E_MachineState#INIT:                   iCurrentState := 0;
    E_MachineState#IDLE:                   iCurrentState := 1;
    E_MachineState#TEACH_FRAME:            iCurrentState := 2;
    E_MachineState#POWERING_UP:            iCurrentState := 3;
    E_MachineState#HOMING:                 iCurrentState := 4;
    E_MachineState#WAIT_FOR_COMMISSIONING: iCurrentState := 5;
    E_MachineState#OPERATIONAL_AUTOMATIC:  iCurrentState := 6;
    E_MachineState#OPERATIONAL_MANUAL:     iCurrentState := 7;
    E_MachineState#STOPPING:               iCurrentState := 8;
    E_MachineState#UNPOWERING:             iCurrentState := 9;
    E_MachineState#SHUTDOWN:               iCurrentState := 10;
    E_MachineState#ERROR:                  iCurrentState := 11;
ELSE
    iCurrentState := 1;
END_CASE;

// --- 11. Copia in KPI_Data ---
KPI_Data.udiPiecesPlaced := udiShPlaced;
KPI_Data.udiPiecesPicked := udiShPicked;
KPI_Data.udiCyclesTotal := udiShCycles;
KPI_Data.udiCyclesGood := udiShCyclesGood;
KPI_Data.udiPickErrors := udiShPickErr;
KPI_Data.rProductsPerMin := rPPM;
KPI_Data.rProductionPerHour := rPerHour;
KPI_Data.tCycleTimeLast := TO_TIME(TO_DINT(rCycleLastMs));
KPI_Data.tCycleTimeAvg := TO_TIME(TO_DINT(rCycleAvgMs));
IF udiShCycles > 0 THEN
    KPI_Data.tCycleTimeMin := TO_TIME(TO_DINT(rCycleMinMs));
    KPI_Data.tCycleTimeMax := TO_TIME(TO_DINT(rCycleMaxMs));
ELSE
    KPI_Data.tCycleTimeMin := T#0MS;
    KPI_Data.tCycleTimeMax := T#0MS;
END_IF;
KPI_Data.tPickTimeLast := TO_TIME(TO_DINT(rPickLastMs));
KPI_Data.tPickTimeAvg := TO_TIME(TO_DINT(rPickAvgMs));
KPI_Data.rCycleSuccessRate := rCycleSuccess * 100.0;
KPI_Data.rPickSuccessRate := rPickSuccess * 100.0;
KPI_Data.udiVisionCycles := udiShVisionCycles;
KPI_Data.udiVisionGoodPhotos := udiShVisionCycles - udiShEmptyPhotos;
KPI_Data.udiVisionEmptyPhotos := udiShEmptyPhotos;
KPI_Data.udiProductsDetected := udiShDetected;
KPI_Data.rVisionDetectionRate := rDetRate * 100.0;
KPI_Data.rAvgProductsPerPhoto := rAvgPerPhoto;
KPI_Data.tVisionProcLast := TO_TIME(TO_DINT(rProcLastMs));
KPI_Data.tVisionProcAvg := TO_TIME(TO_DINT(rProcAvgMs));
IF udiShVisionCycles > 0 THEN
    KPI_Data.tVisionProcMax := TO_TIME(TO_DINT(rProcMaxMs));
ELSE
    KPI_Data.tVisionProcMax := T#0MS;
END_IF;
KPI_Data.udiTriggers := udiShTriggers;
KPI_Data.udiLatchCaptured := udiShLatch;
KPI_Data.udiLatchTimeouts := udiShLatchTo;
KPI_Data.udiStrayLatches := udiShStray;
KPI_Data.rLatchSuccessRate := rLatchRate * 100.0;
KPI_Data.xTrackingActive := G_xTrackingActive;
KPI_Data.udiTrackingErrors := udiParTracking;
KPI_Data.rDetectedVsPlaced := rDetectedVsPlaced;
KPI_Data.tStateAutomatic := TO_TIME(TO_DINT(udiShStateAuto * 1000));
KPI_Data.tStateManual := TO_TIME(TO_DINT(udiShStateManual * 1000));
KPI_Data.tStateStopping := TO_TIME(TO_DINT(udiShStateStopping * 1000));
KPI_Data.tStateError := TO_TIME(TO_DINT(udiShStateError * 1000));
KPI_Data.tStateOther := TO_TIME(TO_DINT(udiShStateOther * 1000));
KPI_Data.rAvailability := rAvailability * 100.0;
KPI_Data.udiErrorEvents := udiShErrors;
KPI_Data.udiErrorsActive := G_stOverallErrorStatus.udiActiveErrorCount;
KPI_Data.eHighestSeverity := G_stOverallErrorStatus.eHighestSeverity;
KPI_Data.tTimeWithErrors := TO_TIME(TO_DINT(udiShTimeErrSec * 1000));
KPI_Data.tMTBF := TO_TIME(TO_DINT(rMTBFms));
KPI_Data.tMTTR := TO_TIME(TO_DINT(rMTTRms));
KPI_Data.udiErrVision := udiParVision;
KPI_Data.udiErrTracking := udiParTracking;
KPI_Data.udiErrMotion := udiParMotion;
KPI_Data.udiErrMachine := udiParMachine;
KPI_Data.udiErrPickPlace := udiParPickPlace;
KPI_Data.udiErrOther := udiParOther;
KPI_Data.rPerformance := rPerformance * 100.0;
KPI_Data.rQuality := rQuality * 100.0;
KPI_Data.rOEE := rOEE * 100.0;
KPI_Data.udiPiecesPlacedTotal := udiLifePlaced;
KPI_Data.udiPiecesPickedTotal := udiLifePicked;
KPI_Data.udiCyclesTotalLife := udiLifeCycles;
KPI_Data.udiVisionCyclesTotal := udiLifeVision;
KPI_Data.udiTriggersTotal := udiLifeTriggers;
KPI_Data.udiLatchCapturedTotal := udiLifeLatch;
KPI_Data.udiErrorEventsTotal := udiLifeErrors;
KPI_Data.tUptimeTotal := TO_TIME(TO_DINT(udiLifeUptimeSec * 1000));
KPI_Data.tUptime := TO_TIME(TO_DINT(udiShUptimeSec * 1000));
IF udiShErrors > 0 THEN
    KPI_Data.tSinceLastError := TO_TIME(TO_DINT(udiShSinceErrSec * 1000));
ELSE
    KPI_Data.tSinceLastError := TO_TIME(TO_DINT(udiShUptimeSec * 1000));
END_IF;
KPI_Data.iCurrentState := iCurrentState;
