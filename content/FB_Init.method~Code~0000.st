// Initialize buffer at startup
IF bInitRetains THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        G_ErrorBuffer[i].IsActive := FALSE;
        G_ErrorBuffer[i].ErrorCode := 0;
        G_ErrorBuffer[i].ErrorSource := '';
        G_ErrorBuffer[i].ErrorMessage := '';
        G_ErrorBuffer[i].Severity := E_ErrorSeverity#None;
        G_ErrorBuffer[i].Acknowledged := FALSE;
    END_FOR
    G_udiErrorHead := 1;
    G_udiErrorTail := 1;

    // Initialize the new global status structure
    G_stOverallErrorStatus.bAnyErrorActive := FALSE;
    G_stOverallErrorStatus.udiActiveErrorCount := 0;
    G_stOverallErrorStatus.eHighestSeverity := E_ErrorSeverity#None;
    G_stOverallErrorStatus.bBufferFull := FALSE;
END_IF