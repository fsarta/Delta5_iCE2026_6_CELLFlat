//=================================================================================
// Yaskawa Italia Srl
//(c)Copyright Yaskawa Italia srl All Rights Reserved
//---------------------------------------------------------------------------------
// 
// Tested with: iC9226M-FSoE
// Engineering: iCube Engineer 2025.6 RC4 PROTOTYPE (Build 7.2.36335.0)
// Requirements: iC9226M-EC / iC9226M-FSoE
// Functionality: 
//     This Function Block implements a state machine to control a single master-slave camming system.
//     It handles the sequence of operations including cam table generation, selection, cam engagement,
//     optional cam shifting based on a TouchProbe event, and cam disengagement.
//    
//     This FB is designed to be instantiated multiple times for independent control of different
//     camming axes, promoting modularity and reusability.
//     
//---------------------------------------------------------------------------------
// Change log table:
// Version   Date         Expert in charge                     Changes applied
// 0.00.01   25-07-2025   Fsarta(Francesco.sarta@yaskawa.eu)   New Version Released
//=================================================================================

(* --- FB_CamStateMachine Implementation --- *)

// Edge detection for start/cancel signals
r_EnableSequence(CLK := EnableSequence);

// Assign axis references for all internal FBs.
CamSystemData.Master := MasterAxis;
CamSystemData.Slave := SlaveAxis;
CamSystemData.AxisTouchProbe := SlaveAxis;

(* --- Reset Logic --- *)
// The state machine initializes to INIT. When Reset is asserted,
// or after a sequence completes (returning to INIT), this block will reset
// all internal flags and FB executes to ensure a clean start.
IF eInternalState = E_CamStateMachineState#INIT THEN
    eInternalState := E_CamStateMachineState#IDLE; // Transition to IDLE after reset
    SequenceComplete := FALSE;
    SequenceError := FALSE;
    SequenceErrorID := 0;
    
    bTouchProbeTriggeredOnce := FALSE;
    
    CamSystemData.CamMasterLookup.MasterMin := 0.0;
    CamSystemData.CamMasterLookup.MasterMax := 360.0;

    // Ensure all internal FB execute inputs are FALSE to prevent unintended operations
    CamSystemData.CamGenerator.Execute := FALSE;
    CamSystemData.CamStructSelect.Execute := FALSE;
    CamSystemData.SetCamMasterCycle.Execute := FALSE;
    CamSystemData.CamIn.Execute := FALSE;
    CamSystemData.CamOut.Execute := FALSE;
    CamSystemData.CamShift.Execute := FALSE;
    CamSystemData.SlaveOffset.Execute := FALSE;
    CamSystemData.TouchProbe.Execute := FALSE;
    CamSystemData.AbortTrigger.Execute := FALSE;
    CamSystemData.CamMasterLookup.Enable := FALSE;
    StopAxis := FALSE;

END_IF;

// Update the output state for external monitoring
CurrentState := eInternalState; (* Update output state *)

(* --- State Machine Logic --- *)
CASE eInternalState OF
    E_CamStateMachineState#IDLE:   
        // Only activate generation if start command is given
        IF r_EnableSequence.Q THEN
            // Initialize CamGenerator inputs
            CamSystemData.CamGenerator.CamData := CamData;
            // Trigger the cam table generation            
            CamSystemData.CamGenerator.Execute := TRUE;
            
            eInternalState := E_CamStateMachineState#GENERATE_CAM_TABLE;
        END_IF;

    E_CamStateMachineState#GENERATE_CAM_TABLE:
        // This state monitors the 'CamGenerator' FB.
        IF CamSystemData.CamGenerator.Done THEN
            CamSystemData.CamGenerator.Execute := FALSE; // De-trigger
                                    
            CamSystemData.CamStructSelect.CamTable := CamSystemData.CamGenerator.CamTable;
            stCamTable := CamSystemData.CamStructSelect.CamTable;
            // CamSystemData.CamStructSelect.BlockSize := 0; // Entire CamStruct
            CamSystemData.CamStructSelect.Execute := TRUE; // Trigger selection
            
            eInternalState := E_CamStateMachineState#SELECT_CAM_TABLE;
            
        ELSIF CamSystemData.CamGenerator.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.CamGenerator.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;

    E_CamStateMachineState#SELECT_CAM_TABLE:
        // This state monitors the 'CamStructSelect' FB.
        IF CamSystemData.CamStructSelect.Done THEN
            uiCamTableID := CamSystemData.CamStructSelect.CamTableID;
            CamSystemData.SetCamMasterCycle.Execute := TRUE;
            CamSystemData.SetCamMasterCycle.CamTableID := uiCamTableID;
            CamSystemData.CamStructSelect.Execute := FALSE; // De-trigger

            eInternalState := E_CamStateMachineState#SET_CAM_MASTER_CYCLE;
        ELSIF CamSystemData.CamStructSelect.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.CamStructSelect.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;
        
    E_CamStateMachineState#SET_CAM_MASTER_CYCLE:
        // This state monitors the 'SetCamMasterCycle' FB.
        IF CamSystemData.SetCamMasterCycle.Done THEN
            eInternalState := E_CamStateMachineState#PREPARE_CAMIN;
        ELSIF CamSystemData.SetCamMasterCycle.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.SetCamMasterCycle.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;

    E_CamStateMachineState#PREPARE_CAMIN:
        // This state triggers the 'CamIn' FB. Parameters are set.
        IF AllowCamIn THEN //AND (DATA_Axis.Feedback.ActualPosition >= 0.0 AND DATA_Axis.Feedback.ActualPosition <= MaxPos) THEN
            CamSystemData.CamIn.CamTableID := uiCamTableID; 
            CamSystemData.CamIn.EngagePosition := EngagePosition; 
            CamSystemData.CamIn.EngageWindow := EngageWindow;    
            CamSystemData.CamIn.Periodic := Periodic;      
            CamSystemData.CamIn.EngageData := EngageData;
            
            CamSystemData.CamIn.Execute := TRUE; // Trigger cam engagement
            
            eInternalState := E_CamStateMachineState#ENGAGE_CAM;
        END_IF;

    E_CamStateMachineState#ENGAGE_CAM:        
        // It waits for the 'Active' and 'InSync' outputs or an 'Error' from the FB.
        IF CamSystemData.CamIn.Active AND CamSystemData.CamIn.InSync THEN 
            // Cam is active and in synchronization. Now in continuous camming mode
            CamSystemData.TriggerInput := TriggerInput; // Map external trigger input
            IF EnableTouchProbe AND GetTouchProbe THEN
                CamSystemData.TouchProbe.Execute := TRUE; // Trigger TouchProbe arming
                eInternalState := E_CamStateMachineState#CAM_ACTIVE;
            ELSIF NOT(EnableTouchProbe) THEN
                eInternalState := E_CamStateMachineState#CAM_ACTIVE;
            END_IF;
        ELSIF CamSystemData.CamIn.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.CamIn.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;

    E_CamStateMachineState#CAM_ACTIVE:
        // In this state, the camming operation is active.
        // It monitors for TouchProbe completion or a disengage command.
        IF EnableTouchProbe AND CamSystemData.TouchProbe.Done THEN 
            lrRecordedPosition := CamSystemData.TouchProbe.RecordedPosition;
            CamSystemData.CamMasterLookup.SlavePosition := lrRecordedPosition;
            CamSystemData.CamMasterLookup.CamTable := stCamTable;
            CamSystemData.CamMasterLookup.Enable := TRUE;
            CamSystemData.TouchProbe.Execute := FALSE;
            //lrRecordedPositionMaster := CamSystemData.CamMasterLookup.MasterPosition;
            
            CamSystemData.AbortTrigger.Execute := TRUE;
            
            eInternalState := E_CamStateMachineState#ABORT_TRIGGER;
        
        ELSIF NOT(EnableSequence) THEN // Signal to disengage
            // External 'EnableSequence' command is now FALSE, initiate cam disengagement
            CamSystemData.CamOut.DisengagePosition := DisengagePosition; 
            CamSystemData.CamOut.DisengageWindow := DisengageWindow;
            CamSystemData.CamOut.DisengageData := DisengageData;
            
            eInternalState := E_CamStateMachineState#DISENGAGE_CAM;    
            
        ELSIF CamSystemData.TouchProbe.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.TouchProbe.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
            
        ELSIF CamSystemData.CamIn.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.CamIn.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;    
        END_IF;

    E_CamStateMachineState#ABORT_TRIGGER:
        // This state monitors the 'AbortTrigger' FB
        IF CamSystemData.AbortTrigger.Done THEN
            CamSystemData.AbortTrigger.Execute := FALSE;
                        
            CamSystemData.TriggerInput := TriggerInput;
        ELSIF EnableTouchProbe AND NOT(bTouchProbeTriggeredOnce) AND GetTouchProbe THEN (* Re-arm the touchprobe if it's still requested *)
            lrRecordedPositionFirst := CamSystemData.CamMasterLookup.MasterPosition; // lrRecordedPosition;
            CamSystemData.TouchProbe.Execute := TRUE;
            bTouchProbeTriggeredOnce := TRUE;
            eInternalState := E_CamStateMachineState#CAM_ACTIVE; // Return to active camming
            
        ELSIF bTouchProbeTriggeredOnce AND GetTouchProbe THEN
            CamSystemData.CamShift.PhaseShift := CamSystemData.CamMasterLookup.MasterPosition - lrRecordedPositionFirst + CamSystemData.CamParams.v1511_CamMasterShift; //Calculate phase shift based on recorded position 
            //TODO check if change the direction of difference
            CamSystemData.CamShift.AdjustMode := Yt_AdjustMode#MasterDistance;
            CamSystemData.CamShift.MasterDistance := 0.0;
            CamSystemData.CamShift.Execute := TRUE; // Trigger cam shift
            //-----------------------------------------------------------
            //CamSystemData.SlaveOffset.Offset := lrRecordedPositionFirst - lrRecordedPosition; //Calculate phase shift based on recorded position 
            ////TODO check if change the direction of difference
            //CamSystemData.SlaveOffset.AdjustMode := Yt_AdjustMode#MasterDistance;
            //CamSystemData.SlaveOffset.MasterDistance := 0.0;
            //CamSystemData.SlaveOffset.Execute := TRUE; // Trigger cam shift
            //-----------------------------------------------------------
            eInternalState := E_CamStateMachineState#SHIFT_CAM; // OFFSET_CAM;            
            
        ELSIF CamSystemData.AbortTrigger.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.AbortTrigger.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;
        
    E_CamStateMachineState#SHIFT_CAM:
        // This state monitors the 'CamShift' FB
        IF CamSystemData.CamShift.Done THEN
            CamSystemData.CamShift.Execute := FALSE;
            
            CamSystemData.TouchProbe.Execute := TRUE;
            
            eInternalState := E_CamStateMachineState#CAM_ACTIVE; // Return to active camming after shift
            
        ELSIF CamSystemData.CamShift.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.CamShift.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;
        
    E_CamStateMachineState#OFFSET_CAM:
        // This state monitors the 'SlaveOffset' FB
        IF CamSystemData.SlaveOffset.Done THEN
            CamSystemData.SlaveOffset.Execute := FALSE;
            
            CamSystemData.TouchProbe.Execute := TRUE;
            
            eInternalState := E_CamStateMachineState#CAM_ACTIVE; // Return to active camming after shift
            
        ELSIF CamSystemData.SlaveOffset.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.SlaveOffset.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;


    E_CamStateMachineState#DISENGAGE_CAM:
        // This state triggers the 'CamOut' FB to disengage the cam
        // IF AllowCamIn THEN
            CamSystemData.CamOut.DisengagePosition := DisengagePosition; 
            CamSystemData.CamOut.DisengageWindow := DisengageWindow;    
            CamSystemData.CamOut.DisengageData := DisengageData;
            
            CamSystemData.CamOut.Execute := TRUE;
    
            eInternalState := E_CamStateMachineState#WAIT_DISENGAGE_DONE;
        // END_IF;
        
        IF CamSystemData.CamOut.Error THEN
            SequenceError := TRUE;
            SequenceErrorID := CamSystemData.CamOut.ErrorID;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;

    E_CamStateMachineState#WAIT_DISENGAGE_DONE:
        // This state monitors the 'CamOut' FB for completion
        IF CamSystemData.CamOut.Done THEN
            // Cam disengagement completed successfully. Reset the FB to initial state
            eInternalState := E_CamStateMachineState#INIT; // Sequence completed, return to INIT state for full reset
            SequenceComplete := TRUE;
        ELSIF CamSystemData.CamOut.Error THEN
            SequenceError := TRUE;
            eInternalState := E_CamStateMachineState#ERROR;
        END_IF;

    E_CamStateMachineState#ERROR:
        SequenceError := TRUE;
        // In this state, the sequence is in an error condition.
        // All FB executions are halted, and the FB waits for a 'ResetFB' command to return to the INIT state. 
        StopAxis := TRUE;
        //CamSystemData.CamGenerator.Execute := FALSE; 
        //CamSystemData.CamStructSelect.Execute := FALSE;
        //CamSystemData.SetCamMasterCycle.Execute := FALSE;
        //CamSystemData.CamIn.Execute := FALSE;
        //CamSystemData.CamOut.Execute := FALSE;
        //CamSystemData.CamShift.Execute := FALSE;
        //CamSystemData.SlaveOffset.Execute := FALSE;
        //CamSystemData.TouchProbe.Execute := FALSE;
        //CamSystemData.AbortTrigger.Execute := FALSE;
        //CamSystemData.CamMasterLookup.Enable := FALSE;

        
        IF Reset THEN
            StopAxis := FALSE;
            SequenceError := FALSE;
            eInternalState := E_CamStateMachineState#IDLE;
        END_IF;            

END_CASE;