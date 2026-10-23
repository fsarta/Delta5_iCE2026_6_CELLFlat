DATA_Delta.Setting.EmergencyGroupStop.Deceleration := 10000.0;


// Determine the jogging speed level based on button presses.
// Prioritize speed selection if multiple buttons are pressed (e.g., Fast > Medium > Slow).
IF RobotJog.Fast_Speed THEN
    iJogSpeedLevel := 2; // Index for Fast speed
ELSIF RobotJog.Medium_Speed THEN
    iJogSpeedLevel := 1; // Index for Medium speed
ELSIF RobotJog.Slow_Speed THEN
    iJogSpeedLevel := 0; // Index for Slow speed
END_IF;

// --- Fixed Jogging Speeds per Joint and per Speed Level ---
// a_lrFixedJogJointSpeeds[JointIndex, SpeedLevelIndex]
// Joint S (Index 1):   [5.0, 15.0, 25.0]
// Joint L (Index 2):   [5.0, 15.0, 25.0]
// Joint U (Index 3):   [5.0, 15.0, 25.0]
// Joint R (Index 4):   [25.0, 75.0, 125.0]

a_lrFixedJogJointSpeeds [1][0] := 5.0; 
a_lrFixedJogJointSpeeds [1][1] := 15.0; 
a_lrFixedJogJointSpeeds [1][2] := 25.0;
 
a_lrFixedJogJointSpeeds [2][0] := 5.0; 
a_lrFixedJogJointSpeeds [2][1] := 15.0; 
a_lrFixedJogJointSpeeds [2][2] := 25.0; 
 
a_lrFixedJogJointSpeeds [3][0] := 5.0; 
a_lrFixedJogJointSpeeds [3][1] := 15.0; 
a_lrFixedJogJointSpeeds [3][2] := 25.0; 
 
a_lrFixedJogJointSpeeds [4][0] := 25.0; 
a_lrFixedJogJointSpeeds [4][1] := 75.0; 
a_lrFixedJogJointSpeeds [4][2] := 125.0; 

a_lrFixedJogJointSpeeds [5][0] := 25.0; 
a_lrFixedJogJointSpeeds [5][1] := 75.0; 
a_lrFixedJogJointSpeeds [5][2] := 125.0; 

a_lrFixedJogJointAcceleration [1][0] := 50.0; 
a_lrFixedJogJointAcceleration [1][1] := 150.0; 
a_lrFixedJogJointAcceleration [1][2] := 250.0;
 
a_lrFixedJogJointAcceleration [2][0] := 50.0; 
a_lrFixedJogJointAcceleration [2][1] := 150.0; 
a_lrFixedJogJointAcceleration [2][2] := 250.0; 
 
a_lrFixedJogJointAcceleration [3][0] := 50.0; 
a_lrFixedJogJointAcceleration [3][1] := 150.0; 
a_lrFixedJogJointAcceleration [3][2] := 250.0; 
 
a_lrFixedJogJointAcceleration [4][0] := 250.0; 
a_lrFixedJogJointAcceleration [4][1] := 750.0; 
a_lrFixedJogJointAcceleration [4][2] := 1250.0; 

a_lrFixedJogJointAcceleration [5][0] := 250.0; 
a_lrFixedJogJointAcceleration [5][1] := 750.0; 
a_lrFixedJogJointAcceleration [5][2] := 1250.0;

a_lrFixedJogJointDeceleration [1][0] := 50.0; 
a_lrFixedJogJointDeceleration [1][1] := 150.0; 
a_lrFixedJogJointDeceleration [1][2] := 250.0;
 
a_lrFixedJogJointDeceleration [2][0] := 50.0; 
a_lrFixedJogJointDeceleration [2][1] := 150.0; 
a_lrFixedJogJointDeceleration [2][2] := 250.0; 
 
a_lrFixedJogJointDeceleration [3][0] := 50.0; 
a_lrFixedJogJointDeceleration [3][1] := 150.0; 
a_lrFixedJogJointDeceleration [3][2] := 250.0; 
 
a_lrFixedJogJointDeceleration [4][0] := 250.0; 
a_lrFixedJogJointDeceleration [4][1] := 750.0; 
a_lrFixedJogJointDeceleration [4][2] := 1250.0; 

a_lrFixedJogJointDeceleration [5][0] := 250.0; 
a_lrFixedJogJointDeceleration [5][1] := 750.0; 
a_lrFixedJogJointDeceleration [5][2] := 1250.0;



//a_lrFixedJogJointSpeeds := [[5.0, 15.0, 25.0], [6.0, 16.0, 26.0], [7.0, 17.0, 27.0], [25.0, 75.0, 125.0]];

// Determine which specific joint is being jogged and in which direction.
IF RobotJog.JogJoint.S_Plus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 1; // S-Axis is Joint 1
    DATA_Delta.Setting.GroupJogJoint.Direction := 0; // Positive direction
ELSIF RobotJog.JogJoint.S_Minus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 1; // S-Axis is Joint 1
    DATA_Delta.Setting.GroupJogJoint.Direction := 2; // Negative direction
ELSIF RobotJog.JogJoint.L_Plus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 2; // L-Axis is Joint 2
    DATA_Delta.Setting.GroupJogJoint.Direction := 0; // Positive direction
ELSIF RobotJog.JogJoint.L_Minus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 2; // L-Axis is Joint 2
    DATA_Delta.Setting.GroupJogJoint.Direction := 2; // Negative direction
ELSIF RobotJog.JogJoint.U_Plus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 3; // U-Axis is Joint 3
    DATA_Delta.Setting.GroupJogJoint.Direction := 0; // Positive direction
ELSIF RobotJog.JogJoint.U_Minus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 3; // U-Axis is Joint 3
    DATA_Delta.Setting.GroupJogJoint.Direction := 2; // Negative direction
ELSIF RobotJog.JogJoint.T_Plus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 4; // T-Axis is Joint 4
    DATA_Delta.Setting.GroupJogJoint.Direction := 0; // Positive direction
ELSIF RobotJog.JogJoint.T_Minus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 4; // T-Axis is Joint 4
    DATA_Delta.Setting.GroupJogJoint.Direction := 2; // Negative direction
ELSIF RobotJog.JogJoint.B_Plus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 5; // B-Axis is Joint 5
    DATA_Delta.Setting.GroupJogJoint.Direction := 0; // Positive direction
ELSIF RobotJog.JogJoint.B_Minus THEN
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 5; // B-Axis is Joint 5
    DATA_Delta.Setting.GroupJogJoint.Direction := 2; // Negative direction
ELSE
    // If no jog joint button is pressed or the general enable condition is false,
    // ensure no joint is selected and the overall jog enable for the FB is false.
    DATA_Delta.Setting.GroupJogJoint.JointIndex := 1; // Explicitly no joint selected
END_IF;

DATA_Delta.Setting.GroupJogJoint.Acceleration := a_lrFixedJogJointAcceleration[DATA_Delta.Setting.GroupJogJoint.JointIndex][0] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.GroupJogJoint.Deceleration := a_lrFixedJogJointDeceleration[DATA_Delta.Setting.GroupJogJoint.JointIndex][0] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.GroupJogJoint.Velocity := a_lrFixedJogJointSpeeds[DATA_Delta.Setting.GroupJogJoint.JointIndex][0] * (MotionDataOverride / 100.0);

// --- Fixed Linear Jogging Speeds per Speed Level ---
// a_lrFixedJogLinearSpeeds[SpeedLevelIndex]
// [5.0, 15.0, 25.0]

a_lrFixedJogLinearSpeeds [0] := 50.0; 
a_lrFixedJogLinearSpeeds [1] := 300.0; 
a_lrFixedJogLinearSpeeds [2] := 750.0;

a_lrFixedJogLinearAcceleration [0] := 50.0; 
a_lrFixedJogLinearAcceleration [1] := 3000.0; 
a_lrFixedJogLinearAcceleration [2] := 5000.0;

a_lrFixedJogLinearDeceleration [0] := 50.0; 
a_lrFixedJogLinearDeceleration [1] := 3000.0; 
a_lrFixedJogLinearDeceleration [2] := 5000.0;

// Determine which specific linear direction (X, Y, or Z) is being jogged and its sign.
IF RobotJog.JogLinear.X_Plus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DELTA.Limits.MachineLimits.MaxPosition[1] - 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[1] + 100.0;
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.X_Minus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DELTA.Limits.MachineLimits.MinPosition[1] + 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[1] - 100.0;
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];    
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Y_Plus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DELTA.Limits.MachineLimits.MaxPosition[2] - 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[2] + 100.0;
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Y_Minus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DELTA.Limits.MachineLimits.MinPosition[2] + 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[2] - 100.0;
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Z_Plus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DELTA.Limits.MachineLimits.MaxPosition[3] - 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[3] + 10.0;
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Z_Minus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DELTA.Limits.MachineLimits.MinPosition[3] + 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[3] - 10.0;
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[1] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Rz_Plus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DELTA.Limits.MachineLimits.MaxPosition[6] - 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[6] + 1.0;
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Rz_Minus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DELTA.Limits.MachineLimits.MinPosition[6] + 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[6] - 1.0;
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DATA_Delta.Feedback.ActualPos_Group.MCS[5];
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Ry_Plus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DELTA.Limits.MachineLimits.MaxPosition[5] - 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[5] + 1.0;
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
ELSIF RobotJog.JogLinear.Ry_Minus THEN
    DATA_Delta.Setting.GroupJogLinear.Position[1] := DATA_Delta.Feedback.ActualPos_Group.MCS[1];
    DATA_Delta.Setting.GroupJogLinear.Position[2] := DATA_Delta.Feedback.ActualPos_Group.MCS[2];
    DATA_Delta.Setting.GroupJogLinear.Position[3] := DATA_Delta.Feedback.ActualPos_Group.MCS[3];
    DATA_Delta.Setting.GroupJogLinear.Position[6] := DATA_Delta.Feedback.ActualPos_Group.MCS[6];
    DATA_Delta.Setting.GroupJogLinear.Position[5] := DELTA.Limits.MachineLimits.MinPosition[5] + 5.0;//DATA_Delta.Feedback.ActualPos_Group.MCS[5] - 1.0;
    DATA_Delta.Setting.GroupJogLinear.Acceleration      := a_lrFixedJogLinearAcceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Deceleration      := a_lrFixedJogLinearDeceleration[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.Velocity          := a_lrFixedJogLinearSpeeds[0] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.GroupJogLinear.MoveOptions.VelocityUnit  := 2;
END_IF;

DATA_Delta.Setting.GroupJogLinear.CoordSystem       := MC_CoordinateSystem#MCS;

IF RobotJog.MCS_Mode AND NOT(RobotJog.ACS_Mode) THEN
    DATA_Delta.Setting.MoveLinearAbsolute.Acceleration  := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearAbsolute.Deceleration  := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearAbsolute.Velocity      := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearAbsolute.CoordSystem := MC_CoordinateSystem#MCS;
ELSIF RobotJog.ACS_Mode AND NOT(RobotJog.MCS_Mode) THEN
    DATA_Delta.Setting.MoveLinearAbsolute.Acceleration  := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearAbsolute.Deceleration  := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearAbsolute.Velocity      := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearAbsolute.CoordSystem := MC_CoordinateSystem#ACS;
END_IF;
DATA_Delta.Setting.MoveLinearAbsolute.MoveOptions.VelocityUnit := 2;

IF RobotJog.MCS_Mode AND NOT(RobotJog.ACS_Mode) THEN
    DATA_Delta.Setting.MoveLinearRelative.Acceleration  := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearRelative.Deceleration  := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearRelative.Velocity      := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearRelative.CoordSystem := MC_CoordinateSystem#MCS;
ELSIF RobotJog.ACS_Mode AND NOT(RobotJog.MCS_Mode) THEN
    DATA_Delta.Setting.MoveLinearRelative.Acceleration  := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearRelative.Deceleration  := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearRelative.Velocity      := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
    DATA_Delta.Setting.MoveLinearRelative.CoordSystem := MC_CoordinateSystem#ACS;
END_IF;
DATA_Delta.Setting.MoveLinearRelative.MoveOptions.VelocityUnit := 2;

//MinRamp_Delta := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
//DATA_Delta.Setting.GroupJogLinear.Deceleration := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);;
//Speed_Delta := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);;




// ------------------------------------ AUTO ------------------------------------ //

Blend_CoordSystem := MC_CoordinateSystem#MCS;
Blend_BufferMode := MC_BufferMode#BlendingPrevious;
Blend_TransitionMode := MC_TransitionMode#TMStartVelocity;
//Blend_TransitionMode := MC_TransitionMode#TMConstantVelocity;
//Blend_TransitionMode := MC_TransitionMode#TMCornerDistance;
Blend_TransitionParameter[1] := 100.0;
Blend_TransitionParameter[2] := 100.0;
Blend_TransitionParameter[3] := 20.0;
Blend_TransitionParameter[4] := 10000.0;

DATA_Delta.Setting.TestGroupSetting[0].Position[1] := 200.0;
DATA_Delta.Setting.TestGroupSetting[0].Position[2] := 200.0;
DATA_Delta.Setting.TestGroupSetting[0].Position[3] := 740.0;
DATA_Delta.Setting.TestGroupSetting[0].Position[6] := -80.0;
DATA_Delta.Setting.TestGroupSetting[0].Speed := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[0].Acc := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[0].Dec := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[0].Delay := INT#0;
DATA_Delta.Setting.TestGroupSetting[0].CoordSystem := Blend_CoordSystem;
DATA_Delta.Setting.TestGroupSetting[0].BufferMode := Blend_BufferMode;
DATA_Delta.Setting.TestGroupSetting[0].TransitionMode := Blend_TransitionMode;
DATA_Delta.Setting.TestGroupSetting[0].TransitionParameter := Blend_TransitionParameter;
DATA_Delta.Setting.TestGroupSetting[0].MoveOptions_VelocityUnit := 2;
DATA_Delta.Setting.TestGroupSetting[0].LastItem := FALSE;

DATA_Delta.Setting.TestGroupSetting[1].Position[1] := -200.0;
DATA_Delta.Setting.TestGroupSetting[1].Position[2] := 200.0;
DATA_Delta.Setting.TestGroupSetting[1].Position[3] := 740.0;
DATA_Delta.Setting.TestGroupSetting[1].Position[6] := 120.0;
DATA_Delta.Setting.TestGroupSetting[1].Speed := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[1].Acc := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[1].Dec := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[1].Delay := INT#0;
DATA_Delta.Setting.TestGroupSetting[1].CoordSystem := Blend_CoordSystem;
DATA_Delta.Setting.TestGroupSetting[1].BufferMode := Blend_BufferMode;
DATA_Delta.Setting.TestGroupSetting[1].TransitionMode := Blend_TransitionMode;
DATA_Delta.Setting.TestGroupSetting[1].TransitionParameter := Blend_TransitionParameter;
DATA_Delta.Setting.TestGroupSetting[1].MoveOptions_VelocityUnit := 2;
DATA_Delta.Setting.TestGroupSetting[1].LastItem := FALSE;

DATA_Delta.Setting.TestGroupSetting[2].Position[1] := -200.0;
DATA_Delta.Setting.TestGroupSetting[2].Position[2] := -200.0;
DATA_Delta.Setting.TestGroupSetting[2].Position[3] := 710.0;
DATA_Delta.Setting.TestGroupSetting[2].Position[6] := -80.0;
DATA_Delta.Setting.TestGroupSetting[2].Speed := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[2].Acc := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[2].Dec := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[2].Delay := INT#0;
DATA_Delta.Setting.TestGroupSetting[2].CoordSystem := Blend_CoordSystem;
DATA_Delta.Setting.TestGroupSetting[2].BufferMode := Blend_BufferMode;
DATA_Delta.Setting.TestGroupSetting[2].TransitionMode := Blend_TransitionMode;
DATA_Delta.Setting.TestGroupSetting[2].TransitionParameter := Blend_TransitionParameter;
DATA_Delta.Setting.TestGroupSetting[2].MoveOptions_VelocityUnit := 2;
DATA_Delta.Setting.TestGroupSetting[2].LastItem := FALSE;

DATA_Delta.Setting.TestGroupSetting[3].Position[1] := 200.0;
DATA_Delta.Setting.TestGroupSetting[3].Position[2] := -200.0;
DATA_Delta.Setting.TestGroupSetting[3].Position[3] := 710.0;
DATA_Delta.Setting.TestGroupSetting[3].Position[6] := 120.0;
DATA_Delta.Setting.TestGroupSetting[3].Speed := a_lrFixedJogLinearSpeeds[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[3].Acc := a_lrFixedJogLinearAcceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[3].Dec := a_lrFixedJogLinearDeceleration[2] * (MotionDataOverride / 100.0);
DATA_Delta.Setting.TestGroupSetting[3].Delay := INT#0;
DATA_Delta.Setting.TestGroupSetting[3].CoordSystem := Blend_CoordSystem;
DATA_Delta.Setting.TestGroupSetting[3].BufferMode := Blend_BufferMode;
DATA_Delta.Setting.TestGroupSetting[3].TransitionMode := Blend_TransitionMode;
DATA_Delta.Setting.TestGroupSetting[3].TransitionParameter := Blend_TransitionParameter;
DATA_Delta.Setting.TestGroupSetting[3].MoveOptions_VelocityUnit := 2;
DATA_Delta.Setting.TestGroupSetting[3].LastItem := FALSE;

DATA_Delta.Setting.TestGroupSetting[4].LastItem := TRUE;
