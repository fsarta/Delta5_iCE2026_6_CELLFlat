(*
====================================================================================================
 METHOD EnqueueError
====================================================================================================
 Called by tasks to place an alarm in the fast queue.
 It does not access the main buffer, so it is extremely lightweight and secure.
====================================================================================================
*)

// Calculate the next leading index
udiNextHead := G_udiQueue_Head + 1;
IF udiNextHead > C_FAST_QUEUE_SIZE THEN
    udiNextHead := 1;
END_IF;

// Write in the queue ONLY IF there is space
IF udiNextHead <> G_udiQueue_Tail THEN

    G_aTaskQueue[G_udiQueue_Head].bIsActive  := bIsActive;
    G_aTaskQueue[G_udiQueue_Head].bIsEvent   := FALSE; 
    G_aTaskQueue[G_udiQueue_Head].udiErrorID := udiErrorID;
    G_aTaskQueue[G_udiQueue_Head].sSource    := sSource;
    G_aTaskQueue[G_udiQueue_Head].eSeverity  := eSeverity;
    
    // Officially update the pointer
    G_udiQueue_Head := udiNextHead;
    EnqueueError    := TRUE;
    
ELSE
    // CRITICAL ALERT: Communication queue full
    G_bQueueOverflow := TRUE; 
    EnqueueError     := FALSE;
END_IF;