(*
(*	this function is used to defining the position of an absolute encoder *)
(*	Axis_S *)
FB_ResetAbsEnc_1(
	AxisRef := AxesGroupRef.AxisRef[1],									(*	Axis reference *)
	ResetAbsEnc := FB_ResetAbsEnc_S.ResetAbsEnc,							(*	Reset Absolute Encoder Command *)
	AbsEncPos := FB_ResetAbsEnc_S.AbsEncPos									(*	Position value to do a reset of absolute encoder *)
	);
	FB_ResetAbsEnc_S.AbsEncResetDone := FB_ResetAbsEnc_1.AbsEncResetDone;	(*	Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low. *)
	FB_ResetAbsEnc_S.Error := FB_ResetAbsEnc_1.Error;						(*	Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low.  *)
	FB_ResetAbsEnc_S.ErrorID := FB_ResetAbsEnc_1.ErrorID;					(*	If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low.  *)

(*	As above *)
(*	Axis_L *)
FB_ResetAbsEnc_2(
	AxisRef := AxesGroupRef.AxisRef[2],
	ResetAbsEnc := FB_ResetAbsEnc_L.ResetAbsEnc,
	AbsEncPos := FB_ResetAbsEnc_L.AbsEncPos
	);
	FB_ResetAbsEnc_L.AbsEncResetDone := FB_ResetAbsEnc_2.AbsEncResetDone;
	FB_ResetAbsEnc_L.Error := FB_ResetAbsEnc_2.Error;
	FB_ResetAbsEnc_L.ErrorID := FB_ResetAbsEnc_2.ErrorID;

(*	As above *)
(*	Axis_U *)
FB_ResetAbsEnc_3(
	AxisRef := AxesGroupRef.AxisRef[3],
	ResetAbsEnc := FB_ResetAbsEnc_U.ResetAbsEnc,
	AbsEncPos := FB_ResetAbsEnc_U.AbsEncPos
	);
	FB_ResetAbsEnc_U.AbsEncResetDone := FB_ResetAbsEnc_3.AbsEncResetDone;
	FB_ResetAbsEnc_U.Error := FB_ResetAbsEnc_3.Error;
	FB_ResetAbsEnc_U.ErrorID := FB_ResetAbsEnc_3.ErrorID;


IF numAxes = INT#4 THEN
	(*	As above *)
	(*	Axis_T *)
	FB_ResetAbsEnc_4(
		AxisRef := AxesGroupRef.AxisRef[4],
		ResetAbsEnc := FB_ResetAbsEnc_T.ResetAbsEnc,
		AbsEncPos := FB_ResetAbsEnc_T.AbsEncPos
		);
		FB_ResetAbsEnc_T.AbsEncResetDone := FB_ResetAbsEnc_4.AbsEncResetDone;
		FB_ResetAbsEnc_T.Error := FB_ResetAbsEnc_4.Error;
		FB_ResetAbsEnc_T.ErrorID := FB_ResetAbsEnc_4.ErrorID;
END_IF;

IF numAxes = INT#5 THEN
	(*	As above *)
	(*	Axis_B *)
	FB_ResetAbsEnc_5(
		AxisRef := AxesGroupRef.AxisRef[5],
		ResetAbsEnc := FB_ResetAbsEnc_B.ResetAbsEnc,
		AbsEncPos := FB_ResetAbsEnc_B.AbsEncPos
		);
		FB_ResetAbsEnc_B.AbsEncResetDone := FB_ResetAbsEnc_5.AbsEncResetDone;
		FB_ResetAbsEnc_B.Error := FB_ResetAbsEnc_5.Error;
		FB_ResetAbsEnc_B.ErrorID := FB_ResetAbsEnc_5.ErrorID;
END_IF;
*)

(*	This function block operates and monitors several PLCopen Part 4 group related functions including MC_GroupEnable, 
	MC_GroupDisable, MC_GroupReadError, MC_GroupReset, Y_GroupPower and other functions such as Y_ReadAlarms, Y_ClearAlarm. *)
GroupControl_1(
    AxesGroup           := AxesGroupRef,						// Axes group reference 
    Enable              := GroupControl_Group.Enable,			// Enable the FB to control axes group 
    EnableGroup         := GroupControl_Group.EnableGroup,		// If TRUE, the MC_GroupEnable function block will be executed. If FALSE, the MC_GroupDisable function block will be executed. 
    EnablePower         := GroupControl_Group.EnablePower,		// If TRUE, all the axes belonging to the AxesGroup will be powered. All axes are first checked for alarms, and if any alarms are present, no axes are powered. If FALSE, all of the axes belonging to the group will be powered down 
    AlarmClear          := GroupControl_Group.AlarmClear,		// Executes MC_GroupReset, MC_Reset, and Y_ClearAlarms based on the current alarms related to the AxesGroup. 
    Valid               => GroupControl_Group.Valid,            // Indicates that the function is operating normally and the outputs of the function are valid. 
    Busy                => GroupControl_Group.Busy,             // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. (No Error) ,
    GroupStatus         => GroupControl_Group.GroupStatus,      // Indicates if the group is enabled.
    PowerStatus         => GroupControl_Group.PowerStatus,      // Indicates that all axis in the group are powered. 
    ControllerAlarm     => GroupControl_Group.ControllerAlarm,  // Indicates a controller side axis alarm. 
    ControllerAlarmID   => GroupControl_Group.ControllerAlarmID,// Indicates the controller alarm ID number 
    GroupError          => GroupControl_Group.GroupError,       // Indicates a group alarm. 
    GroupErrorClass     => GroupControl_Group.GroupErrorClass,  // The error class indicates the source of the error. 
    GroupErrorID        => GroupControl_Group.GroupErrorID,     // Indicates the group alarm ID number. 
    GroupErrorSubCode   => GroupControl_Group.GroupErrorSubCode,// If using a remote hosted Robot Controller via MotomanSync, this output reports additional error detail. 
    AxisAlarms          => GroupControl_Group.AxisAlarms,       // Indicates an axis alarm. 
    AxisErrorClass      => GroupControl_Group.AxisErrorClass,   // Indicates the axis alarm class number. 
    AxisErrorID         => GroupControl_Group.AxisErrorID,      // Indicates the axis alarm ID number. 
    AxisWarnings        => GroupControl_Group.AxisWarnings,     // Indicates an axis warning. 
    AxisWarningID       => GroupControl_Group.AxisWarningID,    // Indicates the axis warning ID number. 
    AuxiliaryError      => GroupControl_Group.AuxiliaryError,   // Set high if one of the following Function Blocks used internally generated an error: MC_GroupEnable , MC_GroupDisable , MC_GroupReset , Y_GroupPower , Y_ClearAlarms , MC_Resets .
    AuxiliaryErrorID    => GroupControl_Group.AuxiliaryErrorID, // If AuxiliaryError is TRUE, this output provides the identifier of the error .
    Error               => GroupControl_Group.Error,            // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low.,
    ErrorID             => GroupControl_Group.ErrorID           // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low.
	);
//fbErrorHandler.AddUpdateError(GroupControl_Group.Error, GroupControl_Group.ErrorID, 'GroupControl_1', fbErrorHandler.GetErrorMessage(GroupControl_Group.ErrorID), E_ErrorSeverity#MajorError);	
//fbErrorHandler.AddUpdateError(GroupControl_Group.AxisAlarms, GroupControl_Group.AxisErrorID, 'GroupControl_1', fbErrorHandler.GetErrorMessage(GroupControl_Group.AxisErrorID), E_ErrorSeverity#MajorError);	
//fbErrorHandler.AddUpdateError(GroupControl_Group.AxisWarnings, GroupControl_Group.AxisWarningID, 'GroupControl_1', fbErrorHandler.GetErrorMessage(GroupControl_Group.AxisWarningID), E_ErrorSeverity#MinorError);	
//fbErrorHandler.AddUpdateError(GroupControl_Group.AuxiliaryError, GroupControl_Group.AuxiliaryErrorID, 'GroupControl_1', fbErrorHandler.GetErrorMessage(GroupControl_Group.AuxiliaryErrorID), E_ErrorSeverity#MinorError);	

(* This Function Block returns the status of an AxesGroup. *)
MC_GroupReadStatus1(
    AxesGroup := AxesGroupRef, 
    Enable := GroupControl_Group.EnableGroup, 
    Valid => GroupReadStatus_Group.Valid, 
    Busy => GroupReadStatus_Group.Busy, 
    GroupMoving => GroupReadStatus_Group.GroupMoving, 
    GroupHoming => GroupReadStatus_Group.GroupHoming, 
    GroupErrorStop => GroupReadStatus_Group.GroupErrorStop, 
    GroupStandby => GroupReadStatus_Group.GroupStandby, 
    GroupStopping => GroupReadStatus_Group.GroupStopping, 
    GroupDisabled => GroupReadStatus_Group.GroupDisabled, 
    ConstantVelocity => GroupReadStatus_Group.ConstantVelocity, 
    Accelerating => GroupReadStatus_Group.Accelerating, 
    Decelerating => GroupReadStatus_Group.Decelerating, 
    InPosition => GroupReadStatus_Group.InPosition, 
    StandStill => GroupReadStatus_Group.StandStill, 
    Interrupted => GroupReadStatus_Group.Interrupted, 
    SynchronizedMotion => GroupReadStatus_Group.SynchronizedMotion, 
    DiscreteMotion => GroupReadStatus_Group.DiscreteMotion, 
    ContinuousMotion => GroupReadStatus_Group.ContinuousMotion, 
    Error => GroupReadStatus_Group.Error, 
    ErrorID => GroupReadStatus_Group.ErrorID
    );
//fbErrorHandler.AddUpdateError(GroupReadStatus_Group.Error, GroupReadStatus_Group.ErrorID, 'MC_GroupReadStatus1', fbErrorHandler.GetErrorMessage(GroupReadStatus_Group.ErrorID), E_ErrorSeverity#MajorError);	

(* This Function Block commands a controlled motion stop and transfers the AxesGroup to the "GroupStopping" state. *)
MC_GroupStop_1(
    AxesGroup       := AxesGroupRef,                    // Axes group reference 
    Execute         := GroupStop_Group.Execute,         // Command to performe a MC_GroupStop
    Deceleration    := GroupStop_Group.Deceleration,    // Deceleration value related to MC_GroupStop 
    // Jerk,
    Done            => GroupStop_Group.Done,            // Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low
    Busy            => GroupStop_Group.Busy,            // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. (No Error)
    CommandAborted  => GroupStop_Group.CommandAborted,  // Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output
    Error           => GroupStop_Group.Error,           // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low
    ErrorID         => GroupStop_Group.ErrorID          // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low
	);
//fbErrorHandler.AddUpdateError(GroupStop_Group.Error, GroupStop_Group.ErrorID, 'MC_GroupStop_1', fbErrorHandler.GetErrorMessage(GroupStop_Group.ErrorID), E_ErrorSeverity#MajorError);		

(*	This Function Block allows the application program to operate the a motor's built in mechanical brake from the IEC application program. 
	Normally the ServoPack operates the brake based on operating conditions, 
	but this function can be used in manual or emergency situations to override the automatic operation. 
	Use caution! Damage to the mechanical brake will occur if it is engaged while the motor is rotating. *)
(*	Axis_S *)
(*
Y_GroupBrakeRelease_1(
	AxesGroup := AxesGroupRef,											(*	Axes group reference *)
	Execute := GroupBrakeRelease_Axis_S.Execute,						(*	Upon the rising edge, all other function block inputs are read and the function is initiated. To modify an input, change the value and re-trigger the execute input.  *)
	JointIndex := UINT#1,												(*	Joint index releated to Axis_S *)
	State := GroupBrakeRelease_Axis_S.State								(*	FALSE=Brake Applied, TRUE=Brake Released. *)
	);
	GroupBrakeRelease_Axis_S.Done := Y_GroupBrakeRelease_1.Done;		(*	Set high when the commanded action has completed successfully.If another block takes control before the action is completed, the Done output will not be set.This output is reset when Execute goes low. *)
	GroupBrakeRelease_Axis_S.Busy := Y_GroupBrakeRelease_1.Busy;		(*	Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. *)
	GroupBrakeRelease_Axis_S.Error := Y_GroupBrakeRelease_1.Error;		(*	Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. *)
	GroupBrakeRelease_Axis_S.ErrorID := Y_GroupBrakeRelease_1.ErrorID;	(*	If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. *)
*)

(*	As above *)
(*	Axis_L *)
(*
Y_GroupBrakeRelease_2(
	AxesGroup := AxesGroupRef,
	Execute := GroupBrakeRelease_Axis_L.Execute,
	JointIndex := UINT#2,
	State := GroupBrakeRelease_Axis_L.State
	);
	GroupBrakeRelease_Axis_L.Done := Y_GroupBrakeRelease_2.Done;
	GroupBrakeRelease_Axis_L.Busy := Y_GroupBrakeRelease_2.Busy;
	GroupBrakeRelease_Axis_L.Error := Y_GroupBrakeRelease_2.Error;
	GroupBrakeRelease_Axis_L.ErrorID := Y_GroupBrakeRelease_2.ErrorID;
*)

(*	As above *)
(*	Axis_U *)
(*
Y_GroupBrakeRelease_3(
	AxesGroup := AxesGroupRef,
	Execute := GroupBrakeRelease_Axis_U.Execute,
	JointIndex := UINT#3,
	State := GroupBrakeRelease_Axis_U.State
	);
	GroupBrakeRelease_Axis_U.Done := Y_GroupBrakeRelease_3.Done;
	GroupBrakeRelease_Axis_U.Busy := Y_GroupBrakeRelease_3.Busy;
	GroupBrakeRelease_Axis_U.Error := Y_GroupBrakeRelease_3.Error;
	GroupBrakeRelease_Axis_U.ErrorID := Y_GroupBrakeRelease_3.ErrorID;
*)

(*	As above *)
(*	Axis_T *)
(*
Y_GroupBrakeRelease_4(
	AxesGroup := AxesGroupRef,
	Execute := GroupBrakeRelease_Axis_T.Execute,
	JointIndex := UINT#4,
	State := GroupBrakeRelease_Axis_T.State
	);
	GroupBrakeRelease_Axis_T.Done := Y_GroupBrakeRelease_4.Done;
	GroupBrakeRelease_Axis_T.Busy := Y_GroupBrakeRelease_4.Busy;
	GroupBrakeRelease_Axis_T.Error := Y_GroupBrakeRelease_4.Error;
	GroupBrakeRelease_Axis_T.ErrorID := Y_GroupBrakeRelease_4.ErrorID;
*)

(*	As above *)
(*	Axis_B *)
(*
Y_GroupBrakeRelease_5(
	AxesGroup := AxesGroupRef,
	Execute := GroupBrakeRelease_Axis_B.Execute,
	JointIndex := UINT#5,
	State := GroupBrakeRelease_Axis_B.State
	);
	GroupBrakeRelease_Axis_B.Done := Y_GroupBrakeRelease_5.Done;
	GroupBrakeRelease_Axis_B.Busy := Y_GroupBrakeRelease_5.Busy;
	GroupBrakeRelease_Axis_B.Error := Y_GroupBrakeRelease_5.Error;
	GroupBrakeRelease_Axis_B.ErrorID := Y_GroupBrakeRelease_5.ErrorID;
*)

(*	This Function Block commands an interpolated linear movement on an AxesGroup to an absolute position in the specified coordinate system. *)
MC_MoveLinearAbsolute_1(
	AxesGroup              := AxesGroupRef,                                    // Axes group reference
	Execute                := MoveLinearAbsolute_Group.Execute,                // Upon the rising edge, all other function block inputs are read and the function is initiated. To modify an input, change the value and re-trigger the execute input.
	Position               := MoveLinearAbsolute_Group.Position,               // An array of values. The specific meaning of each value depends upon the Coordinate System specified and the mechanism, and the context.
	Velocity               := MoveLinearAbsolute_Group.Velocity,               // Absolute value of the velocity in user units/second. For remote hosted robots such as MLX200, the velocity can be programmed in mm/sec or in percentage of maximum. 
	Acceleration           := MoveLinearAbsolute_Group.Acceleration,           // Value of the acceleration in user units/second^2 (acceleration is applicable with same sign of torque and velocity)For remote hosted robots such as MLX200, acceleration can be programmed in mm/sec2 or in percentage of maximum. 
	Deceleration           := MoveLinearAbsolute_Group.Deceleration,           // Value of the deceleration in user units/second^2 (deceleration is applicable with opposite signs of torque and velocity.)For remote hosted robots such as MLX200,deceleration can be programmed in mm/sec2 or in percentage of maximum. 
	// Jerk,                                                                   // Not supported; reserved for future use.  Value of the jerk in [user units / second^3]. 
	MoveOptions            := MoveLinearAbsolute_Group.MoveOptions,            // Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. 
	CoordSystem            := MoveLinearAbsolute_Group.CoordSystem,            // Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS. 
	BufferMode             := MoveLinearAbsolute_Group.BufferMode,             // Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. 
	TransitionMode         := MoveLinearAbsolute_Group.TransitionMode,         // Specifies how segments are blended together when multiple MC_MoveLinear and MC_MoveCircular function blocks are buffered. 
	TransitionParameter    := MoveLinearAbsolute_Group.TransitionParameter,    // Additional parameters for the selected TransitionMode. 
	Done                   => MoveLinearAbsolute_Group.Done,                   // Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low. 
	Busy                   => MoveLinearAbsolute_Group.Busy,                   // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. 
	Active                 => MoveLinearAbsolute_Group.Active,                 // For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. 
	CommandAborted         => MoveLinearAbsolute_Group.CommandAborted,         // Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. 
	Error                  => MoveLinearAbsolute_Group.Error,                  // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. 
	ErrorID                => MoveLinearAbsolute_Group.ErrorID                 // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. 
	);
//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Group.Error, MoveLinearAbsolute_Group.ErrorID, 'MC_MoveLinearAbsolute_1', fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Group.ErrorID), E_ErrorSeverity#MajorError);		

(*	As above, but used in RTN_TestBlend to do a blend test  *)
MC_MoveLinearAbsolute_Blend1(
    AxesGroup               := AxesGroupRef,
    Execute                 := MoveLinearAbsolute_Blend1.Execute,
    Position                := MoveLinearAbsolute_Blend1.Position,
    Velocity                := MoveLinearAbsolute_Blend1.Velocity,
    Acceleration            := MoveLinearAbsolute_Blend1.Acceleration,
    Deceleration            := MoveLinearAbsolute_Blend1.Deceleration,
    // Jerk,
    MoveOptions             := MoveLinearAbsolute_Blend1.MoveOptions,
    CoordSystem             := MoveLinearAbsolute_Blend1.CoordSystem,
    BufferMode              := MoveLinearAbsolute_Blend1.BufferMode,
    TransitionMode          := MoveLinearAbsolute_Blend1.TransitionMode,
    TransitionParameter     := MoveLinearAbsolute_Blend1.TransitionParameter,
    Done                    => MoveLinearAbsolute_Blend1.Done,
    Busy                    => MoveLinearAbsolute_Blend1.Busy,
    Active                  => MoveLinearAbsolute_Blend1.Active,
    CommandAborted          => MoveLinearAbsolute_Blend1.CommandAborted,
    Error                   => MoveLinearAbsolute_Blend1.Error,
    ErrorID                 => MoveLinearAbsolute_Blend1.ErrorID
	);
//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend1.Error, MoveLinearAbsolute_Blend1.ErrorID, 'MC_MoveLinearAbsolute_Blend1', fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend1.ErrorID), E_ErrorSeverity#MajorError);	

(*	As above *)
MC_MoveLinearAbsolute_Blend2(
    AxesGroup               := AxesGroupRef,
    Execute                 := MoveLinearAbsolute_Blend2.Execute,
    Position                := MoveLinearAbsolute_Blend2.Position,
    Velocity                := MoveLinearAbsolute_Blend2.Velocity,
    Acceleration            := MoveLinearAbsolute_Blend2.Acceleration,
    Deceleration            := MoveLinearAbsolute_Blend2.Deceleration,
    // Jerk,
    MoveOptions             := MoveLinearAbsolute_Blend2.MoveOptions,
    CoordSystem             := MoveLinearAbsolute_Blend2.CoordSystem,
    BufferMode              := MoveLinearAbsolute_Blend2.BufferMode,
    TransitionMode          := MoveLinearAbsolute_Blend2.TransitionMode,
    TransitionParameter     := MoveLinearAbsolute_Blend2.TransitionParameter,
    Done                    => MoveLinearAbsolute_Blend2.Done,
    Busy                    => MoveLinearAbsolute_Blend2.Busy,
    Active                  => MoveLinearAbsolute_Blend2.Active,
    CommandAborted          => MoveLinearAbsolute_Blend2.CommandAborted,
    Error                   => MoveLinearAbsolute_Blend2.Error,
    ErrorID                 => MoveLinearAbsolute_Blend2.ErrorID
	);
//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend2.Error, MoveLinearAbsolute_Blend2.ErrorID, 'MC_MoveLinearAbsolute_Blend2', fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend2.ErrorID), E_ErrorSeverity#MajorError);	

(*	As above *)
MC_MoveLinearAbsolute_Blend3(
    AxesGroup               := AxesGroupRef,
    Execute                 := MoveLinearAbsolute_Blend3.Execute,
    Position                := MoveLinearAbsolute_Blend3.Position,
    Velocity                := MoveLinearAbsolute_Blend3.Velocity,
    Acceleration            := MoveLinearAbsolute_Blend3.Acceleration,
    Deceleration            := MoveLinearAbsolute_Blend3.Deceleration,
    // Jerk,
    MoveOptions             := MoveLinearAbsolute_Blend3.MoveOptions,
    CoordSystem             := MoveLinearAbsolute_Blend3.CoordSystem,
    BufferMode              := MoveLinearAbsolute_Blend3.BufferMode,
    TransitionMode          := MoveLinearAbsolute_Blend3.TransitionMode,
    TransitionParameter     := MoveLinearAbsolute_Blend3.TransitionParameter,
    Done                    => MoveLinearAbsolute_Blend3.Done,
    Busy                    => MoveLinearAbsolute_Blend3.Busy,
    Active                  => MoveLinearAbsolute_Blend3.Active,
    CommandAborted          => MoveLinearAbsolute_Blend3.CommandAborted,
    Error                   => MoveLinearAbsolute_Blend3.Error,
    ErrorID                 => MoveLinearAbsolute_Blend3.ErrorID
	);
//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend3.Error, MoveLinearAbsolute_Blend3.ErrorID, 'MC_MoveLinearAbsolute_Blend3', fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend3.ErrorID), E_ErrorSeverity#MajorError);	

(*	This function block reads the information in the PathData struct and performs the required actions such as interpolated motion, waiting for inputs, setting outputs, etc. *)
(*
MC_MovePath_1(
    AxesGroup           := AxesGroupRef, 
    MachineData         := MovePath_Group.MachineData, 
    PathData            := MovePath_Group.PathData, 
    VarData             := MovePath_Group.VarData, 
    Execute             := MovePath_Group.Execute, 
    OperationMode       := MovePath_Group.OperationMode, 
    SingleStep          := MovePath_Group.SingleStep, 
    VelocityScaler      := MovePath_Group.VelocityScaler, 
    StartSegment        := MovePath_Group.StartSegment, 
    InputFlags          := MovePath_Group.InputFlags, 
    Abort               := MovePath_Group.Abort, 
    Pause               := MovePath_Group.Pause, 
    Done                => MovePath_Group.Done, 
    Busy                => MovePath_Group.Busy, 
    CommandAborted      => MovePath_Group.CommandAborted, 
    Error               => MovePath_Group.Error, 
    ErrorID             => MovePath_Group.ErrorID, 
    InputFlagsRequired  => MovePath_Group.InputFlagsRequired, 
    OutputFlags         => MovePath_Group.OutputFlags, 
    ProcessedLabel      => MovePath_Group.ProcessedLabel, 
    ExecutedLabel       => MovePath_Group.ExecutedLabel, 
    ProcessedTotal      => MovePath_Group.ProcessedTotal, 
    ExecutedTotal       => MovePath_Group.ExecutedTotal
    );
//fbErrorHandler.AddUpdateError(MovePath_Group.Error, MovePath_Group.ErrorID, 'MC_MovePath_1', fbErrorHandler.GetErrorMessage(MovePath_Group.ErrorID), E_ErrorSeverity#MajorError);	
*)

(*	This Function Block commands an interpolated linear movement on an AxesGroup from the commanded position of the group 
	at the time this function block initiates motion to a relative position in the specified coordinate system. *)
MC_MoveLinearRelative_1(
    AxesGroup           := AxesGroupRef,                                // Axes group reference 
    Execute             := MoveLinearRelative_Group.Execute,            // Upon the rising edge, all other function block inputs are read and the function is initiated. To modify an input, change the value and re-trigger the execute input. 
    Distance            := MoveLinearRelative_Group.Distance,           // An array of values. The specific meaning of each value depends upon the Coordinate System specified and the mechanism, and the context. 
    Velocity            := MoveLinearRelative_Group.Velocity,           // Absolute value of the velocity in user units/second. 
    Acceleration        := MoveLinearRelative_Group.Acceleration,       // Value of the acceleration in user units/second^2 (acceleration is applicable with same sign of torque and velocity) 
    Deceleration        := MoveLinearRelative_Group.Deceleration,       // Value of the deceleration in user units/second^2 (deceleration is applicable with opposite signs of torque and velocity) 
    Jerk                := MoveLinearRelative_Group.Jerk,               // Not supported; reserved for future use.  Value of the jerk in [user units / second^3]. 
    MoveOptions         := MoveLinearRelative_Group.MoveOptions,        // Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. 
    CoordSystem         := MoveLinearRelative_Group.CoordSystem,        // Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS. 
    BufferMode          := MoveLinearRelative_Group.BufferMode,         // Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. 
    TransitionMode      := MoveLinearRelative_Group.TransitionMode,     // Specifies how segments are blended together when multiple MC_MoveLinear and MC_MoveCircular function blocks are buffered. 
    TransitionParameter := MoveLinearRelative_Group.TransitionParameter,// Additional parameters for the selected TransitionMode. 
    Done                => MoveLinearRelative_Group.Done,               // Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low. 
    Busy                => MoveLinearRelative_Group.Busy,               // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. 
    Active              => MoveLinearRelative_Group.Active,             // For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. 
    CommandAborted      => MoveLinearRelative_Group.CommandAborted,     // Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. 
    Error               => MoveLinearRelative_Group.Error,              // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. 
    ErrorID             => MoveLinearRelative_Group.ErrorID             // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. 
	);
//fbErrorHandler.AddUpdateError(MoveLinearRelative_Group.Error, MoveLinearRelative_Group.ErrorID, 'MC_MoveLinearRelative_1', fbErrorHandler.GetErrorMessage(MoveLinearRelative_Group.ErrorID), E_ErrorSeverity#MajorError);		

(*	This function block jogs a Group's Joint in the Axis Coordinate System (ACS). *)
Y_GroupJogJoint_1(
    AxesGroup       := AxesGroupRef,                        // Axes group reference 
    Enable          := GroupJogJoint_Group.Enable,          // The function will continue to execute every scan while Enable is held high and there are no errors. 
    JointIndex      := GroupJogJoint_Group.JointIndex,      // Refer to the Hardware Configuration's group definition chart which shows the Index for each of the axes in the group. 
    Velocity        := GroupJogJoint_Group.Velocity,        // Velocity in degrees/sec. 
    Acceleration    := GroupJogJoint_Group.Acceleration,    // Acceleration in degrees/sec. 
    Deceleration    := GroupJogJoint_Group.Deceleration,    // Deceleration in degrees/sec. 
    Jerk            := GroupJogJoint_Group.Jerk,            // Not supported; reserved for future use. Value of the jerk in [user units / second^3]. 
    MoveOptions     := GroupJogJoint_Group.MoveOptions,     // Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. 
    Direction       := GroupJogJoint_Group.Direction,       // Specifies the direction of motion. Allowable modes are positive_direction, shortest_way, negative_direction, current_direction. 
    BufferMode      := GroupJogJoint_Group.BufferMode,      // Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. 
    InVelocity      => GroupJogJoint_Group.InVelocity,      //
    Valid           => GroupJogJoint_Group.Valid,           // Indicates that the function is operating normally and the outputs of the function are valid. 
    Busy            => GroupJogJoint_Group.Busy,            // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. 
    Active          => GroupJogJoint_Group.Active,          // For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. 
    CommandAborted  => GroupJogJoint_Group.CommandAborted,  // Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. 
    Error           => GroupJogJoint_Group.Error,           // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. 
    ErrorID         => GroupJogJoint_Group.ErrorID          // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. 
	);
//fbErrorHandler.AddUpdateError(GroupJogJoint_Group.Error, GroupJogJoint_Group.ErrorID, 'Y_GroupJogJoint_1', fbErrorHandler.GetErrorMessage(GroupJogJoint_Group.ErrorID), E_ErrorSeverity#MajorError);		
	
(*	This function block will jog a group toward a specified n dimensional Position in the specified CoordSystem. 
	If used with a Mechatrolink group, the TCP will move at the Velocity, Acceleration, Deceleration and Jerk specified by the function block inputs. 
	If used with an MLX robot group, the TCP will use acceleration, deceleration and jerk values which are preset in the MLX for the configured robot. 
	The Position provided will guide the vector of the TCP, but is not necessarily a final target. 
	When the Enable input goes low, the group will stop jogging. *)
Y_GroupJogLinear_1(
	AxesGroup      := AxesGroupRef,                        // Axes group reference 
	Enable         := GroupJogLinear_Group.Enable,         // The function will continue to execute every scan while Enable is held high and there are no errors. 
	Position       := GroupJogLinear_Group.Position,       // An array of absolute positions for each dimension in the specified coordinate system. 
	Velocity       := GroupJogLinear_Group.Velocity,       // Absolute value of the velocity in user units/second. 
	Acceleration   := GroupJogLinear_Group.Acceleration,   // Value of the acceleration in user units/second^2 (acceleration is applicable with same sign of torque and velocity) 
	Deceleration   := GroupJogLinear_Group.Deceleration,   // Value of the deceleration in user units/second^2 (deceleration is applicable with opposite signs of torque and velocity) 
	Jerk           := GroupJogLinear_Group.Jerk,           // Not supported; reserved for future use. Value of the jerk in [user units / second^3]. 
	MoveOptions    := GroupJogLinear_Group.MoveOptions,    // Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. 
	CoordSystem    := GroupJogLinear_Group.CoordSystem,    // Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS. 
	BufferMode     := GroupJogLinear_Group.BufferMode,     // Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. 
	Valid          => GroupJogLinear_Group.Valid,          // Indicates that the function is operating normally and the outputs of the function are valid. 
	Done           => GroupJogLinear_Group.Done,           // Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low. 
	Busy           => GroupJogLinear_Group.Busy,           // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. 
	Active         => GroupJogLinear_Group.Active,         // For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. 
	CommandAborted => GroupJogLinear_Group.CommandAborted, // Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. 
	Error          => GroupJogLinear_Group.Error,          // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. 
	ErrorID        => GroupJogLinear_Group.ErrorID         // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. 
	);
//fbErrorHandler.AddUpdateError(GroupJogLinear_Group.Error, GroupJogLinear_Group.ErrorID, 'Y_GroupJogLinear_1', fbErrorHandler.GetErrorMessage(GroupJogLinear_Group.ErrorID), E_ErrorSeverity#MajorError);		

MC_SetPosition1(
    Axis := S_Axis, 
    Execute := SetPosition_S.Execute, 
    Position := SetPosition_S.Position, 
    Mode := SetPosition_S.Mode, 
    Done => SetPosition_S.Done, 
    Busy => SetPosition_S.Busy, 
    Error => SetPosition_S.Error, 
    ErrorID => SetPosition_S.ErrorID
    );
    
MC_SetPosition2(
    Axis := L_Axis, 
    Execute := SetPosition_L.Execute, 
    Position := SetPosition_L.Position, 
    Mode := SetPosition_L.Mode, 
    Done => SetPosition_L.Done, 
    Busy => SetPosition_L.Busy, 
    Error => SetPosition_L.Error, 
    ErrorID => SetPosition_L.ErrorID
    );
    
MC_SetPosition3(
    Axis := U_Axis, 
    Execute := SetPosition_U.Execute, 
    Position := SetPosition_U.Position, 
    Mode := SetPosition_U.Mode, 
    Done => SetPosition_U.Done, 
    Busy => SetPosition_U.Busy, 
    Error => SetPosition_U.Error, 
    ErrorID => SetPosition_U.ErrorID
    );

MC_SetPosition4(
    Axis := T_Axis, 
    Execute := SetPosition_T.Execute, 
    Position := SetPosition_T.Position, 
    Mode := SetPosition_T.Mode, 
    Done => SetPosition_T.Done, 
    Busy => SetPosition_T.Busy, 
    Error => SetPosition_T.Error, 
    ErrorID => SetPosition_T.ErrorID
    );

MC_SetPosition5(
    Axis := B_Axis, 
    Execute := SetPosition_B.Execute, 
    Position := SetPosition_B.Position, 
    Mode := SetPosition_B.Mode, 
    Done => SetPosition_B.Done, 
    Busy => SetPosition_B.Busy, 
    Error => SetPosition_B.Error, 
    ErrorID => SetPosition_B.ErrorID
    );
    
(* This Function Block sets the position of all axes in a group without moving the axes. MC_GroupSetPosition is a maintenance mode operation only to be used when commissioning a robot group, or after maintenance operations. Only the Axes Coordinate System is supported, but affects the higher level coordinate systems. *)
MC_GroupSetPosition_1(
    AxesGroup := AxesGroupRef, 
    Execute := GroupSetPosition_Group.Execute, 
    Position := GroupSetPosition_Group.Position, 
    Relative := GroupSetPosition_Group.Relative, 
    CoordSystem := GroupSetPosition_Group.CoordSystem, 
    SetMode := GroupSetPosition_Group.SetMode, 
    BufferMode := GroupSetPosition_Group.BufferMode, 
    Done => GroupSetPosition_Group.Done, 
    Busy => GroupSetPosition_Group.Busy, 
    Active => GroupSetPosition_Group.Active, 
    CommandAborted => GroupSetPosition_Group.CommandAborted, 
    Error => GroupSetPosition_Group.Error, 
    ErrorID => GroupSetPosition_Group.ErrorID
    );
//fbErrorHandler.AddUpdateError(GroupSetPosition_Group.Error, GroupSetPosition_Group.ErrorID, 'MC_GroupSetPosition_1', fbErrorHandler.GetErrorMessage(GroupSetPosition_Group.ErrorID), E_ErrorSeverity#MajorError);	    

(*	This function block calculates an output frame by offsetting the input frame. *)
CalcFrameOffset_1(
    InputFrame  := CalcFrameOffset_Group.InputFrame,    // Example = [0 0 0 0 0 90]
    Offset      := CalcFrameOffset_Group.Offset,        // Example = [10 0 0 0 0 0]
    OutputFrame := CalcFrameOffset_Group.OutputFrame,   // Example = [10 0 0 0 0 90]
    Enable      := CalcFrameOffset_Group.Enable,        // Enables the function
    Valid       => CalcFrameOffset_Group.Valid,         // The Valid output indicates that the function block is operating normally and the outputs of the function block are valid
    Error       => CalcFrameOffset_Group.Error,         // The Error output is set to TRUE if an error has occurred during the operation of the function block. The output is cleared when the Execute or Enable input becomes FALSE
    ErrorID     => CalcFrameOffset_Group.ErrorID        // The ErrorID output provides the identifier of the error when there is an active error in the function block execution. The output is cleared when the Execute or Enable input becomes FALSE
	);
//fbErrorHandler.AddUpdateError(CalcFrameOffset_Group.Error, CalcFrameOffset_Group.ErrorID, 'CalcFrameOffset_1', fbErrorHandler.GetErrorMessage(CalcFrameOffset_Group.ErrorID), E_ErrorSeverity#MajorError);		

(*	Function block to convert three points  OO, XX, XY  representing an origin (OO), a point in the +X direction (XX),  and a point in the XY plane perpendicular to the X axis from XX (XY) to a cartesian frame in X, Y, Z, Rx, Ry, Rz *)
FrameTypeTransform_1(
    FrameCoordinates:= FrameTypeTransform_Group.FrameCoordinates,   // Cartesian coordinates of the frame defined by OO, XX and XY
    Execute         := FrameTypeTransform_Group.Execute,            // Upon the rising edge of the Execute input, all other inputs are read and the function block becomes operational. If an input needs to be modified, the value will have to be changed and the Execute input will have to be re-triggered
    OO              := FrameTypeTransform_Group.OO,                 // Origin
    XX              := FrameTypeTransform_Group.XX,                 // Point along the positive X axis
    XY              := FrameTypeTransform_Group.XY,                 // Point along a line perpendicular to the X axis in the positive Y direction
    Done            => FrameTypeTransform_Group.Done,               // The Done output is set to TRUE when the commanded action has completed successfully. If another function block takes control before the action is completed, the Done output will never become TRUE. This output is reset when Execute becomes FALSE
    Singularity     => FrameTypeTransform_Group.Singularity,        // TRUE when calculating Euler angles where Ry = +/- pi/2
    Error           => FrameTypeTransform_Group.Error,              // The Error output is set to TRUE if an error has occurred during the operation of the function block. The output is cleared when the Execute or Enable input becomes FALSE
    ErrorID         => FrameTypeTransform_Group.ErrorID             // The ErrorID output provides the identifier of the error when there is an active error in the function block execution. The output is cleared when the Execute or Enable input becomes FALSE
    );
//fbErrorHandler.AddUpdateError(FrameTypeTransform_Group.Error, FrameTypeTransform_Group.ErrorID, 'FrameTypeTransform_1', fbErrorHandler.GetErrorMessage(FrameTypeTransform_Group.ErrorID), E_ErrorSeverity#MajorError);	    

(*	This Function Block sets an offset between the Coordinate Systems MCS and WCS, MCS and PCS, or WCS and PCS. The resulting offset can be verified by referencing AxesGroup.Machine.Offset or AxesGroup.Part.Offset. *)
Y_GroupSetFrameOffset_1(
    AxesGroup       := AxesGroupRef,                                // Axes group reference
    Execute         := GroupSetFrameOffset_Group.Execute,           // Upon the rising edge, all other function block inputs are read and the function is initiated. To modify an input, change the value and re-trigger the execute input
    Offset          := GroupSetFrameOffset_Group.Offset,            // A set of 6 values which specify an orientation as X, Y, Z, Rx, Ry, Rz
    ExecutionMode   := GroupSetFrameOffset_Group.ExecutionMode,     // Enumeration with the following values: MC_ExecutionMode#Immediately MC_ExecutionMode#Delayed MC_ExecutionMode#Queued - Only Immediately is supported.
    RefCoordSystem  := GroupSetFrameOffset_Group.RefCoordSystem,    // Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS.
    SetCoordSystem  := GroupSetFrameOffset_Group.SetCoordSystem,    // Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS.
    Done            => GroupSetFrameOffset_Group.Done,              // Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low
    Busy            => GroupSetFrameOffset_Group.Busy,              // Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. (No Error)
    Error           => GroupSetFrameOffset_Group.Error,             // Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low
    ErrorID         => GroupSetFrameOffset_Group.ErrorID            // If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low
	);
//fbErrorHandler.AddUpdateError(GroupSetFrameOffset_Group.Error, GroupSetFrameOffset_Group.ErrorID, 'Y_GroupSetFrameOffset_1', fbErrorHandler.GetErrorMessage(GroupSetFrameOffset_Group.ErrorID), E_ErrorSeverity#MajorError);		

(*	This function block allows an AxesGroup to track objects moving in a straight line in space by activating a dynamic calculation of the PCS 
	such that the positive X direction of the Part Coordinate System (PCS) is updated as the ConveyorBelt axis moves. *)
MC_TrackConveyorBelt_1(
	AxesGroup := AxesGroupRef,
	ConveyorBelt := TrackConveyorBelt_Group.ConveyorBelt,
	Execute := TrackConveyorBelt_Group.Execute,
	ConveyorBeltOrigin := TrackConveyorBelt_Group.ConveyorBeltOrigin,
	InitialObjectPosition := TrackConveyorBelt_Group.InitialObjectPosition,
	RecordedPosition := TrackConveyorBelt_Group.RecordedPosition,
	StartDistance := TrackConveyorBelt_Group.StartDistance,
	EndDistance := TrackConveyorBelt_Group.EndDistance,
	TrackOptions := TrackConveyorBelt_Group.TrackOptions,
	ExecutionMode := TrackConveyorBelt_Group.ExecutionMode
	);
	TrackConveyorBelt_Group.Done := MC_TrackConveyorBelt_1.Done;
	TrackConveyorBelt_Group.Busy := MC_TrackConveyorBelt_1.Busy;
	TrackConveyorBelt_Group.Active := MC_TrackConveyorBelt_1.Active;
	TrackConveyorBelt_Group.InSync := MC_TrackConveyorBelt_1.InSync;
	TrackConveyorBelt_Group.CommandAborted := MC_TrackConveyorBelt_1.CommandAborted;
	TrackConveyorBelt_Group.Error := MC_TrackConveyorBelt_1.Error;
	TrackConveyorBelt_Group.ErrorID := MC_TrackConveyorBelt_1.ErrorID;
//fbErrorHandler.AddUpdateError(TrackConveyorBelt_Group.Error, TrackConveyorBelt_Group.ErrorID, 'Y_GroupSetFrameOffset_1', fbErrorHandler.GetErrorMessage(TrackConveyorBelt_Group.ErrorID), E_ErrorSeverity#MajorError);		

Y_GroupReadParameter_1(
	AxesGroup := AxesGroupRef,
	Enable := TRUE,
	ParameterNumber := UINT#2251
	);
	// BOOL  := Y_GroupReadParameter_1.Valid;
	// BOOL  := Y_GroupReadParameter_1.Busy;
	// BOOL  := Y_GroupReadParameter_1.Error;
	// UINT  := Y_GroupReadParameter_1.ErrorID;
	TrackState := Y_GroupReadParameter_1.Value;
//fbErrorHandler.AddUpdateError(Y_GroupReadParameter_1.Error, Y_GroupReadParameter_1.ErrorID, 'Y_GroupSetFrameOffset_1', fbErrorHandler.GetErrorMessage(Y_GroupReadParameter_1.ErrorID), E_ErrorSeverity#MajorError);		
