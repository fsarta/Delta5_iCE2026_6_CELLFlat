(*
====================================================================================================
 METHOD CheckAndEnqueueEvent : BOOL 
====================================================================================================
 Detects the rising edge of a condition and queues the event.
 Restores the current state to allow the caller’s details to be updated in a single line.
====================================================================================================
*)

// --- Detects ONLY the rising edge (when the event occurs) ---
IF bTrigger AND NOT bOldTrigger THEN
    
    // Let’s work on the tail of the specific task
    udiNextHead := G_aTaskQueues[usiTaskID].udiHead + 1;
    IF udiNextHead > C_FAST_QUEUE_SIZE THEN
        udiNextHead := 1;
    END_IF;

    IF udiNextHead <> G_aTaskQueues[usiTaskID].udiTail THEN
        
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].bIsActive  := FALSE; 
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].bIsEvent   := TRUE; 
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].udiErrorID := udiEventID;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].sSource    := sSource;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].sMessage   := sMessage;
        G_aTaskQueues[usiTaskID].aQueue[G_aTaskQueues[usiTaskID].udiHead].eSeverity  := eSeverity;
        
        G_aTaskQueues[usiTaskID].udiHead := udiNextHead;
        
    ELSE
        // Overflow for this task’s queue
        G_aTaskQueues[usiTaskID].bOverflow := TRUE; 
    END_IF;
    
END_IF;

// Returns the current state (essential for single-line calls)
CheckAndEnqueueEvent := bTrigger;