MC_MoveAbsolute1(
    Axis         := Axis,
    Execute      := MoveForward.Execute,
    Position     := MoveForward.Position,
    Velocity     := MoveForward.Velocity,
    Acceleration := MoveForward.Acceleration,
    Deceleration := MoveForward.Deceleration,
    Jerk         := MoveForward.Jerk,
    Direction    := MoveForward.Direction,
    BufferMode   := MoveForward.BufferMode,
    Done         => MoveForward.Done,
    Busy         => MoveForward.Busy,
    Active       => MoveForward.Active,
    CommandAborted => MoveForward.CommandAborted,
    Error        => MoveForward.Error,
    ErrorID      => MoveForward.ErrorID
);

MC_MoveAbsolute2(
    Axis         := Axis,
    Execute      := MoveBackward.Execute,
    Position     := MoveBackward.Position,
    Velocity     := MoveBackward.Velocity,
    Acceleration := MoveBackward.Acceleration,
    Deceleration := MoveBackward.Deceleration,
    Jerk         := MoveBackward.Jerk,
    Direction    := MoveBackward.Direction,
    BufferMode   := MoveBackward.BufferMode,
    Done         => MoveBackward.Done,
    Busy         => MoveBackward.Busy,
    Active       => MoveBackward.Active,
    CommandAborted => MoveBackward.CommandAborted,
    Error        => MoveBackward.Error,
    ErrorID      => MoveBackward.ErrorID
);