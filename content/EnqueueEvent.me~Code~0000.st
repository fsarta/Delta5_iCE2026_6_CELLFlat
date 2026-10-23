(*
====================================================================================================
 METHOD EnqueueEvent 
====================================================================================================
 Called by tasks to record a stateless informational log.
====================================================================================================
*)

udiNextHead := G_udiQueue_Head + 1;
IF udiNextHead > C_FAST_QUEUE_SIZE THEN
    udiNextHead := 1;
END_IF;

IF udiNextHead <> G_udiQueue_Tail THEN
    
    G_aTaskQueue[G_udiQueue_Head].bIsActive  := FALSE; 
    G_aTaskQueue[G_udiQueue_Head].bIsEvent   := TRUE;  
    G_aTaskQueue[G_udiQueue_Head].udiErrorID := udiEventID;
    G_aTaskQueue[G_udiQueue_Head].sSource    := sSource;
    G_aTaskQueue[G_udiQueue_Head].eSeverity  := eSeverity;
    
    G_udiQueue_Head := udiNextHead;
    EnqueueEvent    := TRUE;
    
ELSE
    G_bQueueOverflow := TRUE; 
    EnqueueEvent     := FALSE;
END_IF;