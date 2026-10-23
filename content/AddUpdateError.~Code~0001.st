(*
====================================================================================================
 PRIVATE METHOD AddUpdateError
====================================================================================================
 Now called exclusively by the Update() method when emptying the queue.
 The RTC block call has been removed to ensure performance and safety.
====================================================================================================
*)

// --- 1. Determine final error message ---
IF bErrorDetected THEN
    IF LEN(sErrorMessage) > 0 THEN
        sFinalErrorMessage := sErrorMessage;
    ELSE
        sFinalErrorMessage := THIS.GetErrorMessage(udiErrorID);
    END_IF;
END_IF;

// --- 2. Find existing error in buffer ---
FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
    IF G_ErrorBuffer[i].ErrorCode = udiErrorID AND G_ErrorBuffer[i].ErrorSource = sErrorSource THEN
        IF G_ErrorBuffer[i].IsActive THEN
            udiActiveMatchIndex := i; 
            EXIT; 
        END_IF
    END_IF;
    
    IF G_ErrorBuffer[i].ErrorSource = sErrorSource AND G_ErrorBuffer[i].IsActive AND NOT(bErrorDetected) THEN
        udiInactiveMatchIndex := i;
        EXIT; 
    END_IF;
END_FOR;

// --- 3. Main State Logic ---
IF bErrorDetected THEN 
    
    IF udiActiveMatchIndex = 0 THEN
        // --- CASE 1: NEW ERROR (Rising Edge) ---
        G_ErrorBuffer[G_udiErrorHead].ErrorCode := udiErrorID;
        G_ErrorBuffer[G_udiErrorHead].ErrorSource := sErrorSource;
        G_ErrorBuffer[G_udiErrorHead].ErrorMessage := sFinalErrorMessage;
        G_ErrorBuffer[G_udiErrorHead].Severity := eErrorSeverity;
        G_ErrorBuffer[G_udiErrorHead].IsActive := TRUE;
        G_ErrorBuffer[G_udiErrorHead].Timestamp := tCurrentSysTime; // Use pre-read time
        G_ErrorBuffer[G_udiErrorHead].Acknowledged := FALSE;

        G_udiErrorHead := G_udiErrorHead + 1;
        IF G_udiErrorHead > C_ERROR_BUFFER_SIZE THEN
            G_udiErrorHead := 1;
        END_IF;

        IF G_udiErrorHead = G_udiErrorTail THEN
            G_bBufferFull := TRUE;
            G_udiErrorTail := G_udiErrorTail + 1; 
            IF G_udiErrorTail > C_ERROR_BUFFER_SIZE THEN G_udiErrorTail := 1; END_IF;
        END_IF;
        
        G_stOverallErrorStatus.udiActiveErrorCount := G_stOverallErrorStatus.udiActiveErrorCount + 1;
        G_stOverallErrorStatus.bAnyErrorActive := TRUE;
        IF eErrorSeverity > G_stOverallErrorStatus.eHighestSeverity THEN
            G_stOverallErrorStatus.eHighestSeverity := eErrorSeverity;
        END_IF;
        
        bActionPerformed := TRUE;
    ELSE
        // --- CASE 2: ERROR STILL ACTIVE ---
        G_ErrorBuffer[udiActiveMatchIndex].Severity := eErrorSeverity;
        
        IF G_ErrorBuffer[udiActiveMatchIndex].Acknowledged THEN
             G_ErrorBuffer[udiActiveMatchIndex].Acknowledged := FALSE;
             G_ErrorBuffer[udiActiveMatchIndex].Timestamp := tCurrentSysTime;
        END_IF;
        
        IF eErrorSeverity > G_stOverallErrorStatus.eHighestSeverity THEN
            G_stOverallErrorStatus.eHighestSeverity := eErrorSeverity;
        ELSIF eErrorSeverity < G_ErrorBuffer[udiActiveMatchIndex].Severity THEN
            THIS.RecalculateHighestSeverity();
        END_IF;

        bActionPerformed := TRUE; 
    END_IF;

ELSE 

    IF udiInactiveMatchIndex <> 0 THEN
        // --- CASE 3: ERROR RESOLVED (Falling Edge) ---
        G_ErrorBuffer[udiInactiveMatchIndex].IsActive := FALSE;
        bActionPerformed := TRUE;
        
        G_stOverallErrorStatus.udiActiveErrorCount := G_stOverallErrorStatus.udiActiveErrorCount - 1;

        IF G_stOverallErrorStatus.udiActiveErrorCount = 0 THEN
            G_stOverallErrorStatus.bAnyErrorActive := FALSE;
            G_stOverallErrorStatus.eHighestSeverity := E_ErrorSeverity#None;
        ELSE
            THIS.RecalculateHighestSeverity();
        END_IF;
    ELSE
        // --- CASE 4: ERROR STILL INACTIVE ---
        bActionPerformed := FALSE;
    END_IF;
END_IF;

AddUpdateError := bActionPerformed;