// METHOD: M_Step_EnablePickTracking
// DESCRIPTION: Activates conveyor tracking for Feed In.  

	
TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[1] := FeedIn_FrameOffset.X;
TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[2] := FeedIn_FrameOffset.Y;
TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[3] := FeedIn_FrameOffset.Z;
TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[4] := FeedIn_FrameOffset.Rx;
TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[5] := FeedIn_FrameOffset.Ry;
TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[6] := FeedIn_FrameOffset.Rz;

TrackConveyorBelt_FeedIn.InitialObjectPosition[1] := MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[1] - vFeedIn_FrameOffset[1]; 
TrackConveyorBelt_FeedIn.InitialObjectPosition[2] := MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[2] - vFeedIn_FrameOffset[2];


IF MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[6] < -90.0 THEN
    TrackConveyorBelt_FeedIn.InitialObjectPosition[6] := MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[6] - vFeedIn_FrameOffset[6] + 90.0;
ELSIF MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[6] > 90.0 THEN
    TrackConveyorBelt_FeedIn.InitialObjectPosition[6] := MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[6] - vFeedIn_FrameOffset[6] - 90.0;
ELSE  
    TrackConveyorBelt_FeedIn.InitialObjectPosition[6] := MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[6] - vFeedIn_FrameOffset[6];
END_IF

// Configure synchronization options for tracking
TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.Mode := Yt_TrackProfileMode#MasterDistance;
TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.ConveyorDistance := 10.0; // Defines the distance traveled by conveyor during SyncIn
TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.TCPDistance := TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.ConveyorDistance / 2.0; // Defines the distance the TCP travels during SyncIn
TrackConveyorBelt_FeedIn.TrackOptions.SyncOut.ConveyorDistance := 15.0;
			
// Select the conveyor belt axis and tracking distances based on the active mode
TrackConveyorBelt_FeedIn.ConveyorBelt := FeedIn_Ref;
TrackConveyorBelt_FeedIn.StartDistance := 10.0; // Start tracking distance on the conveyor
TrackConveyorBelt_FeedIn.EndDistance := 500.0; // End tracking distance on the conveyor
TrackConveyorBelt_FeedIn.RecordedPosition := MultiGrpProductData[0].ProductDetails[UsePointer].RecordedPosition + DATA_Machine.Setting.OffsetCamera; // DATA_FeedInAxis.Feedback.ActualPosition; // Use the actual linear axis position as the recorded position

// 1. Entry Action
IF NOT bStepInitialized THEN
   //(TrackConveyorBelt_FeedIn.RecordedPosition > DATA_FeedInAxis.Feedback.ActualPosition) THEN
    TrackConveyorBelt_FeedIn.Execute := TRUE;
    
    fbRotatePosition.fDeltaRz := MultiGrpProductData[0].ProductDetails[UsePointer].ProductPosition[6];
    fbRotatePosition.bExecute := TRUE;

    bStepInitialized := TRUE;
    M_Step_EnablePickTracking := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic Check
IF TrackConveyorBelt_FeedIn.Active THEN
    M_Step_EnablePickTracking := E_StepStatus#DONE;
ELSIF TrackConveyorBelt_FeedIn.Error THEN
    M_Step_EnablePickTracking := E_StepStatus#ERROR;
ELSE
    M_Step_EnablePickTracking := E_StepStatus#BUSY;
END_IF;

(*
// METHOD: M_Step_EnablePickTracking
// DESCRIPTION: Activates conveyor tracking for Feed In.

// ========== EARLY RETURNS (questi sono OK) ==========
IF TrackConveyorBelt_FeedIn.Error THEN
    M_Step_EnablePickTracking := E_StepStatus#ERROR;
ELSIF TrackConveyorBelt_FeedIn.Active THEN
    M_Step_EnablePickTracking := E_StepStatus#DONE;



// =========================================================
// 1. ENTRY ACTION (Eseguita finché non si attiva il Tracking)
// =========================================================
ELSIF NOT bStepInitialized THEN

    // A. CONTROLLO BUFFER "REAL TIME"
    // Confronto i puntatori: se sono diversi, c'è un prodotto.
    IF MultiGrpProductData[1].UsePointer <> MultiGrpProductData[1].StorePointer THEN

        // --- 1. RECUPERO DATI DAL BUFFER ---
        // Leggo l'indice attuale di utilizzo
        UsePointer := MultiGrpProductData[1].UsePointer;
        
        // ⚠️ CHECK VALIDITÀ
//        IF NOT aBuffer_Valid[iReadIndex] THEN
//            // Dato non valido (foto vuota) - salta e vai al prossimo
//            xRobot_DataSkipped := TRUE;  // ⚠️ SEGNALA al task Vision
//            M_Step_EnablePickTracking := E_StepStatus#BUSY;
//            //RETURN; // Riprova col prossimo dato
//        END_IF;

        // Recupero la posizione di Latch (quella corretta che abbiamo sovrascritto nel Main)
        rTriggeredPos := aBuffer_Pos[iReadIndex];
    
        // --- 2. CHECK DI FATTIBILITÀ ---
        // Calcolo dove si trova il nastro ORA
        rCurrentPos := DATA_FeedInAxis.Feedback.ActualPosition;

        // Calcolo il punto di non ritorno:
        // Se il nastro ha superato (PosizioneRegistrata + DistanzaDiAvvio),
        // il blocco MC_TrackConveyorBelt andrà in errore perché non ha spazio per sincronizzarsi.
        // Aggiungo un piccolo margine di sicurezza (es. 5.0 mm) se necessario.
        rPointOfNoReturn := rTriggeredPos + 10.0; // Usa lo stesso valore di 'StartDistance' sotto

        // --- 3. DECISIONE: SCARTO O ESEGUO? ---
//        IF (NOT aBuffer_Valid[iReadIndex]) OR (rCurrentPos > rPointOfNoReturn) THEN
//            xRobot_DataSkipped := TRUE;  // ⚠️ SEGNALA al task Vision
//
//            // 3. NON attivo bStepInitialized!
//            // Rimanendo FALSE, al prossimo ciclo di PLC rientrerò qui in alto
//            // e controllerò immediatamente il prossimo prodotto nella coda.
//            
//            M_Step_EnablePickTracking := E_StepStatus#BUSY;
//            //RETURN; // Esco e riprovo subito al prossimo ciclo
//        
//        ELSE
            
            // >>> CASO: OK, SIAMO IN TEMPO <<<
            // Posso attivare il tracking.
            
            // 1. Mappatura Dati al Blocco Tracking
            TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[1] := MultiGrpProductData[1].ProductDetails[UsePointer].ProductPosition[1];
            TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[2] := MultiGrpProductData[1].ProductDetails[UsePointer].ProductPosition[2];
            TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[3] := vFeedIn_FrameOffset[3];
            TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[4] := vFeedIn_FrameOffset[4];
            TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[5] := vFeedIn_FrameOffset[5];
            TrackConveyorBelt_FeedIn.ConveyorBeltOrigin[6] := vFeedIn_FrameOffset[6];
    
            TrackConveyorBelt_FeedIn.InitialObjectPosition[1] := 0.0; 
            TrackConveyorBelt_FeedIn.InitialObjectPosition[2] := 0.0; 
            TrackConveyorBelt_FeedIn.InitialObjectPosition[6] := 0.0; //MultiGrpProductData[1].ProductDetails[UsePointer].ProductPosition[6]; // Rotazione pezzo
            
            // 2. Configurazione Opzioni Sincronizzazione
            TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.Mode := Yt_TrackProfileMode#MasterDistance;
            TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.ConveyorDistance := 30.0; 
            TrackConveyorBelt_FeedIn.TrackOptions.SyncIn.TCPDistance := 15.0; 
            TrackConveyorBelt_FeedIn.TrackOptions.SyncOut.ConveyorDistance := 60.0;
    
            // 3. Configurazione Asse e Distanze
            TrackConveyorBelt_FeedIn.ConveyorBelt  := MultiGrpProductData[1].ProductDetails[UsePointer].ConveyorBelt; // FeedIn_Ref;
            TrackConveyorBelt_FeedIn.StartDistance := 10.0; // Deve coincidere col check sopra
            TrackConveyorBelt_FeedIn.EndDistance   := 200.0; 
        	TrackConveyorBelt_FeedIn.RecordedPosition := MultiGrpProductData[1].ProductDetails[UsePointer].RecordedPosition + OffsetCamera;//DATA_FeedInAxis.Feedback.ActualPosition; // Use the actual linear axis position as the recorded position
        	
            // 4. ATTIVAZIONE
            TrackConveyorBelt_FeedIn.Execute := TRUE;
    
            // ⚠️ SEGNALA al task Vision che hai consumato il dato
            xRobot_DataConsumed := TRUE;
    
            // 6. Passo alla fase ciclica
            bStepInitialized := TRUE;
            M_Step_EnablePickTracking := E_StepStatus#BUSY;
            
//        END_IF;
    ELSE
        // Buffer Vuoto: Aspetto nuovi prodotti dalla visione
        M_Step_EnablePickTracking := E_StepStatus#BUSY;
        RETURN;
    END_IF;
ELSE
    // Siamo in attesa che il blocco risponda all'Execute
    M_Step_EnablePickTracking := E_StepStatus#BUSY;
END_IF;
*)