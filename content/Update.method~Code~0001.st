(*
====================================================================================================
 METHOD Update
====================================================================================================
 This method must be called ONCE per PLC scan in a low-priority/main task.
 It handles system clock reading, user commands, and processes the fast task queue.
====================================================================================================
*)

// --- 1. Handle Initialization ---
IF bInitRetains THEN
    THIS.ResetBufferAndCounters();
    bInitRetains := FALSE;
END_IF;

// --- 2. Read System Time ONCE per cycle ---
// Removing this from AddUpdateError prevents block corruption
Y_YA_RealTimeClock1(
    Enable := TRUE, 
    Clock => tCurrentSysTime 
);

// --- 3. Process All Fast Task Queues (Consumer Logic) ---
// Check all the separate tails
FOR t := 1 TO C_MAX_TASKS DO
    
    // Clear the current queue until Head and Tail match
    WHILE (G_aTaskQueues[t].udiTail <> G_aTaskQueues[t].udiHead) DO
        
        IF G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].bIsEvent THEN
            THIS.ProcessEvent(
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].udiErrorID, // udiEventID    
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].sSource,    // sEventSource  
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].sMessage,   // sEventMessage 
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].eSeverity   // eEventSeverity
            );
        ELSE
            THIS.AddUpdateError(
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].bIsActive,  // bErrorDetected
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].udiErrorID, // udiErrorID    
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].sSource,    // sErrorSource  
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].sMessage,   // sErrorMessage 
                G_aTaskQueues[t].aQueue[G_aTaskQueues[t].udiTail].eSeverity   // eErrorSeverity
            );
        END_IF;

        // The tail of the current is moving forward
        G_aTaskQueues[t].udiTail := G_aTaskQueues[t].udiTail + 1;
        IF G_aTaskQueues[t].udiTail > C_FAST_QUEUE_SIZE THEN
            G_aTaskQueues[t].udiTail := 1;
        END_IF;
        
    END_WHILE;

END_FOR;

// --- 4. Handle Reset Errors Command ---
xResetErrorsR_TRIG(CLK := G_bResetAllErrors);
IF xResetErrorsR_TRIG.Q THEN
    THIS.ResetBufferAndCounters();
    G_bResetAllErrors := FALSE;
END_IF;

// --- 5. Handle Acknowledge Errors Command ---
xAcknowledgeErrorsR_TRIG(CLK := G_bAcknowledgeAllErrors);
IF xAcknowledgeErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        IF G_ErrorBuffer[i].IsActive THEN
            G_ErrorBuffer[i].Acknowledged := TRUE; 
        END_IF;
    END_FOR;
    G_bAcknowledgeAllErrors := FALSE; 
END_IF;

Update := TRUE;