(*
====================================================================================================
 PRIVATE METHOD ProcessEvent
====================================================================================================
*)

IF LEN(sEventMessage) > 0 THEN
    sFinalEventMessage := sEventMessage;
ELSE
    sFinalEventMessage := THIS.GetErrorMessage(udiEventID);
END_IF;

G_ErrorBuffer[G_udiErrorHead].ErrorCode := udiEventID;
G_ErrorBuffer[G_udiErrorHead].ErrorSource := sEventSource;
G_ErrorBuffer[G_udiErrorHead].ErrorMessage := sFinalEventMessage;
G_ErrorBuffer[G_udiErrorHead].Severity := eEventSeverity;
G_ErrorBuffer[G_udiErrorHead].IsActive := FALSE; 
G_ErrorBuffer[G_udiErrorHead].Timestamp := tCurrentSysTime; 
G_ErrorBuffer[G_udiErrorHead].Acknowledged := TRUE; 

G_udiErrorHead := G_udiErrorHead + 1;
IF G_udiErrorHead > C_ERROR_BUFFER_SIZE THEN G_udiErrorHead := 1; END_IF;

IF G_udiErrorHead = G_udiErrorTail THEN
    G_bBufferFull := TRUE;
    G_udiErrorTail := G_udiErrorTail + 1; 
    IF G_udiErrorTail > C_ERROR_BUFFER_SIZE THEN G_udiErrorTail := 1; END_IF;
END_IF;