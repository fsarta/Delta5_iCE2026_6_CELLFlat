(* Check if the blend test group command is active *)
    IF DATA_GROUP.Command.TestGroupBlend THEN
        (* Set the running status flag *)
        DATA_GROUP.Status.TestGroupRunningBlend := TRUE;

        (* State machine for controlling the blend test sequence *)
        CASE IDX_currentState_Blend OF
            E_BlendStateMachine#IDLE:
                (* Reset indices and counters when starting a new blend test *)
                IDX_SettingsTest_Blend := 0;
                (* Ensure timer is reset *)
                delayTimer(IN := FALSE, PT := T#0S);
                (* Transition to load parameters for the first step *)
                IDX_currentState_Blend := E_BlendStateMachine#LOAD_PARAMS;

            E_BlendStateMachine#LOAD_PARAMS:
                (* Load gripper command from current setting *)
                DATA_GROUP.Command.Gripper := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Gripper;

                (* Load parameters for Blend 1 motion command directly from IDX_SettingsTest_Blend *)
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Position := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Position;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Velocity := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Speed;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Acceleration := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Acc;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Deceleration := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Dec;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.CoordSystem := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].CoordSystem;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.BufferMode := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].BufferMode;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.TransitionMode := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].TransitionMode;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.TransitionParameter := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].TransitionParameter;
                DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.MoveOptions.VelocityUnit := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].MoveOptions_VelocityUnit;

                IDX_SettingsTest_Blend := IDX_SettingsTest_Blend + 1;
                IF DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].LastItem THEN
                    IDX_SettingsTest_Blend := 0;
                END_IF;
                
                (* Load parameters for Blend 2 motion command directly from IDX_SettingsTest_Blend, with bounds check *)
                IF (IDX_SettingsTest_Blend) < MAX_SEGMENT_TEST_POS THEN
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Position := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Position;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Velocity := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Speed;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Acceleration := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Acc;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Deceleration := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Dec;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.CoordSystem := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].CoordSystem;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.BufferMode := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].BufferMode;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.TransitionMode := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].TransitionMode;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.TransitionParameter := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].TransitionParameter;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.MoveOptions.VelocityUnit := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].MoveOptions_VelocityUnit;
                ELSE
                    (* If IDX_SettingsTest_Blend is out of bounds, load safe/default values for Blend 2.
                       This will typically result in a non-moving command that immediately reports 'Done'. *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Position := DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Position; (* Stay at Blend1's target *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Velocity := 0.0;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Acceleration := 0.0;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Deceleration := 0.0;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.CoordSystem := DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.CoordSystem; (* Maintain coordinate system *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.BufferMode := 0; (* No buffer *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.TransitionMode := 0; (* No transition *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.TransitionParameter := DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.TransitionParameter; 
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.MoveOptions.VelocityUnit := 0;
                END_IF;
                
                IDX_SettingsTest_Blend := IDX_SettingsTest_Blend + 1;
                IF DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].LastItem THEN
                    IDX_SettingsTest_Blend := 0;
                END_IF;
                
                (* Load parameters for Blend 3 motion command directly from IDX_SettingsTest_Blend, with bounds check *)
                IF (IDX_SettingsTest_Blend) < MAX_SEGMENT_TEST_POS THEN
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Position := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Position;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Velocity := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Speed;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Acceleration := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Acc;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Deceleration := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Dec;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.CoordSystem := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].CoordSystem;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.BufferMode := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].BufferMode;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.TransitionMode := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].TransitionMode;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.TransitionParameter := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].TransitionParameter;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.MoveOptions.VelocityUnit := DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].MoveOptions_VelocityUnit;
                ELSE
                    (* If IDX_SettingsTest_Blend is out of bounds, load safe/default values for Blend 3.
                       This will typically result in a non-moving command that immediately reports 'Done'. *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Position := DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Position; (* Stay at Blend2's target *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Velocity := 0.0;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Acceleration := 0.0;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Deceleration := 0.0;
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.CoordSystem := DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.CoordSystem; (* Maintain coordinate system *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.BufferMode := 0; (* No buffer *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.TransitionMode := 0; (* No transition *)
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.TransitionParameter := DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.TransitionParameter; 
                    DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.MoveOptions.VelocityUnit := 0;
                END_IF;

                (* Transition to execute the first blend movement *)
                IDX_currentState_Blend := E_BlendStateMachine#EXECUTE_BLEND1;

            E_BlendStateMachine#EXECUTE_BLEND1:
                (* Enable Blend 1 motion command *)
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend1 := TRUE;
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend2 := FALSE; (* Ensure other blends are disabled *)
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend3 := FALSE; (* Ensure other blends are disabled *)

                (* Check for completion of Blend 1 motion directly (Active XOR Done) *)
                IF DATA_GROUP.Status.MoveLinearAbsolute_Blend1.Active XOR DATA_GROUP.Status.MoveLinearAbsolute_Blend1.Done THEN
                    DATA_GROUP.Command.En_MoveLinearAbsolute_Blend1 := FALSE; (* Disable command after completion *)
                    
                    (* Check if delay is zero, if so, skip wait state *)
                    IF DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay = 0 THEN
                        IDX_currentState_Blend := E_BlendStateMachine#EXECUTE_BLEND2; (* Skip wait, go directly to next blend *)
                    ELSE
                        delayTimer(IN := TRUE, PT := DINT_TO_TIME(DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay)); (* Start delay timer *)
                        IDX_currentState_Blend := E_BlendStateMachine#WAIT_AFTER_BLEND1; (* Transition to wait after Blend 1 *)
                    END_IF;
                END_IF;

            E_BlendStateMachine#WAIT_AFTER_BLEND1:
                (* Execute the timer *)
                delayTimer(IN := TRUE, PT := DINT_TO_TIME(DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay));

                (* Check if the timer has elapsed *)
                IF delayTimer.Q THEN
                    delayTimer(IN := FALSE, PT := T#0S); (* Reset timer after completion *)
                    IDX_currentState_Blend := E_BlendStateMachine#EXECUTE_BLEND2; (* Transition to execute Blend 2 *)
                END_IF;

            E_BlendStateMachine#EXECUTE_BLEND2:
                (* Enable Blend 2 motion command *)
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend1 := FALSE;
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend2 := TRUE;
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend3 := FALSE;

                (* Check for completion of Blend 2 motion directly (Active XOR Done) *)
                IF DATA_GROUP.Status.MoveLinearAbsolute_Blend2.Active XOR DATA_GROUP.Status.MoveLinearAbsolute_Blend2.Done THEN
                    DATA_GROUP.Command.En_MoveLinearAbsolute_Blend2 := FALSE; (* Disable command after completion *)
                    
                    (* Check if delay is zero, if so, skip wait state *)
                    IF DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay = 0 THEN
                        IDX_currentState_Blend := E_BlendStateMachine#EXECUTE_BLEND3; (* Skip wait, go directly to next blend *)
                    ELSE
                        delayTimer(IN := TRUE, PT := DINT_TO_TIME(DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay)); (* Start delay timer *)
                        IDX_currentState_Blend := E_BlendStateMachine#WAIT_AFTER_BLEND2; (* Transition to wait after Blend 2 *)
                    END_IF;
                END_IF;

            E_BlendStateMachine#WAIT_AFTER_BLEND2:
                (* Execute the timer *)
                delayTimer(IN := TRUE, PT := DINT_TO_TIME(DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay));

                (* Check if the required delay has passed *)
                IF delayTimer.Q THEN
                    delayTimer(IN := FALSE, PT := T#0S); (* Reset timer after completion *)
                    IDX_currentState_Blend := E_BlendStateMachine#EXECUTE_BLEND3; (* Transition to execute Blend 3 *)
                END_IF;

            E_BlendStateMachine#EXECUTE_BLEND3:
                (* Enable Blend 3 motion command *)
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend1 := FALSE;
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend2 := FALSE;
                DATA_GROUP.Command.En_MoveLinearAbsolute_Blend3 := TRUE;

                (* Check for completion of Blend 3 motion directly (Active XOR Done) *)
                IF DATA_GROUP.Status.MoveLinearAbsolute_Blend3.Active XOR DATA_GROUP.Status.MoveLinearAbsolute_Blend3.Done THEN
                    DATA_GROUP.Command.En_MoveLinearAbsolute_Blend3 := FALSE; (* Disable command after completion *)
                    
                    (* Check if delay is zero, if so, skip wait state *)
                    IF DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay = 0 THEN
                        IDX_currentState_Blend := E_BlendStateMachine#ADVANCE_SETTING; (* Skip wait, go directly to advance settings *)
                    ELSE
                        delayTimer(IN := TRUE, PT := DINT_TO_TIME(DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay)); (* Start delay timer *)
                        IDX_currentState_Blend := E_BlendStateMachine#WAIT_AFTER_BLEND3; (* Transition to wait after Blend 3 *)
                    END_IF;
                END_IF;

            E_BlendStateMachine#WAIT_AFTER_BLEND3:
                (* Execute the timer *)
                delayTimer(IN := TRUE, PT := DINT_TO_TIME(DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].Delay));

                (* Check if the required delay has passed *)
                IF delayTimer.Q THEN
                    delayTimer(IN := FALSE, PT := T#0S); (* Reset timer after completion *)
                    IDX_currentState_Blend := E_BlendStateMachine#ADVANCE_SETTING; (* Transition to advance settings *)
                END_IF;

            E_BlendStateMachine#ADVANCE_SETTING:
                (* Increment the index to move to the next test setting *)
                IDX_SettingsTest_Blend := IDX_SettingsTest_Blend + 1;

                (* Check if the end of the settings array is reached or if the current item is marked as the last *)
                IF (IDX_SettingsTest_Blend >= MAX_SEGMENT_TEST_POS) OR
                   (DATA_GROUP.Setting.TestGroupSetting[IDX_SettingsTest_Blend].LastItem) THEN
                    IDX_SettingsTest_Blend := 0; (* Reset index to loop back to the beginning of settings *)
                END_IF;

                (* Transition back to load parameters for the next test step *)
                IDX_currentState_Blend := E_BlendStateMachine#LOAD_PARAMS;

        END_CASE;
    ELSE
        (* If the TestGroupBlend command is not active, reset all states and flags *)
        IF DATA_GROUP.Status.TestGroupRunningBlend THEN
            DATA_GROUP.Status.TestGroupRunningBlend := FALSE; (* Clear running status *)

            (* Disable all blend motion commands *)
            DATA_GROUP.Command.En_MoveLinearAbsolute_Blend1 := FALSE;
            DATA_GROUP.Command.En_MoveLinearAbsolute_Blend2 := FALSE;
            DATA_GROUP.Command.En_MoveLinearAbsolute_Blend3 := FALSE;
        END_IF;

        (* Reset state machine to idle *)
        IDX_currentState_Blend := E_BlendStateMachine#IDLE;
        (* Reset timer *)
        delayTimer(IN := FALSE, PT := T#0S);
        (* Reset setting index *)
        IDX_SettingsTest_Blend := 0;
    END_IF;