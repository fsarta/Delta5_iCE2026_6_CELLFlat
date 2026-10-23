// Detect rising edge for reset command
xResetErrorsR_TRIG(CLK := bResetErrors OR G_bResetAllErrors);
IF xResetErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        G_ErrorBuffer[i].IsActive := FALSE;     // Mark all as inactive
        G_ErrorBuffer[i].Acknowledged := FALSE; // Clear acknowledgement
        G_ErrorBuffer[i].ErrorCode := 0;        // Clear error code
        G_ErrorBuffer[i].ErrorSource := '';     // Clear source
        G_ErrorBuffer[i].ErrorMessage := '';    // Clear message
        G_ErrorBuffer[i].Severity := E_ErrorSeverity#None; // Clear severity
    END_FOR
    G_udiErrorHead := 1;
    G_udiErrorTail := 1;
    G_bBufferFull := FALSE;
    G_bResetAllErrors := FALSE; // Clear global command
END_IF

// Detect rising edge for acknowledge command
xAcknowledgeErrorsR_TRIG(CLK := bAcknowledgeErrors OR G_bAcknowledgeAllErrors);
IF xAcknowledgeErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        IF G_ErrorBuffer[i].IsActive THEN
            G_ErrorBuffer[i].Acknowledged := TRUE; // Acknowledge all active errors
        END_IF
    END_FOR
    G_bAcknowledgeAllErrors := FALSE; // Clear global command
END_IF

// Recalculate overall error state and count from the buffer
FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
    IF G_ErrorBuffer[i].IsActive THEN
        udiActiveCountLocal := udiActiveCountLocal + 1;
        bAnyActiveLocal := TRUE;
        IF G_ErrorBuffer[i].Severity > eHighestSeverityLocal THEN
            eHighestSeverityLocal := G_ErrorBuffer[i].Severity;
        END_IF
    END_IF
END_FOR

// Update the global status structure
G_stOverallErrorStatus.udiActiveErrorCount := udiActiveCountLocal;
G_stOverallErrorStatus.bAnyErrorActive := (udiActiveCountLocal > 0);
G_stOverallErrorStatus.eHighestSeverity := eHighestSeverityLocal;
G_stOverallErrorStatus.bBufferFull := G_bBufferFull; // Copy the buffer full status