// ====================================================================================================
// SECTION 3: AXIS COMMAND LOGIC - STATE MACHINES AND FB CALLS
// This section contains the main logic for axis commands, often implemented as state machines.
// ====================================================================================================

// Test Position Sequence State Machine
IF DATA_AXI.Command.TestPos THEN
    DATA_AXI.Status.TestPosRunning := TRUE;
    CASE eTestPosState OF
        E_TestPosState#Idle: // Initial state, transition to LoadData
            eTestPosState := E_TestPosState#LoadData;

        E_TestPosState#LoadData: // Load index data and set motion parameters
            DATA_AXI.Setting.AbsPositioningTarget   := DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Position; 
            DATA_AXI.Setting.PositioningSpeed       := DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Speed; 
            DATA_AXI.Setting.PositioningAcc         := DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Acc; 
            DATA_AXI.Setting.PositioningDec         := DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Dec; 

            // Validate loaded parameters to prevent unsafe moves
            IF  (DATA_AXI.Setting.AbsPositioningTarget > DATA_AXI.Setting.TestPosMaxPos) OR
                (DATA_AXI.Setting.AbsPositioningTarget < DATA_AXI.Setting.TestPosMinPos) OR
                (DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Speed < LREAL#0.1) OR
                (DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Acc < LREAL#0.1) OR
                (DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Dec < LREAL#0.1)
            THEN
                // Parameters are invalid, transition to error state
                eTestPosState := E_TestPosState#Error; // Or directly to Finished if it's considered an end state for this sequence
                //fbErrorHandler.AddUpdateError(TRUE, 16#1001, 'TestPos', 'Invalid TestPos parameters detected', E_ErrorSeverity#MajorError);
            ELSE
                // Parameters are valid, proceed to execute positioning
                eTestPosState := E_TestPosState#Execute;
            END_IF;

        E_TestPosState#Execute: // Execute absolute positioning command
            DATA_AXI.Command.AbsPositioning := TRUE; // Start the absolute positioning 
            IF DATA_AXI.Status.AbsPosDone THEN // Check if positioning is complete 
                DATA_AXI.Command.AbsPositioning := FALSE; // Reset command 
                eTestPosState := E_TestPosState#WaitDelay; // Move to waiting state 
            ELSIF DATA_AXI.Error.MoveAbs_Err THEN
                DATA_AXI.Command.AbsPositioning := FALSE; // Reset command
                eTestPosState := E_TestPosState#Error; // Transition to error state on move error
            END_IF;

        E_TestPosState#WaitDelay: // Wait for configured delay after positioning
            udiTestPosCounter := udiTestPosCounter + 1; // Increment delay counter 
            IF udiTestPosCounter >= DATA_AXI.Setting.TestPosSetting[DATA_AXI.Setting.TestPosIndex].Delay THEN // Check if delay is over 
                udiTestPosCounter := 0; // Reset counter 
                eTestPosState := E_TestPosState#Finished; // Move to finished state 
            END_IF;

        E_TestPosState#Finished: // Sequence step finished, prepare for next iteration or loop
            DATA_AXI.Setting.TestPosIndex := DATA_AXI.Setting.TestPosIndex + 1; // Increment index for next test position 
            // Assuming TestPosSetting is an array of fixed size (e.g., 6)
            IF DATA_AXI.Setting.TestPosIndex >= 6 THEN // Loop back to the first position if end of array reached 
                DATA_AXI.Setting.TestPosIndex := 0; // Reset index 
            END_IF;
            eTestPosState := E_TestPosState#LoadData; // Loop back to load data for the next position 

        E_TestPosState#Error: // Error state for TestPos sequence (e.g., invalid parameters)
            // No automatic recovery in this FB as per requirements.
            // External logic should reset DATA_AXI.Command.TestPos to exit this routine.
            DATA_AXI.Command.AbsPositioning := FALSE; // Ensure motion command is off
            // Stay in error state until TestPos command is released
    END_CASE;
ELSE
    // Reset Test Position state machine if command is not active
    IF DATA_AXI.Status.TestPosRunning THEN
        DATA_AXI.Status.TestPosRunning := FALSE; // Indicate TestPos is no longer running 
        DATA_AXI.Command.AbsPositioning := FALSE; // Ensure motion command is off 
    END_IF;
    eTestPosState := E_TestPosState#Idle; // Reset state to idle 
    udiTestPosCounter := 0; // Reset counter 
    DATA_AXI.Setting.TestPosIndex := 0; // Reset index 
END_IF;