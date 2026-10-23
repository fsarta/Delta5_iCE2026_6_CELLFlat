//FUNCTION F_EnqueueError : BOOL

// Calculate the NEXT head index to prevent queue overtaking
udiNextHead := G_udiQueue_Head + 1;
IF udiNextHead > C_FAST_QUEUE_SIZE THEN
    udiNextHead := 1;
END_IF;

// Write to queue ONLY IF we are not crashing into the Tail
IF udiNextHead <> G_udiQueue_Tail THEN

G_aTaskQueue[G_udiQueue_Head].bIsActive  := bIsActive;
    G_aTaskQueue[G_udiQueue_Head].udiErrorID := udiErrorID;
    G_aTaskQueue[G_udiQueue_Head].sSource    := sSource;
    G_aTaskQueue[G_udiQueue_Head].eSeverity  := eSeverity;
    
    // Officially update the Head pointer
    G_udiQueue_Head := udiNextHead;
    F_EnqueueError  := TRUE;
    
ELSE
    // CRITICAL ALARM: The communication queue is full!
    G_bQueueOverflow := TRUE; 
    F_EnqueueError   := FALSE;
END_IF;