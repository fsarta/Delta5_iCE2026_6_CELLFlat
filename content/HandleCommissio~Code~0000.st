(*
METHOD: State handler for WAIT_FOR_COMMISSIONING state
DESCRIPTION: 
Waits for manual position setting and transitions to correct mode.
*)

GroupIsHomed := FALSE;

bServoError_Commissioning := NOT(S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                   T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);
                   
//fbErrorHandler.AddUpdateError(NOT(S_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'S Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(L_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'L Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(U_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'U Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(T_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'T Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(B_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'B Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedIn_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'CI Axis (Infeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedOut_Axis.Status.ServoOn), 0, 'FB_MachineControl - CommissioningState', 'CO Axis (Outfeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);                   

IF bServoError_Commissioning THEN
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0,'FB_MachineControl - CommissioningState', 'Error/Alarm', E_ErrorSeverity#MajorError);
    RETURN;
END_IF;

// Wait for manual position set
IF DATA_Delta.Status.GroupSetPosition.Done THEN
    DATA_Delta.Command.En_GroupSetPosition :=  FALSE;
    IF bAutoModeSelected THEN
        NextState := E_MachineState#OPERATIONAL_AUTOMATIC;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - CommissioningState', 'Position set completed, entering AUTOMATIC mode', E_ErrorSeverity#Info);
    ELSE
        NextState := E_MachineState#OPERATIONAL_MANUAL;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - CommissioningState', 'Position set completed, entering MANUAL mode', E_ErrorSeverity#Info);
    END_IF;
    GroupIsHomed := TRUE;
    bTransition := TRUE;
ELSIF DATA_Delta.Error.GroupSetPosition.Error THEN
    DATA_Delta.Command.En_GroupSetPosition  :=  FALSE;
    GroupIsHomed := FALSE;
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(DATA_Delta.Error.GroupSetPosition.Error, 0, 'FB_MachineControl - CommissioningState', 'Position set failed', E_ErrorSeverity#MajorError);    
END_IF;