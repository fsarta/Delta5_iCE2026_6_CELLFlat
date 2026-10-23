// Write Drive Parameter State Machine
IF CMD_WriteDrvPar THEN // Only active if Write Drive Parameter command is true
    CASE eWriteDrvParState OF
        E_WriteDrvParState#Idle: // Initial state, waiting for internal FB done signal
            // Transition to Write when CMD_WriteDrvPar is true (implicitly handled by the outer IF)
            // The actual FB call is below this state machine, so we wait for its 'Done'
            // The original code uses STS_WriteDrvParDone, implying the FB is called continuously.
            // Let's adapt this by triggering the FB and moving state.
            eWriteDrvParState := E_WriteDrvParState#Write;

        E_WriteDrvParState#Write: // Execute the write command
            // Y_WriteDriveParameter_1 FB is called below this logic.
            // We check its done output to proceed.
            IF STS_WriteDrvParDone THEN // If write operation is complete 
                eWriteDrvParState := E_WriteDrvParState#ReadVerify; // Proceed to read and verify 
            END_IF;
            // Add a timeout here for robustness
            // IF Y_WriteDriveParameter_1.Error THEN eWriteDrvParState := E_WriteDrvParState#Idle; // Handle error
            // (Error handling for FB already handled by fbErrorHandler below)

        E_WriteDrvParState#ReadVerify: // Read back the parameter to verify the write
            CMD_ReadDrvPar := TRUE; // Enable read command 
            // Y_ReadDriveParameter_1 FB is called below this logic.
            IF STS_ReadDrvParDone AND (VAR_ReadDrvParValue = VAR_WriteDrvParValue) THEN // If read is done and value matches 
                STS_WriteParDone := TRUE; // Set overall write done status 
                eWriteDrvParState := E_WriteDrvParState#Done; // Transition to done state 
            ELSIF STS_ReadDrvParDone AND (VAR_ReadDrvParValue <> VAR_WriteDrvParValue) THEN
                // Verification failed, maybe raise a specific error
                //fbErrorHandler.AddUpdateError(TRUE, 16#1002, 'WriteDrvPar', 'Parameter verification failed after write', E_ErrorSeverity#MajorError);
                eWriteDrvParState := E_WriteDrvParState#Idle; // Reset state machine on verification failure
            END_IF;
            // Add a timeout here for robustness
            // IF Y_ReadDriveParameter_1.Error THEN eWriteDrvParState := E_WriteDrvParState#Idle; // Handle error

        E_WriteDrvParState#Done: // Operation completed successfully
            // Stay in this state until CMD_WriteDrvPar goes FALSE, then reset to Idle.
            // No action, waiting for external reset
    END_CASE;
ELSE
    // Reset Write Drive Parameter state machine if command is not active
    eWriteDrvParState := E_WriteDrvParState#Idle; // Reset state to idle 
    STS_WriteParDone := FALSE; // Reset status 
    CMD_ReadDrvPar := FALSE; // Ensure read command is off 
END_IF;