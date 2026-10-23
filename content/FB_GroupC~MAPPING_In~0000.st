(* Commands *)
GroupControl_Group.Enable			:=DATA_GROUP.Command.GroupControl.Enable;			(*	The function "GroupControl" will continue to execute every scan while Enable is held high and there are no errors. *)
GroupControl_Group.EnableGroup		:=DATA_GROUP.Command.GroupControl.En_Group;			(*	If TRUE, the MC_GroupEnable function block will be executed. If FALSE, the MC_GroupDisable function block will be executed. *)
GroupControl_Group.EnablePower		:=DATA_GROUP.Command.GroupControl.En_Power;			(*	If TRUE, all the axes belonging to the AxesGroup will be powered *)
GroupControl_Group.AlarmClear		:=DATA_GROUP.Command.GroupControl.AlarmClear;		(*	Executes MC_GroupReset, MC_Reset, and Y_ClearAlarms based on the current alarms related to the AxesGroup *)
MoveLinearAbsolute_Group.Execute	:=DATA_GROUP.Command.En_MoveLinearAbsolute;			(*	Executes an interpolated linear movement on an AxesGroup to an absolute position in the specified coordinate system *)
MoveLinearAbsolute_Blend1.Execute	:=DATA_GROUP.Command.En_MoveLinearAbsolute_Blend1;	(*	Executes an interpolated linear movement on an AxesGroup to an absolute position in the specified coordinate system *)
MoveLinearAbsolute_Blend2.Execute	:=DATA_GROUP.Command.En_MoveLinearAbsolute_Blend2;	(*	Executes an interpolated linear movement on an AxesGroup to an absolute position in the specified coordinate system *)
MoveLinearAbsolute_Blend3.Execute	:=DATA_GROUP.Command.En_MoveLinearAbsolute_Blend3;	(*	Executes an interpolated linear movement on an AxesGroup to an absolute position in the specified coordinate system *)
MoveLinearRelative_Group.Execute	:=DATA_GROUP.Command.En_MoveLinearRelative;			(*	Executes an interpolated linear movement on an AxesGroup from the commanded position of the group at the time this function block initiates motion to a relative position in the specified coordinate system *)
GroupJogJoint_Group.Enable			:=DATA_GROUP.Command.En_GroupJogJoint;				(*	Executes a jog of a Group's Joint in the Axis Coordinate System (ACS) *)
GroupJogLinear_Group.Enable			:=DATA_GROUP.Command.En_GroupJogLinear;				(*	Executes a jog of a group toward a specified n dimensional Position in the specified CoordSystem *)
TrackConveyorBelt_Group.Execute		:=DATA_GROUP.Command.En_TrackConveyorBelt;
GroupSetPosition_Group.Execute      :=DATA_GROUP.Command.En_GroupSetPosition;

//FB_ResetAbsEnc_S.ResetAbsEnc	:=DATA_GROUP.Command.ResetAbsEnc.Axis_S;	(* 	Reset Absolute Encoder S axis *)
//FB_ResetAbsEnc_L.ResetAbsEnc	:=DATA_GROUP.Command.ResetAbsEnc.Axis_L;	(* 	Reset Absolute Encoder L axis *)
//FB_ResetAbsEnc_U.ResetAbsEnc	:=DATA_GROUP.Command.ResetAbsEnc.Axis_U;	(* 	Reset Absolute Encoder U axis *)
//FB_ResetAbsEnc_T.ResetAbsEnc	:=DATA_GROUP.Command.ResetAbsEnc.Axis_T;	(* 	Reset Absolute Encoder T axis *)
//FB_ResetAbsEnc_B.ResetAbsEnc	:=DATA_GROUP.Command.ResetAbsEnc.Axis_B;	(* 	Reset Absolute Encoder T axis *)

GroupStop_Group.Execute		:=DATA_GROUP.Command.En_EmergencyGroupStop;

(*
GroupBrakeRelease_Axis_S.Execute	:=DATA_GROUP.Command.GroupBrakeRelease.Axis_S;
GroupBrakeRelease_Axis_L.Execute	:=DATA_GROUP.Command.GroupBrakeRelease.Axis_L;
GroupBrakeRelease_Axis_U.Execute	:=DATA_GROUP.Command.GroupBrakeRelease.Axis_U;
GroupBrakeRelease_Axis_T.Execute	:=DATA_GROUP.Command.GroupBrakeRelease.Axis_T;
GroupBrakeRelease_Axis_B.Execute	:=DATA_GROUP.Command.GroupBrakeRelease.Axis_B;
*)

SetPosition_S.Execute	:=DATA_GROUP.Command.SetPosition.Axis_S;
SetPosition_L.Execute	:=DATA_GROUP.Command.SetPosition.Axis_L;
SetPosition_U.Execute	:=DATA_GROUP.Command.SetPosition.Axis_U;
SetPosition_T.Execute	:=DATA_GROUP.Command.SetPosition.Axis_T;
SetPosition_B.Execute	:=DATA_GROUP.Command.SetPosition.Axis_B;

FrameTypeTransform_Group.Execute    :=DATA_GROUP.Command.En_FrameTypeTransform;
CalcFrameOffset_Group.Enable		:=DATA_GROUP.Command.En_CalcFrameOffset;
GroupSetFrameOffset_Group.Execute	:=DATA_GROUP.Command.En_GroupSetFrameOffset;

(* Settings *)
MoveLinearAbsolute_Group.Position		     	:=DATA_GROUP.Setting.MoveLinearAbsolute.Position;				(* 	Array of position values *)
MoveLinearAbsolute_Group.Velocity				:=DATA_GROUP.Setting.MoveLinearAbsolute.Velocity;				(* 	Absolute value of the velocity *)
MoveLinearAbsolute_Group.Acceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute.Acceleration;			(* 	Value of the acceleration *)
MoveLinearAbsolute_Group.Deceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute.Deceleration;			(* 	Value of the deceleration *)
MoveLinearAbsolute_Group.Jerk					:=DATA_GROUP.Setting.MoveLinearAbsolute.Jerk;					(* 	Not supported; reserved for future use *)
MoveLinearAbsolute_Group.MoveOptions			:=DATA_GROUP.Setting.MoveLinearAbsolute.MoveOptions;			(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions  *)
MoveLinearAbsolute_Group.CoordSystem			:=DATA_GROUP.Setting.MoveLinearAbsolute.CoordSystem;			(* 	Coordinate System *)
MoveLinearAbsolute_Group.BufferMode				:=DATA_GROUP.Setting.MoveLinearAbsolute.BufferMode;				(* 	Defines the behavior of the axis *)
MoveLinearAbsolute_Group.TransitionMode			:=DATA_GROUP.Setting.MoveLinearAbsolute.TransitionMode;			(* 	Specifies how segments are blended together *)
MoveLinearAbsolute_Group.TransitionParameter	:=DATA_GROUP.Setting.MoveLinearAbsolute.TransitionParameter;	(* 	Additional parameters for the selected TransitionMode *)

(************************ BLEND ************************)
MoveLinearAbsolute_Blend1.Position				:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Position;			(* 	Array of position values *)
MoveLinearAbsolute_Blend1.Velocity				:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Velocity;			(* 	Absolute value of the velocity *)
MoveLinearAbsolute_Blend1.Acceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Acceleration;		(* 	Value of the acceleration *)
MoveLinearAbsolute_Blend1.Deceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Deceleration;		(* 	Value of the deceleration *)
MoveLinearAbsolute_Blend1.Jerk					:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.Jerk;				(* 	Not supported; reserved for future use *)
MoveLinearAbsolute_Blend1.MoveOptions			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.MoveOptions;			(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions  *)
MoveLinearAbsolute_Blend1.CoordSystem			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.CoordSystem;			(* 	Coordinate System *)
MoveLinearAbsolute_Blend1.BufferMode			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.BufferMode;			(* 	Defines the behavior of the axis *)
MoveLinearAbsolute_Blend1.TransitionMode		:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.TransitionMode;		(* 	Specifies how segments are blended together *)
MoveLinearAbsolute_Blend1.TransitionParameter	:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend1.TransitionParameter;	(* 	Additional parameters for the selected TransitionMode *)

MoveLinearAbsolute_Blend2.Position				:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Position;			(* 	Array of position values *)
MoveLinearAbsolute_Blend2.Velocity				:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Velocity;			(* 	Absolute value of the velocity *)
MoveLinearAbsolute_Blend2.Acceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Acceleration;		(* 	Value of the acceleration *)
MoveLinearAbsolute_Blend2.Deceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Deceleration;		(* 	Value of the deceleration *)
MoveLinearAbsolute_Blend2.Jerk					:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.Jerk;				(* 	Not supported; reserved for future use *)
MoveLinearAbsolute_Blend2.MoveOptions			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.MoveOptions;			(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions  *)
MoveLinearAbsolute_Blend2.CoordSystem			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.CoordSystem;			(* 	Coordinate System *)
MoveLinearAbsolute_Blend2.BufferMode			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.BufferMode;			(* 	Defines the behavior of the axis *)
MoveLinearAbsolute_Blend2.TransitionMode		:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.TransitionMode;		(* 	Specifies how segments are blended together *)
MoveLinearAbsolute_Blend2.TransitionParameter	:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend2.TransitionParameter;	(* 	Additional parameters for the selected TransitionMode *)

MoveLinearAbsolute_Blend3.Position				:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Position;			(* 	Array of position values *)
MoveLinearAbsolute_Blend3.Velocity				:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Velocity;			(* 	Absolute value of the velocity *)
MoveLinearAbsolute_Blend3.Acceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Acceleration;		(* 	Value of the acceleration *)
MoveLinearAbsolute_Blend3.Deceleration			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Deceleration;		(* 	Value of the deceleration *)
MoveLinearAbsolute_Blend3.Jerk					:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.Jerk;				(* 	Not supported; reserved for future use *)
MoveLinearAbsolute_Blend3.MoveOptions			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.MoveOptions;			(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions  *)
MoveLinearAbsolute_Blend3.CoordSystem			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.CoordSystem;			(* 	Coordinate System *)
MoveLinearAbsolute_Blend3.BufferMode			:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.BufferMode;			(* 	Defines the behavior of the axis *)
MoveLinearAbsolute_Blend3.TransitionMode		:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.TransitionMode;		(* 	Specifies how segments are blended together *)
MoveLinearAbsolute_Blend3.TransitionParameter	:=DATA_GROUP.Setting.MoveLinearAbsolute_Blend3.TransitionParameter;	(* 	Additional parameters for the selected TransitionMode *)
(*******************************************************)

MoveLinearRelative_Group.Distance				:=DATA_GROUP.Setting.MoveLinearRelative.Distance;				(* 	Array of distance values *)
MoveLinearRelative_Group.Velocity				:=DATA_GROUP.Setting.MoveLinearRelative.Velocity;				(* 	Absolute value of the velocity *)
MoveLinearRelative_Group.Acceleration			:=DATA_GROUP.Setting.MoveLinearRelative.Acceleration;			(* 	Value of the acceleration *)
MoveLinearRelative_Group.Deceleration			:=DATA_GROUP.Setting.MoveLinearRelative.Deceleration;			(* 	Value of the deceleration *)
MoveLinearRelative_Group.Jerk					:=DATA_GROUP.Setting.MoveLinearRelative.Jerk;					(* 	Not supported; reserved for future use *)
MoveLinearRelative_Group.MoveOptions			:=DATA_GROUP.Setting.MoveLinearRelative.MoveOptions;			(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions *)
MoveLinearRelative_Group.CoordSystem			:=DATA_GROUP.Setting.MoveLinearRelative.CoordSystem;			(* 	Coordinate System *)
MoveLinearRelative_Group.BufferMode				:=DATA_GROUP.Setting.MoveLinearRelative.BufferMode;				(* 	Defines the behavior of the axis *)
MoveLinearRelative_Group.TransitionMode			:=DATA_GROUP.Setting.MoveLinearRelative.TransitionMode;			(* 	Specifies how segments are blended together *)
MoveLinearRelative_Group.TransitionParameter	:=DATA_GROUP.Setting.MoveLinearRelative.TransitionParameter;	(* 	Additional parameters for the selected TransitionMode *)

GroupJogJoint_Group.JointIndex		:=DATA_GROUP.Setting.GroupJogJoint.JointIndex;		(* 	Refer to the Hardware Configuration's group definition chart which shows the Index for each of the axes in the group *)
GroupJogJoint_Group.Velocity		:=DATA_GROUP.Setting.GroupJogJoint.Velocity;		(* 	Value of the Velocity *)
GroupJogJoint_Group.Acceleration	:=DATA_GROUP.Setting.GroupJogJoint.Acceleration;	(* 	Value of the Acceleration *)
GroupJogJoint_Group.Deceleration	:=DATA_GROUP.Setting.GroupJogJoint.Deceleration;	(* 	Value of the Deceleration *)
GroupJogJoint_Group.Jerk			:=DATA_GROUP.Setting.GroupJogJoint.Jerk;			(*	Not supported; reserved for future use *)
GroupJogJoint_Group.MoveOptions		:=DATA_GROUP.Setting.GroupJogJoint.MoveOptions;		(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions *)
GroupJogJoint_Group.Direction		:=DATA_GROUP.Setting.GroupJogJoint.Direction;		(* 	Specifies the direction of motion *)
GroupJogJoint_Group.BufferMode		:=DATA_GROUP.Setting.GroupJogJoint.BufferMode;		(* 	Defines the behavior of the axis *)

GroupJogLinear_Group.Position		:=DATA_GROUP.Setting.GroupJogLinear.Position;		(* 	Array of absolute positions *)
GroupJogLinear_Group.Velocity		:=DATA_GROUP.Setting.GroupJogLinear.Velocity;		(* 	Absolute value of the velocity *)
GroupJogLinear_Group.Acceleration	:=DATA_GROUP.Setting.GroupJogLinear.Acceleration;	(* 	Value of the acceleration *)
GroupJogLinear_Group.Deceleration	:=DATA_GROUP.Setting.GroupJogLinear.Deceleration;	(* 	Value of the deceleration *)
GroupJogLinear_Group.Jerk			:=DATA_GROUP.Setting.GroupJogLinear.Jerk;			(* 	Not supported; reserved for future use *)
GroupJogLinear_Group.MoveOptions	:=DATA_GROUP.Setting.GroupJogLinear.MoveOptions;	(* 	Commands to specify the pose of a robot mechanism, Y_GroupMoveOptions *)
GroupJogLinear_Group.CoordSystem	:=DATA_GROUP.Setting.GroupJogLinear.CoordSystem;	(* 	Coordinate System *)
GroupJogLinear_Group.BufferMode		:=DATA_GROUP.Setting.GroupJogLinear.BufferMode;		(* 	Defines the behavior of the axis *)

GroupSetPosition_Group.Position     :=DATA_GROUP.Setting.GroupSetPosition.Position;
GroupSetPosition_Group.Relative     :=DATA_GROUP.Setting.GroupSetPosition.Relative;
GroupSetPosition_Group.CoordSystem  :=DATA_GROUP.Setting.GroupSetPosition.CoordSystem;
GroupSetPosition_Group.SetMode      :=DATA_GROUP.Setting.GroupSetPosition.SetMode;
GroupSetPosition_Group.BufferMode   :=DATA_GROUP.Setting.GroupSetPosition.BufferMode;

TrackConveyorBelt_Group.ConveyorBelt			:=DATA_GROUP.Setting.TrackConveyorBelt.ConveyorBelt;
TrackConveyorBelt_Group.ConveyorBeltOrigin		:=DATA_GROUP.Setting.TrackConveyorBelt.ConveyorBeltOrigin;
TrackConveyorBelt_Group.InitialObjectPosition	:=DATA_GROUP.Setting.TrackConveyorBelt.InitialObjectPosition;
TrackConveyorBelt_Group.RecordedPosition		:=DATA_GROUP.Setting.TrackConveyorBelt.RecordedPosition;
TrackConveyorBelt_Group.StartDistance			:=DATA_GROUP.Setting.TrackConveyorBelt.StartDistance;
TrackConveyorBelt_Group.EndDistance				:=DATA_GROUP.Setting.TrackConveyorBelt.EndDistance;
TrackConveyorBelt_Group.TrackOptions			:=DATA_GROUP.Setting.TrackConveyorBelt.TrackOptions;
TrackConveyorBelt_Group.ExecutionMode			:=DATA_GROUP.Setting.TrackConveyorBelt.ExecutionMode;

SetPosition_S.Position	:=DATA_GROUP.Setting.SetPosition.Axis_S.Position;		(*	A positive or negative value within the coordinate system in user units *)
SetPosition_S.Mode		:=DATA_GROUP.Setting.SetPosition.Axis_S.Mode;			(*	ABSOLUTE = False (Default), RELATIVE =True. This refers to the coordinate system, not the motor type *)
SetPosition_L.Position	:=DATA_GROUP.Setting.SetPosition.Axis_L.Position;		(*	A positive or negative value within the coordinate system in user units *)
SetPosition_L.Mode		:=DATA_GROUP.Setting.SetPosition.Axis_L.Mode;			(*	ABSOLUTE = False (Default), RELATIVE =True. This refers to the coordinate system, not the motor type *)
SetPosition_U.Position	:=DATA_GROUP.Setting.SetPosition.Axis_U.Position;		(*	A positive or negative value within the coordinate system in user units *)
SetPosition_U.Mode		:=DATA_GROUP.Setting.SetPosition.Axis_U.Mode;			(*	ABSOLUTE = False (Default), RELATIVE =True. This refers to the coordinate system, not the motor type *)
SetPosition_T.Position	:=DATA_GROUP.Setting.SetPosition.Axis_T.Position;		(*	A positive or negative value within the coordinate system in user units *)
SetPosition_T.Mode		:=DATA_GROUP.Setting.SetPosition.Axis_T.Mode;			(*	ABSOLUTE = False (Default), RELATIVE =True. This refers to the coordinate system, not the motor type *)
SetPosition_B.Position	:=DATA_GROUP.Setting.SetPosition.Axis_B.Position;		(*	A positive or negative value within the coordinate system in user units *)
SetPosition_B.Mode		:=DATA_GROUP.Setting.SetPosition.Axis_B.Mode;			(*	ABSOLUTE = False (Default), RELATIVE =True. This refers to the coordinate system, not the motor type *)

//FB_ResetAbsEnc_S.AbsEncPos	:=DATA_GROUP.Setting.ResetAbsEncPos.Axis_S;	(* 	Position for make homing S axis *)
//FB_ResetAbsEnc_L.AbsEncPos	:=DATA_GROUP.Setting.ResetAbsEncPos.Axis_L;	(* 	Position for make homing L axis *)
//FB_ResetAbsEnc_U.AbsEncPos	:=DATA_GROUP.Setting.ResetAbsEncPos.Axis_U;	(* 	Position for make homing U axis *)
//FB_ResetAbsEnc_T.AbsEncPos	:=DATA_GROUP.Setting.ResetAbsEncPos.Axis_T;	(* 	Position for make homing T axis *)
//FB_ResetAbsEnc_B.AbsEncPos	:=DATA_GROUP.Setting.ResetAbsEncPos.Axis_B;	(* 	Position for make homing T axis *)

GroupStop_Group.Deceleration	:=DATA_GROUP.Setting.EmergencyGroupStop.Deceleration;	(* 	Value of the deceleration *)

(*
GroupBrakeRelease_Axis_S.State	:=DATA_GROUP.Setting.GroupBrakeRelease.Axis_S;			(* State - FALSE=Brake Applied, TRUE=Brake Released *)
GroupBrakeRelease_Axis_L.State	:=DATA_GROUP.Setting.GroupBrakeRelease.Axis_L;			(* State - FALSE=Brake Applied, TRUE=Brake Released *)
GroupBrakeRelease_Axis_U.State	:=DATA_GROUP.Setting.GroupBrakeRelease.Axis_U;			(* State - FALSE=Brake Applied, TRUE=Brake Released *)
GroupBrakeRelease_Axis_T.State	:=DATA_GROUP.Setting.GroupBrakeRelease.Axis_T;			(* State - FALSE=Brake Applied, TRUE=Brake Released *)
GroupBrakeRelease_Axis_B.State	:=DATA_GROUP.Setting.GroupBrakeRelease.Axis_B;			(* State - FALSE=Brake Applied, TRUE=Brake Released *)
*)

FrameTypeTransform_Group.OO	:=DATA_GROUP.Setting.FrameTypeTransform.OO;
FrameTypeTransform_Group.XX	:=DATA_GROUP.Setting.FrameTypeTransform.XX;
FrameTypeTransform_Group.XY	:=DATA_GROUP.Setting.FrameTypeTransform.XY;

GroupSetFrameOffset_Group.Offset :=DATA_GROUP.Setting.GroupSetFrameOffset.Offset;
GroupSetFrameOffset_Group.ExecutionMode :=DATA_GROUP.Setting.GroupSetFrameOffset.ExecutionMode;
GroupSetFrameOffset_Group.RefCoordSystem :=DATA_GROUP.Setting.GroupSetFrameOffset.RefCoordSystem;
GroupSetFrameOffset_Group.SetCoordSystem :=DATA_GROUP.Setting.GroupSetFrameOffset.SetCoordSystem;