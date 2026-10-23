(* Status *)
DATA_GROUP.Status.GroupControl.Valid			:=GroupControl_Group.Valid;				(* 	Indicates that the function is operating normally and the outputs of the function are valid *)
DATA_GROUP.Status.GroupControl.Busy				:=GroupControl_Group.Busy;				(*  Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information	*)
DATA_GROUP.Status.GroupControl.GroupStatus		:=GroupControl_Group.GroupStatus;		(*  Indicates if the group is enabled *)
DATA_GROUP.Status.GroupControl.PowerStatus		:=GroupControl_Group.PowerStatus;		(*  Indicates that all axis in the group are powered *)
DATA_GROUP.Status.GroupControl.ControllerAlarm 	:=GroupControl_Group.ControllerAlarm;	(*  Indicates a controller side axis alarm *)
DATA_GROUP.Status.GroupControl.ControllerAlarmID:=GroupControl_Group.ControllerAlarmID;	(*  Indicates the controller alarm ID number *)
DATA_GROUP.Status.GroupControl.GroupError		:=GroupControl_Group.GroupError;		(*  Indicates a group alarm *)
DATA_GROUP.Status.GroupControl.GroupErrorClass	:=GroupControl_Group.GroupErrorClass;	(*  The error class indicates the source of the error *)
DATA_GROUP.Status.GroupControl.GroupErrorID		:=GroupControl_Group.GroupErrorID;		(*  Indicates the group alarm ID number *)
DATA_GROUP.Status.GroupControl.GroupErrorSubCode:=GroupControl_Group.GroupErrorSubCode;	(*  If using a remote hosted Robot Controller via MotomanSync, this output reports additional error detail *)
DATA_GROUP.Status.GroupControl.AxisAlarms		:=GroupControl_Group.AxisAlarms;		(*  Indicates an axis alarm *)
DATA_GROUP.Status.GroupControl.AxisErrorClass	:=GroupControl_Group.AxisErrorClass;	(*  The error class indicates the source of the error *)
DATA_GROUP.Status.GroupControl.AxisErrorID		:=GroupControl_Group.AxisErrorID;		(*  Indicates the axis alarm ID number *)
DATA_GROUP.Status.GroupControl.AxisWarnings		:=GroupControl_Group.AxisWarnings;		(*  Indicates an axis warning *)
DATA_GROUP.Status.GroupControl.AxisWarningID	:=GroupControl_Group.AxisWarningID;		(*  Indicates the axis warning ID number *)

DATA_GROUP.Status.GroupReadStatus.Valid                 := GroupReadStatus_Group.Valid;
DATA_GROUP.Status.GroupReadStatus.Busy                  := GroupReadStatus_Group.Busy;
DATA_GROUP.Status.GroupReadStatus.GroupMoving           := GroupReadStatus_Group.GroupMoving;
DATA_GROUP.Status.GroupReadStatus.GroupHoming           := GroupReadStatus_Group.GroupHoming; 
DATA_GROUP.Status.GroupReadStatus.GroupErrorStop        := GroupReadStatus_Group.GroupErrorStop;
DATA_GROUP.Status.GroupReadStatus.GroupStandby          := GroupReadStatus_Group.GroupStandby;
DATA_GROUP.Status.GroupReadStatus.GroupStopping         := GroupReadStatus_Group.GroupStopping;
DATA_GROUP.Status.GroupReadStatus.GroupDisabled         := GroupReadStatus_Group.GroupDisabled;
DATA_GROUP.Status.GroupReadStatus.ConstantVelocity      := GroupReadStatus_Group.ConstantVelocity; 
DATA_GROUP.Status.GroupReadStatus.Accelerating          := GroupReadStatus_Group.Accelerating;
DATA_GROUP.Status.GroupReadStatus.Decelerating          := GroupReadStatus_Group.Decelerating;
DATA_GROUP.Status.GroupReadStatus.InPosition            := GroupReadStatus_Group.InPosition;
DATA_GROUP.Status.GroupReadStatus.StandStill            := GroupReadStatus_Group.StandStill;
DATA_GROUP.Status.GroupReadStatus.Interrupted           := GroupReadStatus_Group.Interrupted;
DATA_GROUP.Status.GroupReadStatus.SynchronizedMotion    := GroupReadStatus_Group.SynchronizedMotion;
DATA_GROUP.Status.GroupReadStatus.DiscreteMotion        := GroupReadStatus_Group.DiscreteMotion;
DATA_GROUP.Status.GroupReadStatus.ContinuousMotion      := GroupReadStatus_Group.ContinuousMotion;

//DATA_GROUP.Status.ResetAbsEncDone.Axis_S		:=FB_ResetAbsEnc_S.AbsEncResetDone;		(*  Absolute Reset Encoder is done (S axis) *)
//DATA_GROUP.Status.ResetAbsEncDone.Axis_L		:=FB_ResetAbsEnc_L.AbsEncResetDone;		(*  Absolute Reset Encoder is done (L axis) *)
//DATA_GROUP.Status.ResetAbsEncDone.Axis_U		:=FB_ResetAbsEnc_U.AbsEncResetDone;		(*  Absolute Reset Encoder is done (U axis) *)
//DATA_GROUP.Status.ResetAbsEncDone.Axis_T		:=FB_ResetAbsEnc_T.AbsEncResetDone;		(*  Absolute Reset Encoder is done (T axis) *)
//DATA_GROUP.Status.ResetAbsEncDone.Axis_B		:=FB_ResetAbsEnc_B.AbsEncResetDone;		(*  Absolute Reset Encoder is done (T axis) *)

DATA_GROUP.Status.EmergencyGroupStop.Done		:=GroupStop_Group.Done;
DATA_GROUP.Status.EmergencyGroupStop.Busy		:=GroupStop_Group.Busy;
//DATA_GROUP.Status.EmergencyGroupStop.Active		:=GroupStop_Group.Active;
DATA_GROUP.Status.EmergencyGroupStop.CommandAborted	:=GroupStop_Group.CommandAborted;

DATA_GROUP.Status.MoveLinearAbsolute.Done		:=MoveLinearAbsolute_Group.Done;
DATA_GROUP.Status.MoveLinearAbsolute.Busy		:=MoveLinearAbsolute_Group.Busy;
DATA_GROUP.Status.MoveLinearAbsolute.Active		:=MoveLinearAbsolute_Group.Active;
DATA_GROUP.Status.MoveLinearAbsolute.CommandAborted	:=MoveLinearAbsolute_Group.CommandAborted;

(************************ BLEND ************************)
DATA_GROUP.Status.MoveLinearAbsolute_Blend1.Done			:=MoveLinearAbsolute_Blend1.Done;
DATA_GROUP.Status.MoveLinearAbsolute_Blend1.Busy			:=MoveLinearAbsolute_Blend1.Busy;
DATA_GROUP.Status.MoveLinearAbsolute_Blend1.Active			:=MoveLinearAbsolute_Blend1.Active;
DATA_GROUP.Status.MoveLinearAbsolute_Blend1.CommandAborted	:=MoveLinearAbsolute_Blend1.CommandAborted;

DATA_GROUP.Status.MoveLinearAbsolute_Blend2.Done			:=MoveLinearAbsolute_Blend2.Done;
DATA_GROUP.Status.MoveLinearAbsolute_Blend2.Busy			:=MoveLinearAbsolute_Blend2.Busy;
DATA_GROUP.Status.MoveLinearAbsolute_Blend2.Active			:=MoveLinearAbsolute_Blend2.Active;
DATA_GROUP.Status.MoveLinearAbsolute_Blend2.CommandAborted	:=MoveLinearAbsolute_Blend2.CommandAborted;

DATA_GROUP.Status.MoveLinearAbsolute_Blend3.Done			:=MoveLinearAbsolute_Blend3.Done;
DATA_GROUP.Status.MoveLinearAbsolute_Blend3.Busy			:=MoveLinearAbsolute_Blend3.Busy;
DATA_GROUP.Status.MoveLinearAbsolute_Blend3.Active			:=MoveLinearAbsolute_Blend3.Active;
DATA_GROUP.Status.MoveLinearAbsolute_Blend3.CommandAborted	:=MoveLinearAbsolute_Blend3.CommandAborted;
(*******************************************************)

DATA_GROUP.Status.MoveLinearRelative.Done		:=MoveLinearRelative_Group.Done;
DATA_GROUP.Status.MoveLinearRelative.Busy		:=MoveLinearRelative_Group.Busy;
DATA_GROUP.Status.MoveLinearRelative.Active		:=MoveLinearRelative_Group.Active;
DATA_GROUP.Status.MoveLinearRelative.CommandAborted	:=MoveLinearRelative_Group.CommandAborted;

DATA_GROUP.Status.GroupJogJoint.Valid			:=GroupJogJoint_Group.Valid;
(*DATA_GROUP.Status.GroupJogJoint.Done			:=GroupJogJoint_Group.Done;*)
DATA_GROUP.Status.GroupJogJoint.Busy			:=GroupJogJoint_Group.Busy;
DATA_GROUP.Status.GroupJogJoint.Active			:=GroupJogJoint_Group.Active;
DATA_GROUP.Status.GroupJogJoint.CommandAborted	:=GroupJogJoint_Group.CommandAborted;

DATA_GROUP.Status.GroupJogLinear.Valid			:=GroupJogLinear_Group.Valid;
DATA_GROUP.Status.GroupJogLinear.Done			:=GroupJogLinear_Group.Done;
DATA_GROUP.Status.GroupJogLinear.Busy			:=GroupJogLinear_Group.Busy;
DATA_GROUP.Status.GroupJogLinear.Active			:=GroupJogLinear_Group.Active;
DATA_GROUP.Status.GroupJogLinear.CommandAborted	:=GroupJogLinear_Group.CommandAborted;

DATA_GROUP.Status.GroupSetPosition.Done         :=GroupSetPosition_Group.Done;
DATA_GROUP.Status.GroupSetPosition.Busy         :=GroupSetPosition_Group.Busy;
DATA_GROUP.Status.GroupSetPosition.Active       :=GroupSetPosition_Group.Active;
DATA_GROUP.Status.GroupSetPosition.CommandAborted   :=GroupSetPosition_Group.CommandAborted;

DATA_GROUP.Status.TrackConveyorBelt.Done		:=TrackConveyorBelt_Group.Done;
DATA_GROUP.Status.TrackConveyorBelt.Busy		:=TrackConveyorBelt_Group.Busy;
DATA_GROUP.Status.TrackConveyorBelt.Active		:=TrackConveyorBelt_Group.Active;
DATA_GROUP.Status.TrackConveyorBelt.InSync		:=TrackConveyorBelt_Group.InSync;
DATA_GROUP.Status.TrackConveyorBelt.CommandAborted	:=TrackConveyorBelt_Group.CommandAborted;

(*
DATA_GROUP.Status.GroupBrakeRelease.Axis_S.Done	:=GroupBrakeRelease_Axis_S.Done;
DATA_GROUP.Status.GroupBrakeRelease.Axis_S.Busy	:=GroupBrakeRelease_Axis_S.Busy;
DATA_GROUP.Status.GroupBrakeRelease.Axis_L.Done	:=GroupBrakeRelease_Axis_L.Done;
DATA_GROUP.Status.GroupBrakeRelease.Axis_L.Busy	:=GroupBrakeRelease_Axis_L.Busy;
DATA_GROUP.Status.GroupBrakeRelease.Axis_U.Done	:=GroupBrakeRelease_Axis_U.Done;
DATA_GROUP.Status.GroupBrakeRelease.Axis_U.Busy	:=GroupBrakeRelease_Axis_U.Busy;
DATA_GROUP.Status.GroupBrakeRelease.Axis_T.Done	:=GroupBrakeRelease_Axis_T.Done;
DATA_GROUP.Status.GroupBrakeRelease.Axis_T.Busy	:=GroupBrakeRelease_Axis_T.Busy;
DATA_GROUP.Status.GroupBrakeRelease.Axis_B.Done	:=GroupBrakeRelease_Axis_B.Done;
DATA_GROUP.Status.GroupBrakeRelease.Axis_B.Busy	:=GroupBrakeRelease_Axis_B.Busy;
*)

//DATA_GROUP.Status.ControllerAlarm.Valid		:=ControllerAlarm_MP3300.Valid;
//DATA_GROUP.Status.ControllerAlarm.Alarm		:=ControllerAlarm_MP3300.Alarm;
//DATA_GROUP.Status.ControllerAlarm.AlarmID	:=ControllerAlarm_MP3300.AlarmID;

DATA_GROUP.Status.SetPosition.Axis_S.Done	:=SetPosition_S.Done;
DATA_GROUP.Status.SetPosition.Axis_S.Busy	:=SetPosition_S.Busy;
DATA_GROUP.Status.SetPosition.Axis_L.Done	:=SetPosition_L.Done;
DATA_GROUP.Status.SetPosition.Axis_L.Busy	:=SetPosition_L.Busy;
DATA_GROUP.Status.SetPosition.Axis_U.Done	:=SetPosition_U.Done;
DATA_GROUP.Status.SetPosition.Axis_U.Busy	:=SetPosition_U.Busy;
DATA_GROUP.Status.SetPosition.Axis_T.Done	:=SetPosition_T.Done;
DATA_GROUP.Status.SetPosition.Axis_T.Busy	:=SetPosition_T.Busy;
DATA_GROUP.Status.SetPosition.Axis_B.Done	:=SetPosition_B.Done;
DATA_GROUP.Status.SetPosition.Axis_B.Busy	:=SetPosition_B.Busy;

DATA_GROUP.Status.FrameTypeTransform.Done	:=FrameTypeTransform_Group.Done;
DATA_GROUP.Status.FrameTypeTransform.Singularity :=FrameTypeTransform_Group.Singularity;

//DATA_GROUP.Status.CalcFrameOffset_ENO		:=CalcFrameOffset_Group.ENO;

DATA_GROUP.Status.GroupSetFrameOffset.Busy :=GroupSetFrameOffset_Group.Busy;
DATA_GROUP.Status.GroupSetFrameOffset.Done :=GroupSetFrameOffset_Group.Done;

(* Feedbacks *)
// DATA_GROUP.Feedback.ActualPos_Group.ACS	:=GroupReadActualPos_Group_ACS.Position;    Feedbacks of position values (ACS Coordinate System) 
// DATA_GROUP.Feedback.ActualPos_Group.MCS	:=GroupReadActualPos_Group_MCS.Position;    Feedbacks of position values (MCS Coordinate System) 
// DATA_GROUP.Feedback.ActualPos_Group.PCS	:=GroupReadActualPos_Group_PCS.Position;    Feedbacks of position values (PCS Coordinate System) 
// DATA_GROUP.Feedback.ActualPos_Group.TCS	:=GroupReadActualPos_Group_TCS.Position;    Feedbacks of position values (TCS Coordinate System) 
// DATA_GROUP.Feedback.ActualPos_Group.WCS	:=GroupReadActualPos_Group_WCS.Position;    Feedbacks of position values (WCS Coordinate System) 
// DATA_GROUP.Feedback.ActualPos_Group.TPCS	:=GroupReadActualPos_Group_TPCS.Position;   Feedbacks of position values (TPCS Coordinate System)

DATA_GROUP.Feedback.ActualPos_Group.ACS		:=AxesGroupRef.Axis.ActualPos;			(*	Feedbacks of position values (ACS Coordinate System) *)
DATA_GROUP.Feedback.ActualPos_Group.MCS		:=AxesGroupRef.Machine.ActualPos;		(*	Feedbacks of position values (MCS Coordinate System) *)
DATA_GROUP.Feedback.ActualPos_Group.PCS		:=AxesGroupRef.Part.ActualPos;			(*	Feedbacks of position values (PCS Coordinate System) *)
DATA_GROUP.Feedback.ActualPos_Group.TCS		:=AxesGroupRef.Tool.ActualPos;			(*	Feedbacks of position values (TCS Coordinate System) *)
DATA_GROUP.Feedback.ActualPos_Group.WCS		:=AxesGroupRef.World.ActualPos;		(*	Feedbacks of position values (WCS Coordinate System) *)

DATA_GROUP.Feedback.ActualVel_Group.ACS		:=AxesGroupRef.Axis.ActualVel;			(*	Feedbacks of velocity values (ACS Coordinate System) *)
DATA_GROUP.Feedback.ActualVel_Group.MCS		:=AxesGroupRef.Machine.ActualVel;		(*	Feedbacks of velocity values (MCS Coordinate System) *)
DATA_GROUP.Feedback.ActualVel_Group.PCS		:=AxesGroupRef.Part.ActualVel;			(*	Feedbacks of velocity values (PCS Coordinate System) *)
DATA_GROUP.Feedback.ActualVel_Group.TCS		:=AxesGroupRef.Tool.ActualVel;			(*	Feedbacks of velocity values (TCS Coordinate System) *)
DATA_GROUP.Feedback.ActualVel_Group.WCS		:=AxesGroupRef.World.ActualVel;		(*	Feedbacks of velocity values (WCS Coordinate System) *)

DATA_GROUP.Feedback.ActualAccel_Group.ACS	:=AxesGroupRef.Axis.ActualAccel;		(*	Feedbacks of acceleration values (ACS Coordinate System) *)
DATA_GROUP.Feedback.ActualAccel_Group.MCS	:=AxesGroupRef.Machine.ActualAccel;	(*	Feedbacks of acceleration values (MCS Coordinate System) *)
DATA_GROUP.Feedback.ActualAccel_Group.PCS	:=AxesGroupRef.Part.ActualAccel;		(*	Feedbacks of acceleration values (PCS Coordinate System) *)
DATA_GROUP.Feedback.ActualAccel_Group.TCS	:=AxesGroupRef.Tool.ActualAccel;		(*	Feedbacks of acceleration values (TCS Coordinate System) *)
DATA_GROUP.Feedback.ActualAccel_Group.WCS	:=AxesGroupRef.World.ActualAccel;		(*	Feedbacks of acceleration values (WCS Coordinate System) *)

DATA_GROUP.Feedback.ActualPos_Axis.Axis_S	:=ReadActualPos_Axis_S.Position;	(*	Feedbacks of position value of S axis *)
DATA_GROUP.Feedback.ActualPos_Axis.Axis_L	:=ReadActualPos_Axis_L.Position;	(*	Feedbacks of position value of L axis *)
DATA_GROUP.Feedback.ActualPos_Axis.Axis_U	:=ReadActualPos_Axis_U.Position;	(*	Feedbacks of position value of U axis *)
DATA_GROUP.Feedback.ActualPos_Axis.Axis_T	:=ReadActualPos_Axis_T.Position;	(*	Feedbacks of position value of RX axis *)
DATA_GROUP.Feedback.ActualPos_Axis.Axis_B	:=ReadActualPos_Axis_B.Position;	(*	Feedbacks of position value of RX axis *)

DATA_GROUP.Feedback.TrackState				:=TrackState;

(*******************************************************************************************************************************************)

(* Errors *)
DATA_GROUP.Error.GroupControl.Error			:=GroupControl_Group.Error;		(*  Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low *)
DATA_GROUP.Error.GroupControl.ErrorID		:=GroupControl_Group.ErrorID;	(*  If Error is true, this output provides the Error ID *)

DATA_GROUP.Error.GroupReadStatus.Error      :=GroupReadStatus_Group.Error;		
DATA_GROUP.Error.GroupReadStatus.ErrorID	:=GroupReadStatus_Group.ErrorID;	

DATA_GROUP.Error.MoveLinearAbsolute.Error	:=MoveLinearAbsolute_Group.Error;
DATA_GROUP.Error.MoveLinearAbsolute.ErrorID	:=MoveLinearAbsolute_Group.ErrorID;

(************************ BLEND ************************)
DATA_GROUP.Error.MoveLinearAbsolute_Blend1.Error	:=MoveLinearAbsolute_Blend1.Error;
DATA_GROUP.Error.MoveLinearAbsolute_Blend1.ErrorID	:=MoveLinearAbsolute_Blend1.ErrorID;

DATA_GROUP.Error.MoveLinearAbsolute_Blend2.Error	:=MoveLinearAbsolute_Blend2.Error;
DATA_GROUP.Error.MoveLinearAbsolute_Blend2.ErrorID	:=MoveLinearAbsolute_Blend2.ErrorID;

DATA_GROUP.Error.MoveLinearAbsolute_Blend3.Error	:=MoveLinearAbsolute_Blend3.Error;
DATA_GROUP.Error.MoveLinearAbsolute_Blend3.ErrorID	:=MoveLinearAbsolute_Blend3.ErrorID;
(*******************************************************)

DATA_GROUP.Error.MoveLinearRelative.Error		:=MoveLinearRelative_Group.Error;
DATA_GROUP.Error.MoveLinearRelative.ErrorID		:=MoveLinearRelative_Group.ErrorID;

DATA_GROUP.Error.GroupJogJoint.Error			:=GroupJogJoint_Group.Error;
DATA_GROUP.Error.GroupJogJoint.ErrorID			:=GroupJogJoint_Group.ErrorID;

DATA_GROUP.Error.GroupJogLinear.Error			:=GroupJogLinear_Group.Error;
DATA_GROUP.Error.GroupJogLinear.ErrorID			:=GroupJogLinear_Group.ErrorID;

DATA_GROUP.Error.GroupSetPosition.Error         :=GroupSetPosition_Group.Error;
DATA_GROUP.Error.GroupSetPosition.ErrorID       :=GroupSetPosition_Group.ErrorID;

//DATA_GROUP.Error.ResetAbsEnc.Axis_S.Error		:=FB_ResetAbsEnc_S.Error;
//DATA_GROUP.Error.ResetAbsEnc.Axis_S.ErrorID		:=FB_ResetAbsEnc_S.ErrorID;
//DATA_GROUP.Error.ResetAbsEnc.Axis_L.Error		:=FB_ResetAbsEnc_L.Error;
//DATA_GROUP.Error.ResetAbsEnc.Axis_L.ErrorID		:=FB_ResetAbsEnc_L.ErrorID;
//DATA_GROUP.Error.ResetAbsEnc.Axis_U.Error		:=FB_ResetAbsEnc_U.Error;
//DATA_GROUP.Error.ResetAbsEnc.Axis_U.ErrorID		:=FB_ResetAbsEnc_U.ErrorID;
//DATA_GROUP.Error.ResetAbsEnc.Axis_T.Error		:=FB_ResetAbsEnc_T.Error;
//DATA_GROUP.Error.ResetAbsEnc.Axis_T.ErrorID		:=FB_ResetAbsEnc_T.ErrorID;
//DATA_GROUP.Error.ResetAbsEnc.Axis_B.Error		:=FB_ResetAbsEnc_B.Error;
//DATA_GROUP.Error.ResetAbsEnc.Axis_B.ErrorID		:=FB_ResetAbsEnc_B.ErrorID;

DATA_GROUP.Error.EmergencyGroupStop.Error		:=GroupStop_Group.Error;
DATA_GROUP.Error.EmergencyGroupStop.ErrorID		:=GroupStop_Group.ErrorID;

(*
DATA_GROUP.Error.GroupBrakeRelease.Axis_S.Error		:=GroupBrakeRelease_Axis_S.Error;
DATA_GROUP.Error.GroupBrakeRelease.Axis_S.ErrorID	:=GroupBrakeRelease_Axis_S.ErrorID;
DATA_GROUP.Error.GroupBrakeRelease.Axis_L.Error		:=GroupBrakeRelease_Axis_L.Error;
DATA_GROUP.Error.GroupBrakeRelease.Axis_L.ErrorID	:=GroupBrakeRelease_Axis_L.ErrorID;
DATA_GROUP.Error.GroupBrakeRelease.Axis_U.Error		:=GroupBrakeRelease_Axis_U.Error;
DATA_GROUP.Error.GroupBrakeRelease.Axis_U.ErrorID	:=GroupBrakeRelease_Axis_U.ErrorID;
DATA_GROUP.Error.GroupBrakeRelease.Axis_T.Error		:=GroupBrakeRelease_Axis_T.Error;
DATA_GROUP.Error.GroupBrakeRelease.Axis_T.ErrorID	:=GroupBrakeRelease_Axis_T.ErrorID;
DATA_GROUP.Error.GroupBrakeRelease.Axis_B.Error		:=GroupBrakeRelease_Axis_B.Error;
DATA_GROUP.Error.GroupBrakeRelease.Axis_B.ErrorID	:=GroupBrakeRelease_Axis_B.ErrorID;
*)

DATA_GROUP.Error.GroupReadActualPos.ACS.Error		:=GroupReadActualPos_Group_ACS.Error;		
DATA_GROUP.Error.GroupReadActualPos.ACS.ErrorID		:=GroupReadActualPos_Group_ACS.ErrorID;		
DATA_GROUP.Error.GroupReadActualPos.MCS.Error		:=GroupReadActualPos_Group_MCS.Error;
DATA_GROUP.Error.GroupReadActualPos.MCS.ErrorID		:=GroupReadActualPos_Group_MCS.ErrorID;
DATA_GROUP.Error.GroupReadActualPos.PCS.Error		:=GroupReadActualPos_Group_PCS.Error;
DATA_GROUP.Error.GroupReadActualPos.PCS.ErrorID		:=GroupReadActualPos_Group_PCS.ErrorID;
DATA_GROUP.Error.GroupReadActualPos.TCS.Error		:=GroupReadActualPos_Group_TCS.Error;
DATA_GROUP.Error.GroupReadActualPos.TCS.ErrorID		:=GroupReadActualPos_Group_TCS.ErrorID;
DATA_GROUP.Error.GroupReadActualPos.WCS.Error		:=GroupReadActualPos_Group_WCS.Error;
DATA_GROUP.Error.GroupReadActualPos.WCS.ErrorID		:=GroupReadActualPos_Group_WCS.ErrorID;
DATA_GROUP.Error.GroupReadActualPos.TPCS.Error		:=GroupReadActualPos_Group_TPCS.Error;
DATA_GROUP.Error.GroupReadActualPos.TPCS.ErrorID	:=GroupReadActualPos_Group_TPCS.ErrorID;

DATA_GROUP.Error.ReadActualPos.Axis_S.Error		:=ReadActualPos_Axis_S.Error;
DATA_GROUP.Error.ReadActualPos.Axis_S.ErrorID	:=ReadActualPos_Axis_S.ErrorID;		
DATA_GROUP.Error.ReadActualPos.Axis_L.Error		:=ReadActualPos_Axis_L.Error;
DATA_GROUP.Error.ReadActualPos.Axis_L.ErrorID	:=ReadActualPos_Axis_L.ErrorID;
DATA_GROUP.Error.ReadActualPos.Axis_U.Error		:=ReadActualPos_Axis_U.Error;
DATA_GROUP.Error.ReadActualPos.Axis_U.ErrorID	:=ReadActualPos_Axis_U.ErrorID;
DATA_GROUP.Error.ReadActualPos.Axis_T.Error		:=ReadActualPos_Axis_T.Error;
DATA_GROUP.Error.ReadActualPos.Axis_T.ErrorID	:=ReadActualPos_Axis_T.ErrorID;
DATA_GROUP.Error.ReadActualPos.Axis_B.Error		:=ReadActualPos_Axis_B.Error;
DATA_GROUP.Error.ReadActualPos.Axis_B.ErrorID	:=ReadActualPos_Axis_B.ErrorID;

DATA_GROUP.Error.SetPosition.Axis_S.Error		:=SetPosition_S.Error;
DATA_GROUP.Error.SetPosition.Axis_S.ErrorID		:=SetPosition_S.ErrorID;
DATA_GROUP.Error.SetPosition.Axis_L.Error		:=SetPosition_L.Error;
DATA_GROUP.Error.SetPosition.Axis_L.ErrorID		:=SetPosition_L.ErrorID;
DATA_GROUP.Error.SetPosition.Axis_U.Error		:=SetPosition_U.Error;
DATA_GROUP.Error.SetPosition.Axis_U.ErrorID		:=SetPosition_U.ErrorID;
DATA_GROUP.Error.SetPosition.Axis_T.Error		:=SetPosition_T.Error;
DATA_GROUP.Error.SetPosition.Axis_T.ErrorID		:=SetPosition_T.ErrorID;
DATA_GROUP.Error.SetPosition.Axis_B.Error		:=SetPosition_B.Error;
DATA_GROUP.Error.SetPosition.Axis_B.ErrorID		:=SetPosition_B.ErrorID;

DATA_GROUP.Error.FrameTypeTransform.Error		:= FrameTypeTransform_Group.Error;
DATA_GROUP.Error.FrameTypeTransform.ErrorID		:= FrameTypeTransform_Group.ErrorID;

DATA_GROUP.Error.GroupSetFrameOffset.Error		:= GroupSetFrameOffset_Group.Error;
DATA_GROUP.Error.GroupSetFrameOffset.ErrorID	:= GroupSetFrameOffset_Group.ErrorID;

DATA_GROUP.Error.TrackConveyorBelt.Error		:= TrackConveyorBelt_Group.Error;
DATA_GROUP.Error.TrackConveyorBelt.ErrorID		:= TrackConveyorBelt_Group.ErrorID;

DATA_GROUP.Status.Errors :=		DATA_GROUP.Error.GroupControl.Error OR
                                DATA_GROUP.Error.GroupReadStatus.Error OR
								DATA_GROUP.Error.MoveLinearAbsolute.Error OR
								DATA_GROUP.Error.MoveLinearAbsolute_Blend1.Error OR
								DATA_GROUP.Error.MoveLinearAbsolute_Blend2.Error OR
								DATA_GROUP.Error.MoveLinearAbsolute_Blend3.Error OR
								DATA_GROUP.Error.MoveLinearRelative.Error OR
								DATA_GROUP.Error.GroupJogJoint.Error OR
								DATA_GROUP.Error.GroupJogLinear.Error OR
								DATA_GROUP.Error.ResetAbsEnc.Axis_S.Error OR
								DATA_GROUP.Error.ResetAbsEnc.Axis_L.Error OR
								DATA_GROUP.Error.ResetAbsEnc.Axis_U.Error OR
								DATA_GROUP.Error.ResetAbsEnc.Axis_T.Error OR
								DATA_GROUP.Error.ResetAbsEnc.Axis_B.Error OR
								DATA_GROUP.Error.EmergencyGroupStop.Error OR
								DATA_GROUP.Error.GroupBrakeRelease.Axis_S.Error OR
								DATA_GROUP.Error.GroupBrakeRelease.Axis_L.Error OR
								DATA_GROUP.Error.GroupBrakeRelease.Axis_U.Error OR
								DATA_GROUP.Error.GroupBrakeRelease.Axis_T.Error OR
								DATA_GROUP.Error.GroupBrakeRelease.Axis_B.Error OR
								DATA_GROUP.Error.GroupReadActualPos.ACS.Error OR
								DATA_GROUP.Error.GroupReadActualPos.MCS.Error OR
								DATA_GROUP.Error.GroupReadActualPos.PCS.Error OR
								DATA_GROUP.Error.GroupReadActualPos.TCS.Error OR
								DATA_GROUP.Error.GroupReadActualPos.WCS.Error OR
								DATA_GROUP.Error.GroupReadActualPos.TPCS.Error OR
								DATA_GROUP.Error.ReadActualPos.Axis_S.Error OR
								DATA_GROUP.Error.ReadActualPos.Axis_L.Error OR
								DATA_GROUP.Error.ReadActualPos.Axis_U.Error OR
								DATA_GROUP.Error.ReadActualPos.Axis_T.Error OR
								DATA_GROUP.Error.ReadActualPos.Axis_B.Error OR
								DATA_GROUP.Error.ControllerAlarm.Error OR
								DATA_GROUP.Error.SetPosition.Axis_S.Error OR
								DATA_GROUP.Error.SetPosition.Axis_L.Error OR
								DATA_GROUP.Error.SetPosition.Axis_U.Error OR
								DATA_GROUP.Error.SetPosition.Axis_T.Error OR
								DATA_GROUP.Error.SetPosition.Axis_B.Error OR
								DATA_GROUP.Error.FrameTypeTransform.Error OR
								DATA_GROUP.Error.TrackConveyorBelt.Error OR
								DATA_GROUP.Error.GroupSetFrameOffset.Error;