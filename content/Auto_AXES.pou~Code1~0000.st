IF RobotJog.Fast_Speed THEN
    Velocity_TEST := 200.0;
ELSIF RobotJog.Medium_Speed THEN
    Velocity_TEST := 100.0;
ELSIF RobotJog.Slow_Speed THEN
    Velocity_TEST := 40.0;
END_IF;

R_TRIG1(CLK := xIsOscillating);

IF R_TRIG1.Q THEN
    STOP_VirtualMovement := TRUE;
END_IF;

FB_VirtualMovement1(
    Axis := VIRTUAL_AXIS, 
    EnableOscillation := DATA_Axes.Command.AutoAxes.Start, 
    Reset := NOT(DATA_Axes.Command.AutoAxes.Start), 
    StartPosition := 0.0, 
    EndPosition := 360.0, 
    Velocity := Velocity_TEST, 
    Acceleration := 7200.0, 
    Deceleration := 7200.0, 
    CurrentState => CurrentState_VirtualMovement, 
    IsOscillating => xIsOscillating, 
    Error => xError_VirtualMovement, 
    ErrorID => uiErrorID_VirtualMovement
    );

//IF NOT(DATA_Axes.Command.AutoAxes.Start) THEN
//    STOP_VirtualMovement := NOT(Rot_CamStateMachineState = E_CamStateMachineState#IDLE AND Lin_CamStateMachineState = E_CamStateMachineState#IDLE);
//ELSE
//    STOP_VirtualMovement := FALSE;
//END_IF;

EngageDataRot.StartMode := Yt_EngageMethod#AtPosition;
EngageDataRot.MasterRelative := FALSE;
EngageDataRot.SlaveAbsolute := TRUE;
DisengageDataRot.EndMode := Yt_DisengageMethod#AtPosition;

TriggerInputRot.Bit := 1;
TriggerInputRot.ID := 0;

FB_CamController1(
    EnableSequence := DATA_Axes.Command.AutoAxes.Start, 
    Reset := Reset_TEST, 
    MasterAxis := VIRTUAL_AXIS, 
    SlaveAxis := ROT_Axis, 
    GetTouchProbe := (CurrentState_VirtualMovement = E_OscillationState#MOVING_BACKWARD AND DATA_VirtAxis.Feedback.ActualPosition <= 180.0),
    CamData := CamRot_SegmentTable, 
    AllowCamIn := (CurrentState_VirtualMovement = E_OscillationState#MOVING_BACKWARD AND DATA_VirtAxis.Feedback.ActualPosition >= 180.0),
    EngagePosition := 360.0, 
    EngageWindow := 4.0, 
    Periodic := TRUE, 
    EngageData := EngageDataRot, 
    DisengagePosition := 360.0, 
    DisengageWindow := 4.0, 
    DisengageData := DisengageDataRot, 
    EnableTouchProbe := FALSE, 
    TriggerInput := TriggerInputRot,
    //SequenceComplete => BOOL, 
    //SequenceError => BOOL, 
    //SequenceErrorID => UDINT, 
    CurrentState => Rot_CamStateMachineState
    //CamSystemData => DT_CamData
    );
    
    

EngageDataLin.StartMode := Yt_EngageMethod#AtPosition;
EngageDataLin.MasterRelative := FALSE;
EngageDataLin.SlaveAbsolute := TRUE;
DisengageDataLin.EndMode := Yt_DisengageMethod#AtPosition;

FB_CamController2(
    EnableSequence := DATA_Axes.Command.AutoAxes.Start, 
    Reset := Reset_TEST, 
    MasterAxis := VIRTUAL_AXIS, 
    SlaveAxis := LIN_Axis, 
    GetTouchProbe := FALSE,
    CamData := CamLin_SegmentTable, 
    AllowCamIn := (CurrentState_VirtualMovement = E_OscillationState#MOVING_FORWARD AND DATA_VirtAxis.Feedback.ActualPosition <= 180.0),
    EngagePosition := 0.0, 
    EngageWindow := 4.0, 
    Periodic := TRUE, 
    EngageData := EngageDataLin, 
    DisengagePosition := 0.0, 
    DisengageWindow := 4.0, 
    DisengageData := DisengageDataLin, 
    EnableTouchProbe := FALSE, 
    TriggerInput := TriggerInputLin,
    //SequenceComplete => BOOL, 
    //SequenceError => BOOL, 
    //SequenceErrorID => UDINT, 
    CurrentState => Lin_CamStateMachineState
    //CamSystemData => DT_CamData
    );
    