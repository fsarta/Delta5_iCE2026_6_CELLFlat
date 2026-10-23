(*
====================================================================================================
 METHOD ErrorHandlerInit
====================================================================================================
*)

IF bInitRetains THEN
    // At startup, clear the buffer and all counters
    THIS.ResetBufferAndCounters();
END_IF