(*	This Function Block commands an interpolated linear movement on an AxesGroup to an absolute position in the specified coordinate system. *)
MC_MoveLinearAbsolute_1(
	AxesGroup := GroupRef,                									(*	Axes group reference *)
	Execute := MoveLinearAbsolute_Group.Execute,						(*	Upon the rising edge, all other function block inputs are read and the function is initiated. To modify an input, change the value and re-trigger the execute input. *)
	Position := MoveLinearAbsolute_Group.Position,						(*	An array of values. The specific meaning of each value depends upon the Coordinate System specified and the mechanism, and the context. *)
	Velocity := MoveLinearAbsolute_Group.Velocity,						(*	Absolute value of the velocity in user units/second. For remote hosted robots such as MLX200, the velocity can be programmed in mm/sec or in percentage of maximum. *)
	Acceleration := MoveLinearAbsolute_Group.Acceleration,				(*	Value of the acceleration in user units/second^2 (acceleration is applicable with same sign of torque and velocity)For remote hosted robots such as MLX200, acceleration can be programmed in mm/sec2 or in percentage of maximum. *)
	Deceleration := MoveLinearAbsolute_Group.Deceleration,				(*	Value of the deceleration in user units/second^2 (deceleration is applicable with opposite signs of torque and velocity.)For remote hosted robots such as MLX200,deceleration can be programmed in mm/sec2 or in percentage of maximum. *)
	// Jerk,								                            (*	Not supported; reserved for future use.  Value of the jerk in [user units / second^3]. *)
	MoveOptions := MoveLinearAbsolute_Group.MoveOptions,				(*	Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. *)
	CoordSystem := MoveLinearAbsolute_Group.CoordSystem,				(*	Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS. *)
	BufferMode := MoveLinearAbsolute_Group.BufferMode,					(*	Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. *)
	TransitionMode := MoveLinearAbsolute_Group.TransitionMode,			(*	Specifies how segments are blended together when multiple MC_MoveLinear and MC_MoveCircular function blocks are buffered. *)
	TransitionParameter := MoveLinearAbsolute_Group.TransitionParameter,(*	Additional parameters for the selected TransitionMode. *)
	Done => MoveLinearAbsolute_Group.Done,                              (*	Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low. *)
	Busy => MoveLinearAbsolute_Group.Busy,                              (*	Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. *)
	Active => MoveLinearAbsolute_Group.Active,                          (*	For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. *)
	CommandAborted => MoveLinearAbsolute_Group.CommandAborted,          (*	Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. *)
	Error => MoveLinearAbsolute_Group.Error,                            (*	Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. *)
	ErrorID => MoveLinearAbsolute_Group.ErrorID                         (*	If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. *)
	);
	//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Group.Error, MoveLinearAbsolute_Group.ErrorID,'MC_MoveLinearAbsolute_1',fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Group.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinAbs1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearAbsolute_Group.Error, 
        bMoveLinAbs1_OldErr, 
        MoveLinearAbsolute_Group.ErrorID, 
        'MC_MoveLinearAbsolute_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	As above, but used in RTN_TestBlend to do a blend test  *)
MC_MoveLinearAbsolute_Blend1(
    AxesGroup := GroupRef,
	Execute := MoveLinearAbsolute_Blend1.Execute,
	Position := MoveLinearAbsolute_Blend1.Position,
	Velocity := MoveLinearAbsolute_Blend1.Velocity,
	Acceleration := MoveLinearAbsolute_Blend1.Acceleration,
	Deceleration := MoveLinearAbsolute_Blend1.Deceleration,
	// Jerk,
	MoveOptions := MoveLinearAbsolute_Blend1.MoveOptions,
	CoordSystem := MoveLinearAbsolute_Blend1.CoordSystem,
	BufferMode := MoveLinearAbsolute_Blend1.BufferMode,
	TransitionMode := MoveLinearAbsolute_Blend1.TransitionMode,
	TransitionParameter := MoveLinearAbsolute_Blend1.TransitionParameter,
	Done => MoveLinearAbsolute_Blend1.Done,
    Busy => MoveLinearAbsolute_Blend1.Busy,
    Active => MoveLinearAbsolute_Blend1.Active,
    CommandAborted => MoveLinearAbsolute_Blend1.CommandAborted,
    Error => MoveLinearAbsolute_Blend1.Error,
    ErrorID => MoveLinearAbsolute_Blend1.ErrorID
	);
    //fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend1.Error, MoveLinearAbsolute_Blend1.ErrorID,'MC_MoveLinearAbsolute_Blend1',fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend1.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinAbsBlend1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearAbsolute_Blend1.Error, 
        bMoveLinAbsBlend1_OldErr, 
        MoveLinearAbsolute_Blend1.ErrorID, 
        'MC_MoveLinearAbsolute_Blend1', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	As above *)
MC_MoveLinearAbsolute_Blend2(
    AxesGroup := GroupRef,
	Execute := MoveLinearAbsolute_Blend2.Execute,
	Position := MoveLinearAbsolute_Blend2.Position,
	Velocity := MoveLinearAbsolute_Blend2.Velocity,
	Acceleration := MoveLinearAbsolute_Blend2.Acceleration,
	Deceleration := MoveLinearAbsolute_Blend2.Deceleration,
	// Jerk,
	MoveOptions := MoveLinearAbsolute_Blend2.MoveOptions,
	CoordSystem := MoveLinearAbsolute_Blend2.CoordSystem,
	BufferMode := MoveLinearAbsolute_Blend2.BufferMode,
	TransitionMode := MoveLinearAbsolute_Blend2.TransitionMode,
	TransitionParameter := MoveLinearAbsolute_Blend2.TransitionParameter,
	Done => MoveLinearAbsolute_Blend2.Done,
    Busy => MoveLinearAbsolute_Blend2.Busy,
    Active => MoveLinearAbsolute_Blend2.Active,
    CommandAborted => MoveLinearAbsolute_Blend2.CommandAborted,
    Error => MoveLinearAbsolute_Blend2.Error,
    ErrorID => MoveLinearAbsolute_Blend2.ErrorID
	);
	//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend2.Error, MoveLinearAbsolute_Blend2.ErrorID,'MC_MoveLinearAbsolute_Blend2',fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend2.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinAbsBlend2_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearAbsolute_Blend2.Error, 
        bMoveLinAbsBlend2_OldErr, 
        MoveLinearAbsolute_Blend2.ErrorID, 
        'MC_MoveLinearAbsolute_Blend2', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	As above *)
MC_MoveLinearAbsolute_Blend3(
    AxesGroup := GroupRef,
	Execute := MoveLinearAbsolute_Blend3.Execute,
	Position := MoveLinearAbsolute_Blend3.Position,
	Velocity := MoveLinearAbsolute_Blend3.Velocity,
	Acceleration := MoveLinearAbsolute_Blend3.Acceleration,
	Deceleration := MoveLinearAbsolute_Blend3.Deceleration,
	// Jerk,
	MoveOptions := MoveLinearAbsolute_Blend3.MoveOptions,
	CoordSystem := MoveLinearAbsolute_Blend3.CoordSystem,
	BufferMode := MoveLinearAbsolute_Blend3.BufferMode,
	TransitionMode := MoveLinearAbsolute_Blend3.TransitionMode,
	TransitionParameter := MoveLinearAbsolute_Blend3.TransitionParameter,
	Done => MoveLinearAbsolute_Blend3.Done,
    Busy => MoveLinearAbsolute_Blend3.Busy,
    Active => MoveLinearAbsolute_Blend3.Active,
    CommandAborted => MoveLinearAbsolute_Blend3.CommandAborted,
    Error => MoveLinearAbsolute_Blend3.Error,
    ErrorID => MoveLinearAbsolute_Blend3.ErrorID
	);
	//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend3.Error, MoveLinearAbsolute_Blend3.ErrorID,'MC_MoveLinearAbsolute_Blend3',fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend3.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinAbsBlend3_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearAbsolute_Blend3.Error, 
        bMoveLinAbsBlend3_OldErr, 
        MoveLinearAbsolute_Blend3.ErrorID, 
        'MC_MoveLinearAbsolute_Blend3', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	As above *)
MC_MoveLinearAbsolute_Blend4(
    AxesGroup := GroupRef,
	Execute := MoveLinearAbsolute_Blend4.Execute,
	Position := MoveLinearAbsolute_Blend4.Position,
	Velocity := MoveLinearAbsolute_Blend4.Velocity,
	Acceleration := MoveLinearAbsolute_Blend4.Acceleration,
	Deceleration := MoveLinearAbsolute_Blend4.Deceleration,
	// Jerk,
	MoveOptions := MoveLinearAbsolute_Blend4.MoveOptions,
	CoordSystem := MoveLinearAbsolute_Blend4.CoordSystem,
	BufferMode := MoveLinearAbsolute_Blend4.BufferMode,
	TransitionMode := MoveLinearAbsolute_Blend4.TransitionMode,
	TransitionParameter := MoveLinearAbsolute_Blend4.TransitionParameter,
	Done => MoveLinearAbsolute_Blend4.Done,
    Busy => MoveLinearAbsolute_Blend4.Busy,
    Active => MoveLinearAbsolute_Blend4.Active,
    CommandAborted => MoveLinearAbsolute_Blend4.CommandAborted,
    Error => MoveLinearAbsolute_Blend4.Error,
    ErrorID => MoveLinearAbsolute_Blend4.ErrorID
	);
	//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend4.Error, MoveLinearAbsolute_Blend4.ErrorID,'MC_MoveLinearAbsolute_Blend4',fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend4.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinAbsBlend4_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearAbsolute_Blend4.Error, 
        bMoveLinAbsBlend4_OldErr, 
        MoveLinearAbsolute_Blend4.ErrorID, 
        'MC_MoveLinearAbsolute_Blend4', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	As above *)
MC_MoveLinearAbsolute_Blend5(
    AxesGroup := GroupRef,
	Execute := MoveLinearAbsolute_Blend5.Execute,
	Position := MoveLinearAbsolute_Blend5.Position,
	Velocity := MoveLinearAbsolute_Blend5.Velocity,
	Acceleration := MoveLinearAbsolute_Blend5.Acceleration,
	Deceleration := MoveLinearAbsolute_Blend5.Deceleration,
	// Jerk,
	MoveOptions := MoveLinearAbsolute_Blend5.MoveOptions,
	CoordSystem := MoveLinearAbsolute_Blend5.CoordSystem,
	BufferMode := MoveLinearAbsolute_Blend5.BufferMode,
	TransitionMode := MoveLinearAbsolute_Blend5.TransitionMode,
	TransitionParameter := MoveLinearAbsolute_Blend5.TransitionParameter,
	Done => MoveLinearAbsolute_Blend5.Done,
    Busy => MoveLinearAbsolute_Blend5.Busy,
    Active => MoveLinearAbsolute_Blend5.Active,
    CommandAborted => MoveLinearAbsolute_Blend5.CommandAborted,
    Error => MoveLinearAbsolute_Blend5.Error,
    ErrorID => MoveLinearAbsolute_Blend5.ErrorID
	);
	//fbErrorHandler.AddUpdateError(MoveLinearAbsolute_Blend5.Error, MoveLinearAbsolute_Blend5.ErrorID,'MC_MoveLinearAbsolute_Blend5',fbErrorHandler.GetErrorMessage(MoveLinearAbsolute_Blend5.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinAbsBlend5_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearAbsolute_Blend5.Error, 
        bMoveLinAbsBlend5_OldErr, 
        MoveLinearAbsolute_Blend5.ErrorID, 
        'MC_MoveLinearAbsolute_Blend5', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	This Function Block commands an interpolated linear movement on an AxesGroup from the commanded position of the group 
	at the time this function block initiates motion to a relative position in the specified coordinate system. *)
MC_MoveLinearRelative_1(
	AxesGroup := GroupRef,			             								(*	Axes group reference *)
	Execute := MoveLinearRelative_Group.Execute,							(*	Upon the rising edge, all other function block inputs are read and the function is initiated. To modify an input, change the value and re-trigger the execute input. *)
	Distance := MoveLinearRelative_Group.Distance,							(*	An array of values. The specific meaning of each value depends upon the Coordinate System specified and the mechanism, and the context. *)
	Velocity := MoveLinearRelative_Group.Velocity,							(*	Absolute value of the velocity in user units/second. *)
	Acceleration := MoveLinearRelative_Group.Acceleration,					(*	Value of the acceleration in user units/second^2 (acceleration is applicable with same sign of torque and velocity) *)
	Deceleration := MoveLinearRelative_Group.Deceleration,					(*	Value of the deceleration in user units/second^2 (deceleration is applicable with opposite signs of torque and velocity) *)
	Jerk := MoveLinearRelative_Group.Jerk,									(*	Not supported; reserved for future use.  Value of the jerk in [user units / second^3]. *)
	MoveOptions := MoveLinearRelative_Group.MoveOptions,					(*	Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. *)
	CoordSystem := MoveLinearRelative_Group.CoordSystem,					(*	Enumeration with the following values: 0 = ACS, 1 = MCS, 2 = PCS, 3 = TCS, 4 = WCS, 5 = TPCS. *)
	BufferMode := MoveLinearRelative_Group.BufferMode,						(*	Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. *)
	TransitionMode := MoveLinearRelative_Group.TransitionMode,				(*	Specifies how segments are blended together when multiple MC_MoveLinear and MC_MoveCircular function blocks are buffered. *)
	TransitionParameter := MoveLinearRelative_Group.TransitionParameter,	(*	Additional parameters for the selected TransitionMode. *)
	Done => MoveLinearRelative_Group.Done,                                  (*	Set high when the commanded action has completed successfully. If another block takes control before the action is completed, the Done output will not be set. This output is reset when Execute goes low. *)
	Busy => MoveLinearRelative_Group.Busy,                                  (*	Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. *)
	Active => MoveLinearRelative_Group.Active,                              (*	For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. *)
	CommandAborted => MoveLinearRelative_Group.CommandAborted,              (*	Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. *)
	Error => MoveLinearRelative_Group.Error,                                (*	Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. *)
	ErrorID => MoveLinearRelative_Group.ErrorID                             (*	If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. *)
	);
	//fbErrorHandler.AddUpdateError(MoveLinearRelative_Group.Error, MoveLinearRelative_Group.ErrorID,'MC_MoveLinearRelative_1',fbErrorHandler.GetErrorMessage(MoveLinearRelative_Group.ErrorID),E_ErrorSeverity#MajorError);
    bMoveLinRel1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        MoveLinearRelative_Group.Error, 
        bMoveLinRel1_OldErr, 
        MoveLinearRelative_Group.ErrorID, 
        'MC_MoveLinearRelative_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	This function block jogs a Group's Joint in the Axis Coordinate System (ACS). *)
Y_GroupJogJoint_1(
	AxesGroup := GroupRef,            							(*	Axes group reference *)
	Enable := GroupJogJoint_Group.Enable,					(*	The function will continue to execute every scan while Enable is held high and there are no errors. *)
	JointIndex := GroupJogJoint_Group.JointIndex,			(*	Refer to the Hardware Configuration's group definition chart which shows the Index for each of the axes in the group. *)
	Velocity := GroupJogJoint_Group.Velocity,				(*	Velocity in degrees/sec. *)
	Acceleration := GroupJogJoint_Group.Acceleration,		(*	Acceleration in degrees/sec. *)
	Deceleration := GroupJogJoint_Group.Deceleration,		(*	Deceleration in degrees/sec. *)
	Jerk := GroupJogJoint_Group.Jerk,						(*	Not supported; reserved for future use. Value of the jerk in [user units / second^3]. *)
	MoveOptions := GroupJogJoint_Group.MoveOptions,			(*	Commands to specify the pose of a robot mechanism, set Cartesian or rotational velocity, velocity units, etc. *)
	Direction := GroupJogJoint_Group.Direction,				(*	Specifies the direction of motion. Allowable modes are positive_direction, shortest_way, negative_direction, current_direction. *)
	BufferMode := GroupJogJoint_Group.BufferMode,			(*	Defines the behavior of the axis - allowable modes are Aborting, Buffered, BlendingLow, BlendingPrevious, BlendingNext, and BlendingHigh. *)
	Valid => GroupJogJoint_Group.Valid,                     (*	Indicates that the function is operating normally and the outputs of the function are valid. *)
	Busy => GroupJogJoint_Group.Busy,                       (*	Set high upon the rising edge of the Execute input, and reset when Done, CommandAborted, or Error is true. In the case of a function block with an Enable input, a Busy output indicates the function is operating, but not ready to provide Valid information. *)
	Active => GroupJogJoint_Group.Active,                   (*	For buffered modes, this output is set high at the moment the block takes control of the axis. For non buffered modes, the outputs Busy and Active have the same value. *)
	CommandAborted => GroupJogJoint_Group.CommandAborted,   (*	Set high if motion is aborted by another motion command or MC_Stop. This output is cleared with the same behavior as the Done output. *)
	Error => GroupJogJoint_Group.Error,                     (*	Set high if an error has occurred during the execution of the function block. This output is cleared when 'Execute' or 'Enable' goes low. *)
	ErrorID => GroupJogJoint_Group.ErrorID                  (*	If Error is true, this output provides the Error ID. This output is reset when 'Execute' or 'Enable' goes low. *)
	);
	//fbErrorHandler.AddUpdateError(GroupJogJoint_Group.Error, GroupJogJoint_Group.ErrorID,'Y_GroupJogJoint_1',fbErrorHandler.GetErrorMessage(GroupJogJoint_Group.ErrorID),E_ErrorSeverity#MajorError);
    bGroupJog1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        GroupJogJoint_Group.Error, 
        bGroupJog1_OldErr, 
        GroupJogJoint_Group.ErrorID, 
        'Y_GroupJogJoint_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	Function block that calculates the origin of a frame that is at a specified offset from another frame in cartesian space. *)
CalcFrameOffset_1(
    Enable := CalcFrameOffset_Group.Enable,                 (*	Enables the function *)
	InputFrame := CalcFrameOffset_Group.InputFrame,			(*	Example = [0 0 0 0 0 90] *)
	Offset := CalcFrameOffset_Group.Offset,					(*	Example = [10 0 0 0 0 0] *)
	OutputFrame := CalcFrameOffset_Group.OutputFrame,
	Valid => CalcFrameOffset_Group.Valid,
	Error => CalcFrameOffset_Group.Error,
	ErrorID => CalcFrameOffset_Group.ErrorID
	);
	//fbErrorHandler.AddUpdateError(CalcFrameOffset_Group.Error, CalcFrameOffset_Group.ErrorID,'CalcFrameOffset_1',fbErrorHandler.GetErrorMessage(CalcFrameOffset_Group.ErrorID),E_ErrorSeverity#MajorError);
    bCalcFrameOffset1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        CalcFrameOffset_Group.Error, 
        bCalcFrameOffset1_OldErr, 
        CalcFrameOffset_Group.ErrorID, 
        'CalcFrameOffset_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	Function block to convert three points  OO, XX, XY  representing an origin (OO), a point in the +X direction (XX),  and a point in the XY plane perpendicular to the X axis from XX (XY) to a cartesian frame in X, Y, Z, Rx, Ry, Rz *)
FrameTypeTransform_1(
	FrameCoordinates := FrameTypeTransform_FeedIn.FrameCoordinates,
	Execute := FrameTypeTransform_FeedIn.Execute,
	OO := FrameTypeTransform_FeedIn.OO,
	XX := FrameTypeTransform_FeedIn.XX,
	XY := FrameTypeTransform_FeedIn.XY,
	Done => FrameTypeTransform_FeedIn.Done,
	Error => FrameTypeTransform_FeedIn.Error,
	ErrorID => FrameTypeTransform_FeedIn.ErrorID,
	Singularity => FrameTypeTransform_FeedIn.Singularity
	);
	//fbErrorHandler.AddUpdateError(FrameTypeTransform_FeedIn.Error, FrameTypeTransform_FeedIn.ErrorID,'FrameTypeTransform_1',fbErrorHandler.GetErrorMessage(FrameTypeTransform_FeedIn.ErrorID),E_ErrorSeverity#MajorError);
    bFrameTypeTransform1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        FrameTypeTransform_FeedIn.Error, 
        bFrameTypeTransform1_OldErr, 
        FrameTypeTransform_FeedIn.ErrorID, 
        'FrameTypeTransform_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

FrameTypeTransform_2(
	FrameCoordinates := FrameTypeTransform_FeedOut.FrameCoordinates,
	Execute := FrameTypeTransform_FeedOut.Execute,
	OO := FrameTypeTransform_FeedOut.OO,
	XX := FrameTypeTransform_FeedOut.XX,
	XY := FrameTypeTransform_FeedOut.XY,
	Done => FrameTypeTransform_FeedOut.Done,
	Error => FrameTypeTransform_FeedOut.Error,
	ErrorID => FrameTypeTransform_FeedOut.ErrorID,
	Singularity => FrameTypeTransform_FeedOut.Singularity
	);
	//fbErrorHandler.AddUpdateError(FrameTypeTransform_FeedOut.Error, FrameTypeTransform_FeedOut.ErrorID,'FrameTypeTransform_2',fbErrorHandler.GetErrorMessage(FrameTypeTransform_FeedOut.ErrorID),E_ErrorSeverity#MajorError);
	bFrameTypeTransform2_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        FrameTypeTransform_FeedOut.Error, 
        bFrameTypeTransform2_OldErr, 
        FrameTypeTransform_FeedOut.ErrorID, 
        'FrameTypeTransform_2', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	Setting the part frame offset *)
Y_GroupSetFrameOffset_1(
	AxesGroup := GroupRef,
	Execute := GroupSetFrameOffset_FeedIn.Execute,
	Offset := GroupSetFrameOffset_FeedIn.Offset,
	ExecutionMode := GroupSetFrameOffset_FeedIn.ExecutionMode,
	RefCoordSystem := GroupSetFrameOffset_FeedIn.RefCoordSystem,
	SetCoordSystem := GroupSetFrameOffset_FeedIn.SetCoordSystem,
	Done => GroupSetFrameOffset_FeedIn.Done,
	Busy => GroupSetFrameOffset_FeedIn.Busy,
	Error => GroupSetFrameOffset_FeedIn.Error,
	ErrorID => GroupSetFrameOffset_FeedIn.ErrorID
	);
	//fbErrorHandler.AddUpdateError(GroupSetFrameOffset_FeedIn.Error, GroupSetFrameOffset_FeedIn.ErrorID,'Y_GroupSetFrameOffset_1',fbErrorHandler.GetErrorMessage(GroupSetFrameOffset_FeedIn.ErrorID),E_ErrorSeverity#MajorError);
	bGroupSetFrameOffset1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        GroupSetFrameOffset_FeedIn.Error, 
        bGroupSetFrameOffset1_OldErr, 
        GroupSetFrameOffset_FeedIn.ErrorID, 
        'Y_GroupSetFrameOffset_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

Y_GroupSetFrameOffset_2(
	AxesGroup := GroupRef,
	Execute := GroupSetFrameOffset_FeedOut.Execute,
	Offset := GroupSetFrameOffset_FeedOut.Offset,
	ExecutionMode := GroupSetFrameOffset_FeedOut.ExecutionMode,
	RefCoordSystem := GroupSetFrameOffset_FeedOut.RefCoordSystem,
	SetCoordSystem := GroupSetFrameOffset_FeedOut.SetCoordSystem,
	Done => GroupSetFrameOffset_FeedOut.Done,
	Busy => GroupSetFrameOffset_FeedOut.Busy,
	Error => GroupSetFrameOffset_FeedOut.Error,
	ErrorID => GroupSetFrameOffset_FeedOut.ErrorID
	);
	//fbErrorHandler.AddUpdateError(GroupSetFrameOffset_FeedOut.Error, GroupSetFrameOffset_FeedOut.ErrorID,'Y_GroupSetFrameOffset_2',fbErrorHandler.GetErrorMessage(GroupSetFrameOffset_FeedOut.ErrorID),E_ErrorSeverity#MajorError);
    bGroupSetFrameOffset2_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        GroupSetFrameOffset_FeedOut.Error, 
        bGroupSetFrameOffset2_OldErr, 
        GroupSetFrameOffset_FeedOut.ErrorID, 
        'Y_GroupSetFrameOffset_2', 
        '', 
        E_ErrorSeverity#MajorError
    );

(*	This function block allows an AxesGroup to track objects moving in a straight line in space by activating a dynamic calculation of the PCS 
	such that the positive X direction of the Part Coordinate System (PCS) is updated as the ConveyorBelt axis moves. *)
MC_TrackConveyorBelt_1(
	AxesGroup := GroupRef,
	ConveyorBelt := TrackConveyorBelt_FeedIn.ConveyorBelt,
	Execute := TrackConveyorBelt_FeedIn.Execute,
	ConveyorBeltOrigin := TrackConveyorBelt_FeedIn.ConveyorBeltOrigin,
	InitialObjectPosition := TrackConveyorBelt_FeedIn.InitialObjectPosition,
	RecordedPosition := TrackConveyorBelt_FeedIn.RecordedPosition,
	StartDistance := TrackConveyorBelt_FeedIn.StartDistance,
	EndDistance := TrackConveyorBelt_FeedIn.EndDistance,
	TrackOptions := TrackConveyorBelt_FeedIn.TrackOptions,
	ExecutionMode := TrackConveyorBelt_FeedIn.ExecutionMode,
	Done => TrackConveyorBelt_FeedIn.Done,
	Busy => TrackConveyorBelt_FeedIn.Busy,
	Active => TrackConveyorBelt_FeedIn.Active,
	InSync => TrackConveyorBelt_FeedIn.InSync,
	CommandAborted => TrackConveyorBelt_FeedIn.CommandAborted,
	Error => TrackConveyorBelt_FeedIn.Error,
	ErrorID => TrackConveyorBelt_FeedIn.ErrorID
	);
	//fbErrorHandler.AddUpdateError(TrackConveyorBelt_FeedIn.Error, TrackConveyorBelt_FeedIn.ErrorID,'MC_TrackConveyorBelt_1',fbErrorHandler.GetErrorMessage(TrackConveyorBelt_FeedIn.ErrorID),E_ErrorSeverity#MajorError);
    bTrackConveyorBelt1_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        TrackConveyorBelt_FeedIn.Error, 
        bTrackConveyorBelt1_OldErr, 
        TrackConveyorBelt_FeedIn.ErrorID, 
        'MC_TrackConveyorBelt_1', 
        '', 
        E_ErrorSeverity#MajorError
    );

MC_TrackConveyorBelt_2(
	AxesGroup := GroupRef,
	ConveyorBelt := TrackConveyorBelt_FeedOut.ConveyorBelt,
	Execute := TrackConveyorBelt_FeedOut.Execute,
	ConveyorBeltOrigin := TrackConveyorBelt_FeedOut.ConveyorBeltOrigin,
	InitialObjectPosition := TrackConveyorBelt_FeedOut.InitialObjectPosition,
	RecordedPosition := TrackConveyorBelt_FeedOut.RecordedPosition,
	StartDistance := TrackConveyorBelt_FeedOut.StartDistance,
	EndDistance := TrackConveyorBelt_FeedOut.EndDistance,
	TrackOptions := TrackConveyorBelt_FeedOut.TrackOptions,
	ExecutionMode := TrackConveyorBelt_FeedOut.ExecutionMode,
	Done => TrackConveyorBelt_FeedOut.Done,
	Busy => TrackConveyorBelt_FeedOut.Busy,
	Active => TrackConveyorBelt_FeedOut.Active,
	InSync => TrackConveyorBelt_FeedOut.InSync,
	CommandAborted => TrackConveyorBelt_FeedOut.CommandAborted,
	Error => TrackConveyorBelt_FeedOut.Error,
	ErrorID => TrackConveyorBelt_FeedOut.ErrorID
	);
	//fbErrorHandler.AddUpdateError(TrackConveyorBelt_FeedOut.Error, TrackConveyorBelt_FeedOut.ErrorID,'MC_TrackConveyorBelt_2',fbErrorHandler.GetErrorMessage(TrackConveyorBelt_FeedOut.ErrorID),E_ErrorSeverity#MajorError);
	bTrackConveyorBelt2_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        TrackConveyorBelt_FeedOut.Error, 
        bTrackConveyorBelt2_OldErr, 
        TrackConveyorBelt_FeedOut.ErrorID, 
        'MC_TrackConveyorBelt_2', 
        '', 
        E_ErrorSeverity#MajorError
    );
    
// KPI: tracking attivo (usato da FB_KPI, vedi KPI/GUIDA_KPI.md)
G_xTrackingActive := TrackConveyorBelt_FeedIn.Active OR TrackConveyorBelt_FeedOut.Active;

fbSelectNextProduct(
    Execute := xiSelectNextProduct_Pick, 
    GroupNumber := 0, 
    Done => bSelectDone, 
    Busy => bSelectBusy, 
    Error => bSelectError, 
    ErrorID => uiSelectErrorID, 
    MultiGroupProductData := MultiGrpProductData
);
    bSelectNextProduct_OldErr := fbErrorHandler.CheckAndEnqueue(
        1, 
        bSelectError, 
        bSelectNextProduct_OldErr, 
        uiSelectErrorID, 
        'fbSelectNextProduct', 
        '', 
        E_ErrorSeverity#MinorError
    );

IF bSelectDone THEN 
    xiSelectNextProduct_Pick := FALSE;
END_IF

fbRotatePosition(
    //bExecute := , 
    iPosTable := posTable, 
    fPivotX := 0.0, 
    fPivotY := 0.0, 
    fPivotZ := 0.0, 
    fDeltaRx := 0.0, 
    fDeltaRy := 0.0, 
    //fDeltaRz := 0.0, 
    oPosTable => ROT_posTable, 
    bDone =>, 
    bError =>, 
    nGimbalCount =>
    );


//fbPosTable(
//    io_In       := io,
//    AxesGroup   := GroupRef,
//    posTable_In := ROT_posTable
//);