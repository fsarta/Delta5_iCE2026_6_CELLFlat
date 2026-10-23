(*
METHOD: State handler for ERROR state
DESCRIPTION: 
Implements error recovery mechanism with diagnostics.
*)

(* Safe stop before power-off 
   The sequencer and vision system are disabled immediately. 
   If the group is moving and the servos are OK, power is NOT cut off: it is routed to STOPPING, 
   which executes a controlled stop (En_EmergencyGroupStop) before UNPOWERING. *)
bServoError_ErrorState := NOT(  S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND T_Axis.Status.ServoOn AND 
                                (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);

StartPickPlace_Delta := FALSE;
xVision_StartCycle   := FALSE;
io.bSystemReady      := FALSE;

bStopToUnpower := bServoError_ErrorState OR NOT(DATA_Delta.Status.GroupReadStatus.GroupMoving);

IF bStopToUnpower THEN
    DATA_Delta.Command.GroupControl.En_Power        := FALSE;
END_IF;

DATA_Delta.Command.En_GroupJogJoint             := FALSE;
DATA_Delta.Command.En_GroupJogLinear            := FALSE;
DATA_Delta.Command.En_MoveLinearAbsolute        := FALSE;
DATA_Delta.Command.En_MoveLinearRelative        := FALSE;
DATA_Delta.Command.En_MoveLinearAbsolute_Blend1 := FALSE;
DATA_Delta.Command.En_MoveLinearAbsolute_Blend2 := FALSE;
DATA_Delta.Command.En_MoveLinearAbsolute_Blend3 := FALSE;

DATA_DELTA.Command.TestGroupBlend   := FALSE;

IF bStopToUnpower THEN
    DATA_FeedInAxis.Command.Enable      := FALSE;
    DATA_FeedOutAxis.Command.Enable     := FALSE;
    DATA_VirtAxis.Command.Enable        := FALSE;
END_IF;

DATA_Delta.Command.GroupControl.AlarmClear := FALSE;
DATA_FeedInAxis.Command.ResetFault  := FALSE;
DATA_FeedOutAxis.Command.ResetFault := FALSE;

LampIn := FALSE;
LampOut := FALSE;
MainValveGripper := FALSE;
SecondaryValveGripper := FALSE;

PowerUp := FALSE;

CycleControls.StartCycle := FALSE;
CycleControls.StopCycle := FALSE;

DATA_Axes.Command.AutoAxes.Start := FALSE;

(* If the unit is in motion, it switches to STOPPING (controlled stop)
   rather than remaining in ERROR mode with power cut off. *)
IF NOT bStopToUnpower THEN
    NextState := E_MachineState#STOPPING;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - ErrorState', 'Motion active at error: controlled stop before power off', E_ErrorSeverity#Warning);
END_IF;

// Return to IDLE on reset 
rtResetErrorsMachine(CLK := G_bResetAllErrors);
IF rtResetErrorsMachine.Q THEN
    
    MovementAllowed := FALSE;

    NextState := E_MachineState#INIT;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - ErrorState', 'Error acknowledged, returning to INIT', E_ErrorSeverity#Info);
END_IF;
