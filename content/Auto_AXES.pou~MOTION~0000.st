MC_MoveAbsolute1(
    Axis         := ROT_Axis,
    Execute      := MC_MoveAbsolute1.Execute,
    Position     := PosBRot,
    Velocity     := DATA_Axes.Setting.AutoAxes.Velocity,
    Acceleration := DATA_Axes.Setting.AutoAxes.Acceleration,
    Deceleration := DATA_Axes.Setting.AutoAxes.Deceleration,
    Jerk         := 0.0,
    Direction    := MC_Direction#Positive_Direction,
    BufferMode   := MC_BufferMode#BlendingPrevious,
    Done         => DoneRot1,
    //Busy         => BOOL,
    Active       => ActiveRot1
    //CommandAborted => BOOL,
    //Error        => BOOL,
    //ErrorID      => UINT
);

MC_MoveAbsolute2(
    Axis         := ROT_Axis,
    Execute      := MC_MoveAbsolute2.Execute,
    Position     := PosARot,
    Velocity     := DATA_Axes.Setting.AutoAxes.Velocity,
    Acceleration := DATA_Axes.Setting.AutoAxes.Acceleration,
    Deceleration := DATA_Axes.Setting.AutoAxes.Deceleration,
    Jerk         := 0.0,
    Direction    := MC_Direction#Positive_Direction,
    BufferMode   := MC_BufferMode#BlendingPrevious,
    Done         => DoneRot2,
    //Busy         => BOOL,
    Active       => ActiveRot2
    //CommandAborted => BOOL,
    //Error        => BOOL,
    //ErrorID      => UINT
);

MC_MoveAbsolute3(
    Axis         := LIN_Axis,
    Execute      := MC_MoveAbsolute3.Execute,
    Position     := PosALin,
    Velocity     := DATA_Axes.Setting.AutoAxes.Velocity / 2.0,
    Acceleration := DATA_Axes.Setting.AutoAxes.Acceleration / 2.0,
    Deceleration := DATA_Axes.Setting.AutoAxes.Deceleration / 2.0,
    Jerk         := 0.0,
    Direction    := MC_Direction#Positive_Direction,
    BufferMode   := MC_BufferMode#BlendingPrevious,
    Done         => DoneLin1,
    //Busy         => BOOL,
    Active       => ActiveLin1
    //CommandAborted => BOOL,
    //Error        => BOOL,
    //ErrorID      => UINT
);

MC_MoveAbsolute4(
    Axis         := LIN_Axis,
    Execute      := MC_MoveAbsolute4.Execute,
    Position     := PosBLin,
    Velocity     := DATA_Axes.Setting.AutoAxes.Velocity / 2.0,
    Acceleration := DATA_Axes.Setting.AutoAxes.Acceleration / 2.0,
    Deceleration := DATA_Axes.Setting.AutoAxes.Deceleration / 2.0,
    Jerk         := 0.0,
    Direction    := MC_Direction#Positive_Direction,
    BufferMode   := MC_BufferMode#BlendingPrevious,
    Done         => DoneLin2,
    //Busy         => BOOL,
    Active       => ActiveLin2
    //CommandAborted => BOOL,
    //Error        => BOOL,
    //ErrorID      => UINT
);

