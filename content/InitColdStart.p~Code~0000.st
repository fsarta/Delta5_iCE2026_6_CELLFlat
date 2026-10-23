(*============================================================================================*)
(*                                          DASHBOARD                                         *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
HMI_Data.Dashboard.Command.PowerUp := FALSE;
HMI_Data.Dashboard.Command.PowerDown := FALSE;
HMI_Data.Dashboard.Command.StartCycle := FALSE;
HMI_Data.Dashboard.Command.StopCycle := FALSE;

HMI_Data.Dashboard.Command.ResetErrors := FALSE;
HMI_Data.Dashboard.Command.AckErrors := FALSE;

HMI_Data.Dashboard.Command.ResetAxis[1] := FALSE;
HMI_Data.Dashboard.Command.ResetAxis[2] := FALSE;
HMI_Data.Dashboard.Command.ResetAxis[3] := FALSE;
HMI_Data.Dashboard.Command.ResetAxis[4] := FALSE;
HMI_Data.Dashboard.Command.ResetAxis[5] := FALSE;
HMI_Data.Dashboard.Command.ResetAxis[6] := FALSE;
HMI_Data.Dashboard.Command.ResetAxis[7] := FALSE;

HMI_Data.Dashboard.Command.RebootAxis[1] := FALSE;
HMI_Data.Dashboard.Command.RebootAxis[2] := FALSE;
HMI_Data.Dashboard.Command.RebootAxis[3] := FALSE;
HMI_Data.Dashboard.Command.RebootAxis[4] := FALSE;
HMI_Data.Dashboard.Command.RebootAxis[5] := FALSE;
HMI_Data.Dashboard.Command.RebootAxis[6] := FALSE;
HMI_Data.Dashboard.Command.RebootAxis[7] := FALSE;

(*============================================================================================*)
(*                                            ROBOT                                           *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
HMI_Data.Robot.Command.Joint_Mode := FALSE;
HMI_Data.Robot.Command.Linear_Mode := FALSE;
        
HMI_Data.Robot.Command.JogJoint.S_Plus := FALSE;
HMI_Data.Robot.Command.JogJoint.S_Minus := FALSE;
HMI_Data.Robot.Command.JogJoint.L_Plus := FALSE;
HMI_Data.Robot.Command.JogJoint.L_Minus := FALSE;
HMI_Data.Robot.Command.JogJoint.U_Plus := FALSE;
HMI_Data.Robot.Command.JogJoint.U_Minus := FALSE;
HMI_Data.Robot.Command.JogJoint.B_Plus := FALSE;
HMI_Data.Robot.Command.JogJoint.B_Minus := FALSE;
HMI_Data.Robot.Command.JogJoint.T_Plus := FALSE;
HMI_Data.Robot.Command.JogJoint.T_Minus := FALSE;
        
HMI_Data.Robot.Command.JogLinear.X_Plus := FALSE;
HMI_Data.Robot.Command.JogLinear.X_Minus := FALSE;
HMI_Data.Robot.Command.JogLinear.Y_Plus := FALSE;
HMI_Data.Robot.Command.JogLinear.Y_Minus := FALSE;
HMI_Data.Robot.Command.JogLinear.Z_Plus := FALSE;
HMI_Data.Robot.Command.JogLinear.Z_Minus := FALSE;
HMI_Data.Robot.Command.JogLinear.Rz_Plus := FALSE;
HMI_Data.Robot.Command.JogLinear.Rz_Minus := FALSE;
HMI_Data.Robot.Command.JogLinear.Ry_Plus := FALSE;
HMI_Data.Robot.Command.JogLinear.Ry_Minus := FALSE;

HMI_Data.Robot.Command.Slow_Speed := TRUE;
HMI_Data.Robot.Command.Medium_Speed := FALSE;
HMI_Data.Robot.Command.Fast_Speed := FALSE;
//HMI_Data.Robot.Command.Speed_Selected_HMI;
        
HMI_Data.Robot.Command.GroupSetPosition := FALSE;
HMI_Data.Robot.Command.MoveAbsolute := FALSE;
HMI_Data.Robot.Command.MoveRelative := FALSE;

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
HMI_Data.Robot.Setting.HomingPosition := zeroVector;
HMI_Data.Robot.Setting.CommandPosition := zeroVector;
HMI_Data.Robot.Setting.CommandVelocity := 0.0;
HMI_Data.Robot.Setting.CommandAcceleration := 0.0;
HMI_Data.Robot.Setting.CommandDeceleration := 0.0;
HMI_Data.Robot.Setting.CommandDistance := zeroVector;
HMI_Data.Robot.Setting.CommandVelocity := 0.0;
HMI_Data.Robot.Setting.CommandAcceleration := 0.0;
HMI_Data.Robot.Setting.CommandDeceleration := 0.0;

(*============================================================================================*)
(*                                            AXIS                                            *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)

// FeedIn
HMI_Data.Axis.FeedIn.Command.JogFWD := FALSE;
HMI_Data.Axis.FeedIn.Command.JogREV := FALSE;
HMI_Data.Axis.FeedIn.Command.MoveAbsolute := FALSE;
HMI_Data.Axis.FeedIn.Command.MoveRelative := FALSE;
HMI_Data.Axis.FeedIn.Command.SetPosition := FALSE;
        
// FeedOut
HMI_Data.Axis.FeedOut.Command.JogFWD := FALSE;
HMI_Data.Axis.FeedOut.Command.JogREV := FALSE;
HMI_Data.Axis.FeedOut.Command.MoveAbsolute := FALSE;
HMI_Data.Axis.FeedOut.Command.MoveRelative := FALSE;
HMI_Data.Axis.FeedOut.Command.SetPosition := FALSE;

// Virtual
HMI_Data.Axis.Virtual.Command.JogFWD := FALSE;
HMI_Data.Axis.Virtual.Command.JogREV := FALSE;
HMI_Data.Axis.Virtual.Command.MoveAbsolute := FALSE;
HMI_Data.Axis.Virtual.Command.MoveRelative := FALSE;
HMI_Data.Axis.Virtual.Command.SetPosition := FALSE;

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)

// FeedIn
HMI_Data.Axis.FeedIn.Setting.CommandPosition := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandDistance := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandVelocity := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandAcceleration := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandDeceleration := 0.0;
HMI_Data.Axis.FeedIn.Setting.HomingPosition := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandVelocity := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandAcceleration := 0.0;
HMI_Data.Axis.FeedIn.Setting.CommandDeceleration := 0.0;

        
// FeedOut
HMI_Data.Axis.FeedOut.Setting.CommandPosition := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandDistance := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandVelocity := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandAcceleration := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandDeceleration := 0.0;
HMI_Data.Axis.FeedOut.Setting.HomingPosition := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandVelocity := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandAcceleration := 0.0;
HMI_Data.Axis.FeedOut.Setting.CommandDeceleration := 0.0;

// Virtual
HMI_Data.Axis.Virtual.Setting.CommandPosition := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandDistance := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandVelocity := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandAcceleration := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandDeceleration := 0.0;
HMI_Data.Axis.Virtual.Setting.HomingPosition := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandVelocity := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandAcceleration := 0.0;
HMI_Data.Axis.Virtual.Setting.CommandDeceleration := 0.0;

(*============================================================================================*)
(*                                         TEACH FRAME                                        *)
(*============================================================================================*)

(*---------------------------------------- (HMI to PLC) --------------------------------------*)
HMI_Data.TeachFrame.StartTeach := FALSE;
HMI_Data.TeachFrame.SelectedFrame := 1;
HMI_Data.TeachFrame.SelectedPoint := eFrame#NONE;
HMI_Data.TeachFrame.ConfirmPoint := FALSE;

(*============================================================================================*)
(*                                           PROCESS                                          *)
(*============================================================================================*)

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
//HMI_Data.Process.Setting.OperationMode := E_PickPlaceMode#MODE_SINGLE_PICK;   

(*============================================================================================*)
(*                                           VISION                                           *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
//HMI_Data.Vision.Command.TriggerCamera
//HMI_Data.Vision.Command.ChangeJob

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
//OffsetVisionRobotWorkspace := HMI_Data.Vision.Setting.DistanceVisionRobotWorkspace;   