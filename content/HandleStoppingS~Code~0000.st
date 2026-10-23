(*
METHOD: State handler for STOPPING state
DESCRIPTION: 
Implements safe stop sequence with error handling.
*)

bServoError_Stopping := NOT(S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                   T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);
                   
//fbErrorHandler.AddUpdateError(NOT(S_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'S Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(L_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'L Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(U_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'U Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(T_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'T Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(B_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'B Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedIn_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'CI Axis (Infeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedOut_Axis.Status.ServoOn), 0, 'FB_MachineControl - StoppingState', 'CO Axis (Outfeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);                   


IF bServoError_Stopping THEN
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - StoppingState', 'Error/Alarm', E_ErrorSeverity#MajorError); 
END_IF;

// Activate group stop
DATA_Delta.Command.En_EmergencyGroupStop := TRUE;

DATA_FeedInAxis.Command.JogPos := FALSE;
DATA_FeedOutAxis.Command.JogPos := FALSE;
LampIn := FALSE;
LampOut := FALSE;
xVision_StartCycle := FALSE;
io.bSystemReady := FALSE;
StartPickPlace_Delta := FALSE;

DATA_FeedInAxis.Command.EmergencyStop := TRUE;
DATA_FeedOutAxis.Command.EmergencyStop := TRUE;
DATA_VirtAxis.Command.EmergencyStop := TRUE;

// Monitor stop completion
fbStopTimer(IN := TRUE, PT := T#10S);
IF DATA_Delta.Status.EmergencyGroupStop.Done THEN
    fbStopTimer(IN := FALSE, PT := T#10S);
    NextState := E_MachineState#UNPOWERING;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - StoppingState', 'Movement stopped successfully, entering to UNPOWERING mode.', E_ErrorSeverity#Info);
ELSIF fbStopTimer.Q THEN
    fbStopTimer(IN := FALSE, PT := T#10S);
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - StoppingState', 'Stop timeout - forcing ERROR', E_ErrorSeverity#MajorError);
END_IF;