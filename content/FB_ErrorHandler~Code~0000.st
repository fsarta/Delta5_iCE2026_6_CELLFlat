//=================================================================================
// Yaskawa Italia Srl
//(c)Copyright Yaskawa Italia Srl All Rights Reserved
//---------------------------------------------------------------------------------
// 
// Tested with: iC9226M-FSoE
// Engineering: iCube Engineer 2025.6 (Build 7.2.38936.0)
// Requirements: iC9226M-EC / iC9226M-FSoE
// Functionality: This Function Block provides a centralized, high-performance system for 
//                managing and logging errors and events from various parts of the application.
//---------------------------------------------------------------------------------
// Change log table:
// Version   Date         Expert in charge                     Changes applied
// 0.00.01   10-07-2025   Fsarta(Francesco.sarta@yaskawa.eu)   New Version Released
// 0.01.01   10-11-2025   Fsarta(Francesco.sarta@yaskawa.eu)   New Version Released
//=================================================================================

Y_YA_PLC_uSec1(
    Enable := TRUE, 
    //Valid => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT, 
    uSec => SysTimestamp1
    );
    
// Main Body of the Function Block (this code executes every time FB_ErrorHandler is called)
// Detect rising edge for reset command
xResetErrorsR_TRIG(CLK := bResetErrors OR G_bResetAllErrors);
IF xResetErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        G_ErrorBuffer[i].IsActive := FALSE;
        G_ErrorBuffer[i].Acknowledged := FALSE;
        G_ErrorBuffer[i].ErrorCode := 0;
        G_ErrorBuffer[i].ErrorSource := '';
        G_ErrorBuffer[i].ErrorMessage := '';
        G_ErrorBuffer[i].Timestamp.Year := 0;
        G_ErrorBuffer[i].Timestamp.Month := 0;
        G_ErrorBuffer[i].Timestamp.Day := 0;
        G_ErrorBuffer[i].Timestamp.Hour := 0;
        G_ErrorBuffer[i].Timestamp.Minute := 0;
        G_ErrorBuffer[i].Timestamp.Second := 0;
        G_ErrorBuffer[i].Timestamp.mSec := 0;
        G_ErrorBuffer[i].Severity := E_ErrorSeverity#None;
    END_FOR
    G_udiErrorHead := 1;
    G_udiErrorTail := 1;
    G_bResetAllErrors := FALSE;
END_IF

// Detect rising edge for acknowledge command
xAcknowledgeErrorsR_TRIG(CLK := bAcknowledgeErrors OR G_bAcknowledgeAllErrors);
IF xAcknowledgeErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        IF G_ErrorBuffer[i].IsActive THEN
            G_ErrorBuffer[i].Acknowledged := TRUE;
        END_IF
    END_FOR
    G_bAcknowledgeAllErrors := FALSE;
END_IF

// Recalculate overall error state and count from the buffer
G_stOverallErrorStatus.udiActiveErrorCount := 0; // Reset for recalculation
G_stOverallErrorStatus.eHighestSeverity := E_ErrorSeverity#None; // Reset for recalculation
G_stOverallErrorStatus.bAnyErrorActive := FALSE; // Reset for recalculation

FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
    IF G_ErrorBuffer[i].IsActive AND
       (G_ErrorBuffer[i].Severity = E_ErrorSeverity#MajorError OR       
       G_ErrorBuffer[i].Severity = E_ErrorSeverity#FatalError) THEN
        G_stOverallErrorStatus.udiActiveErrorCount := G_stOverallErrorStatus.udiActiveErrorCount + 1;
        G_stOverallErrorStatus.bAnyErrorActive := TRUE; // At least one error is active
        IF G_ErrorBuffer[i].Severity > G_stOverallErrorStatus.eHighestSeverity THEN
            G_stOverallErrorStatus.eHighestSeverity := G_ErrorBuffer[i].Severity;
        END_IF
    END_IF
END_FOR

G_stOverallErrorStatus.bBufferFull := G_bBufferFull; // Copy the buffer full status