(*
METHOD: State handler for HOMING state
DESCRIPTION: 
Implements homing sequence with direct transition to operational modes.
*)

// Activate axes for homing
DATA_Delta.Status.GroupControl.PowerStatus := TRUE;
DATA_FeedInAxis.Command.Enable := TRUE;
DATA_FeedOutAxis.Command.Enable := TRUE;
DATA_VirtAxis.Command.Enable := TRUE;

bServoError_Homing := NOT(S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                      T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);
                   
//fbErrorHandler.AddUpdateError(NOT(S_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'S Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(L_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'L Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(U_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'U Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(T_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'T Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(B_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'B Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedIn_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'CI Axis (Infeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedOut_Axis.Status.ServoOn), 0, 'FB_MachineControl - HomingState', 'CO Axis (Outfeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);                   

IF bServoError_Homing THEN
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0,'FB_MachineControl - HomingState', 'Error/Alarm', E_ErrorSeverity#MajorError);
    RETURN;
END_IF;

// Timeout monitoring
HomingTimer(
    IN := NOT(DATA_Delta.Status.GroupControl.PowerStatus AND DATA_FeedInAxis.Status.Enabled AND DATA_FeedOutAxis.Status.Enabled AND DATA_VirtAxis.Status.Enabled),
    PT := TIME#5s
    );
//fbErrorHandler.AddUpdateError(HomingTimer.Q, 0, 'FB_MachineControl - HomingState', 'Homing failed: Timeout waiting for axes to enable.', E_ErrorSeverity#MajorError);

// State transitions based on homing status
IF bServoError_Homing OR HomingTimer.Q THEN
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;

ELSIF DATA_Delta.Status.GroupControl.PowerStatus AND DATA_FeedInAxis.Status.Enabled AND DATA_FeedOutAxis.Status.Enabled AND DATA_VirtAxis.Status.Enabled THEN
    GroupIsHomed :=     S_Axis.Status.Homed AND L_Axis.Status.Homed AND U_Axis.Status.Homed AND T_Axis.Status.Homed AND 
                        (*B_Axis.Status.Homed AND*) FeedIn_Axis.Status.Homed AND FeedOut_Axis.Status.Homed;
    IF Commissioning THEN
        NextState := E_MachineState#WAIT_FOR_COMMISSIONING;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - HomingState', 'Homing completed, waiting for COMMISSIONING', E_ErrorSeverity#Info);
    ELSIF bAutoModeSelected THEN
        NextState := E_MachineState#OPERATIONAL_AUTOMATIC;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - HomingState', 'Homing completed, entering AUTOMATIC mode', E_ErrorSeverity#Info);
    ELSIF bManualModeSelected THEN
        NextState := E_MachineState#OPERATIONAL_MANUAL;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - HomingState', 'Homing completed, entering MANUAL mode', E_ErrorSeverity#Info);
    END_IF;   
    bTransition := TRUE;
//ELSIF G_stOverallErrorStatus.bAnyErrorActive OR HomingTimer.Q THEN
//    NextState := E_MachineState#ERROR;
//    bTransition := TRUE;
//    fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - HomingState', 'Homing failed', E_ErrorSeverity#MajorError);    
END_IF;
