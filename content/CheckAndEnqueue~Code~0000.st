(*
====================================================================================================
 METHOD CheckAndEnqueue : BOOL 
====================================================================================================
*)

IF bCurrentState <> bOldState THEN
    
    // Lavoriamo SOLO sulla coda del task specifico
    udiNextHead := G_aTaskQueues[usiTaskID].udiHead + 1;
    IF udiNextHead > C_FAST_QUEUE_SIZE THEN
        udiNextHead := 1;
    END_IF;

    IF udiNextHead <> G_aTaskQueues[usiTaskID].udiTail THEN
        
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].bIsActive  := bCurrentState;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].bIsEvent   := FALSE;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].udiErrorID := udiErrorID;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].sSource    := sSource;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].sMessage   := sMessage;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].eSeverity  := eSeverity;
        
        G_aTaskQueues[usiTaskID].udiHead := udiNextHead;
        
    ELSE
        // Overflow solo per la coda di questo specifico task
        G_aTaskQueues[usiTaskID].bOverflow := TRUE; 
    END_IF;
    
END_IF;

CheckAndEnqueue := bCurrentState;