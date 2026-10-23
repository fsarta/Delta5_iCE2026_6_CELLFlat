// The Y_MotionAxisDriver FB enables communication between the PLCopenPart1 function block (MC_Power, MC_MoveVelocity...) and the motion axis
Y_MotionAxisDriver1(
    Axis := AXI, 
    Enable := TRUE, 
    Valid => STS_DriverValid, 
    Busy => STS_DriverBusy, 
    Error => STS_DriverError, 
    ErrorID => VAR_DriverErrorID
    );
//fbErrorHandler.AddUpdateError(STS_DriverError, VAR_DriverErrorID, 'Y_MotionAxisDriver1', fbErrorHandler.GetErrorMessage(VAR_DriverErrorID), E_ErrorSeverity#MajorError);    

// Axis Control (MC_Power / MC_Reset functionality combined)
AxisControl_1(
    Axis           := AXI,                      // Logical axis reference 
    Enable         := CMD_Enable,               // Enable/Disable axis 
    EnablePositive := TRUE,                     // Not supported, keep TRUE 
    EnableNegative := TRUE,                     // Not supported, keep TRUE 
    //AlarmClear     := CMD_ResetFault,           // Clears axis alarms 
    Status         => STS_AxCtrlEnabled,        // TRUE if drive is enabled 
    AxisAlarm      => STS_AxCtrlFault,          // Indicates axis alarm (controller or drive) 
    DriveWarning   => STS_AxCtrlDriveWarning,   // Indicates a warning on the drive (e.g., A.9x on ServoPack) 
    Error          => STS_AxCtrlError,          // Error occurred during FB execution 
    ErrorID        => VAR_AxCtrlErrID,          // Error ID if Error is TRUE 
    DriveWarningID => VAR_AxCtrlDriveWarningID, // Drive warning number (e.g., 95 for overload) 
    DriveAlarmID   => VAR_AxCtrlDriveAlarmID,   // Drive alarm number (e.g., C9 for encoder disconnected) 
    ControlAlarmID => VAR_AxCtrlAlarmID         // Controller alarm ID (e.g., 3302 0018) 
);
//fbErrorHandler.AddUpdateError(STS_AxCtrlError, VAR_AxCtrlErrID, 'AxisControl_1', fbErrorHandler.GetErrorMessage(VAR_AxCtrlErrID), E_ErrorSeverity#MajorError); 
//fbErrorHandler.AddUpdateError(STS_AxCtrlFault, VAR_AxCtrlDriveAlarmID, 'AxisControl_1', '', E_ErrorSeverity#MajorError);  // Drive alarm IDs often map to specific drive manual entries
//fbErrorHandler.AddUpdateError(STS_AxCtrlDriveWarning, VAR_AxCtrlDriveWarningID, 'AxisControl_1', '', E_ErrorSeverity#MinorError); 
//fbErrorHandler.AddUpdateError(VAR_AxCtrlAlarmID <> 0, VAR_AxCtrlAlarmID, 'AxisControl_1', '', E_ErrorSeverity#MinorError); 

MC_Reset1(
    Axis := AXI, 
    Execute := CMD_ResetFault 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
//fbErrorHandler.AddUpdateError(MC_Reset1.Error, MC_Reset1.ErrorID, 'MC_Reset1', fbErrorHandler.GetErrorMessage(MC_Reset1.ErrorID), E_ErrorSeverity#MajorError); 

// Jog Function Block (Y_AX_Jog is likely a vendor-specific FB, but similar to MC_Jog)
Jog_1(
    Axis           := AXI, // Logical axis reference 
    Forward        := CMD_JogFor, // Runs axis in Forward direction 
    Reverse        := CMD_JogRev, // Runs axis in Reverse direction 
    Velocity       := VAR_JogSpeed, // Absolute value of velocity 
    Acceleration   := VAR_JogAcc, // Value of acceleration 
    Deceleration   := VAR_JogDec, // Value of deceleration 
    Jerk           := LREAL#0.0, // Not supported for this FB 
    InVelocity     => STS_JogInVelocity, // High when axis first reaches specified velocity 
    Done           => STS_JogDone, // On for one scan when axis stops after Forward/Reverse go FALSE 
    Busy           => STS_JogBusy, // High on rising edge of Forward/Reverse, reset on Done/Aborted/Error 
    CommandAborted => STS_JogCmdAb, // Set TRUE if operation aborted by another command 
    Error          => STS_JogError, // Error occurred during FB execution 
    ErrorID        => VAR_JogErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_JogError, VAR_JogErrID, 'Jog_1', fbErrorHandler.GetErrorMessage(VAR_JogErrID), E_ErrorSeverity#MajorError); 

// Home Axis Jog (Specific Jog FB for homing sequence, possibly with different parameters or priority)
Jog_2(
    Axis           := AXI, // Logical axis reference 
    Forward        := CMD_HomeJogFor, // Runs axis in Forward direction 
    Reverse        := CMD_HomeJogRev, // Runs axis in Reverse direction 
    Velocity       := VAR_HomeJogSpeed, // Absolute value of velocity for homing 
    Acceleration   := VAR_HomeJogAcc, // Value of acceleration for homing 
    Deceleration   := VAR_HomeJogDec, // Value of deceleration for homing 
    Jerk           := LREAL#0.0, // Not supported for this FB 
    InVelocity     => STS_HomeJogInVelocity, // High when axis first reaches specified velocity 
    Done           => STS_HomeJogDone, // On for one scan when axis stops after Forward/Reverse go FALSE 
    Busy           => STS_HomeJogBusy, // High on rising edge of Forward/Reverse, reset on Done/Aborted/Error 
    CommandAborted => STS_HomeJogCmdAb, // Set TRUE if operation aborted by another command 
    Error          => STS_HomeJogError, // Error occurred during FB execution 
    ErrorID        => VAR_HomeJogErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_HomeJogError, VAR_HomeJogErrID, 'Jog_2', fbErrorHandler.GetErrorMessage(VAR_HomeJogErrID), E_ErrorSeverity#MajorError); 

// Incremental Positioning (MC_MoveRelative)
MC_MoveRelative_1(
    Axis           := AXI, // Logical axis reference 
    Execute        := CMD_IncPos, // Execute incremental move 
    Distance       := VAR_IncPosTarget, // Incremental distance to move 
    Velocity       := VAR_PosSpeed, // Velocity for the move 
    Acceleration   := VAR_PosAcc, // Acceleration for the move 
    Deceleration   := VAR_PosDec, // Deceleration for the move 
    Jerk           := LREAL#0.0, // Not supported 
    BufferMode     := VAR_IncPosBufferMode, // Buffer mode for command execution 
    Done           => STS_IncPosDone, // TRUE when move is complete 
    Busy           => STS_IncPosBusy, // TRUE when FB is executing 
    Active         => STS_IncPosActive, // TRUE when command is actively controlling the axis 
    CommandAborted => STS_IncPosCmdAb, // TRUE if command aborted 
    Error          => STS_IncPosError, // TRUE if error occurred 
    ErrorID        => VAR_IncPosErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_IncPosError, VAR_IncPosErrID, 'MC_MoveRelative_1', fbErrorHandler.GetErrorMessage(VAR_IncPosErrID), E_ErrorSeverity#MajorError); 

// Home Incremental Positioning (MC_MoveRelative for homing sequences)
MC_MoveRelative_2(
    Axis           := AXI, // Logical axis reference 
    Execute        := CMD_HomeIncPos, // Execute incremental move for homing 
    Distance       := VAR_HomeIncPosTarget, // Incremental distance for homing 
    Velocity       := VAR_HomePosSpeed, // Velocity for homing move 
    Acceleration   := VAR_HomePosAcc, // Acceleration for homing move 
    Deceleration   := VAR_HomePosDec, // Deceleration for homing move 
    Jerk           := LREAL#0.0, // Not supported 
    BufferMode     := VAR_HomeIncPosBufferMode, // Buffer mode for homing command 
    Done           => STS_HomeIncPosDone, // TRUE when homing move is complete 
    Busy           => STS_HomeIncPosBusy, // TRUE when FB is executing 
    Active         => STS_HomeIncPosActive, // TRUE when command is actively controlling the axis 
    CommandAborted => STS_HomeIncPosCmdAb, // TRUE if command aborted 
    Error          => STS_HomeIncPosError, // TRUE if error occurred 
    ErrorID        => VAR_HomeIncPosErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_HomeIncPosError, VAR_HomeIncPosErrID, 'MC_MoveRelative_2', fbErrorHandler.GetErrorMessage(VAR_HomeIncPosErrID), E_ErrorSeverity#MajorError); 

// Absolute Positioning (MC_MoveAbsolute)
MC_MoveAbsolute_1(
    Axis           := AXI, // Logical axis reference 
    Execute        := CMD_AbsPos, // Execute absolute move 
    Position       := VAR_AbsPosTarget, // Target absolute position 
    Velocity       := VAR_PosSpeed, // Velocity for the move 
    Acceleration   := VAR_PosAcc, // Acceleration for the move 
    Deceleration   := VAR_PosDec, // Deceleration for the move 
    Jerk           := LREAL#0.0, // Not supported 
    Direction      := VAR_AbsPosDirection, // Direction of travel (e.g., shortest, positive, negative) 
    BufferMode     := VAR_AbsPosBufferMode, // Buffer mode for command execution 
    Done           => STS_AbsPosDone, // TRUE when move is complete 
    Busy           => STS_AbsPosBusy, // TRUE when FB is executing 
    Active         => STS_AbsPosActive, // TRUE when command is actively controlling the axis 
    CommandAborted => STS_AbsPosCmdAb, // TRUE if command aborted 
    Error          => STS_AbsPosError, // TRUE if error occurred 
    ErrorID        => VAR_AbsPosErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_AbsPosError, VAR_AbsPosErrID, 'MC_MoveAbsolute_1', fbErrorHandler.GetErrorMessage(VAR_AbsPosErrID), E_ErrorSeverity#MajorError); 

// Touch Probe (MC_TouchProbe)
// CMD_TouchProbe was commented out in initial command mapping, so ensure it's enabled if needed.
MC_TouchProbe_1(
    Axis               := AXI, // Logical axis reference 
    TriggerInput       := VAR_TriggerInput, // Input to trigger the probe 
    Execute            := CMD_TouchProbe, // Execute touch probe operation (assuming this is the command) 
    WindowOnly         := FALSE, // Probe outside of a window (TRUE for inside window) 
    FirstPosition      := LREAL#0.0, // First position for windowed probing 
    LastPosition       := LREAL#0.0, // Last position for windowed probing 
    Done               => STS_TouchProbeDone, // TRUE when probe is done 
    Busy               => STS_TouchProbeBusy, // TRUE when FB is executing 
    CommandAborted     => STS_TouchProbeCmdAb, // TRUE if command aborted 
    Error              => STS_TouchProbeError, // TRUE if error occurred 
    ErrorID            => VAR_TouchProbeErrID, // Error ID if Error is TRUE 
    RecordedPosition   => VAR_TouchProbeRecPos // Position recorded at trigger event 
);
//fbErrorHandler.AddUpdateError(STS_TouchProbeError, VAR_TouchProbeErrID, 'MC_TouchProbe_1', fbErrorHandler.GetErrorMessage(VAR_TouchProbeErrID), E_ErrorSeverity#MajorError); 

F_TRIG_TouchProbe(CLK := DATA_AXI.Command.TouchProbe);
IF F_TRIG_TouchProbe.Q THEN
    CMD_AbortTriggerActive := TRUE;   // falling edge of the probe signal -> latch reset
END_IF;
MC_AbortTrigger_1(
    Axis               := AXI, // Logical axis reference
    TriggerInput       := VAR_TriggerInput, // Input to trigger the probe 
    Execute            := CMD_AbortTriggerActive, // Initiate the abort of the pending latch
    Done               => STS_AbortTriggerDone, // TRUE when abort is done 
    Busy               => STS_AbortTriggerBusy, // TRUE when FB is executing 
    Error              => STS_AbortTriggerError, // TRUE if error occurred 
    ErrorID            => VAR_AbortTriggerErrID // Error ID if Error is TRUE 
);
IF STS_AbortTriggerDone OR STS_AbortTriggerError THEN
    CMD_AbortTriggerActive := FALSE; // impulso di abort completato
END_IF;
//fbErrorHandler.AddUpdateError(STS_AbortTriggerError, VAR_AbortTriggerErrID, 'MC_AbortTrigger_1', fbErrorHandler.GetErrorMessage(VAR_TouchProbeErrID), E_ErrorSeverity#MajorError); 

// Torque Control (MC_TorqueControl)
MC_TorqueControl_1(
    Axis           := AXI, // Logical axis reference 
    Execute        := CMD_TqCtrl, // Execute torque control 
    Torque         := VAR_TqCtrlTorque, // Target torque value 
    TorqueRamp     := VAR_TqCtrlTorqueRamp, // Rate of torque change 
    Velocity       := VAR_TqCtrlSpeed, // Speed limit during torque control 
    Acceleration   := VAR_TqCtrlAcc, // Acceleration for speed limit 
    Deceleration   := VAR_TqCtrlDec, // Deceleration for speed limit 
    Jerk           := LREAL#0.0, // Not supported 
    Direction      := VAR_TqCtrlDir, // Direction of motion during torque control 
    BufferMode     := VAR_TqCtrlBufferMode, // Buffer mode for command execution 
    InTorque       => STS_TqCtrlInTorque, // TRUE when axis is within torque tolerance 
    Busy           => STS_TqCtrlBusy, // TRUE when FB is executing 
    Active         => STS_TqCtrlActive, // TRUE when command is actively controlling the axis 
    CommandAborted => STS_TqCtrlCmdAb, // TRUE if command aborted 
    Error          => STS_TqCtrlError, // TRUE if error occurred 
    ErrorID        => STS_TqCtrlErrId // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_TqCtrlError, STS_TqCtrlErrId, 'MC_TorqueControl_1', fbErrorHandler.GetErrorMessage(STS_TqCtrlErrId), E_ErrorSeverity#MajorError); 

// Stop Axis (MC_Stop for general stop)
MC_Stop_1(
    Axis           := AXI, // Logical axis reference 
    Execute        := CMD_Stop, // Execute stop command 
    Deceleration   := VAR_EmergencyStopRamp, // Deceleration ramp for stopping 
    Done           => STS_StopDone, // TRUE when stop is complete 
    Busy           => STS_StopBusy, // TRUE when FB is executing 
    CommandAborted => STS_StopCmdAb, // TRUE if command aborted 
    Error          => STS_StopError, // TRUE if error occurred 
    ErrorID        => VAR_StopErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_StopError, VAR_StopErrID, 'MC_Stop_1', fbErrorHandler.GetErrorMessage(VAR_StopErrID), E_ErrorSeverity#MajorError); 

// Home Stop Axis (MC_Stop for homing sequences, typically a faster stop)
MC_Stop_2(
    Axis           := AXI, // Logical axis reference 
    Execute        := CMD_HomeStop, // Execute stop command for homing 
    Deceleration   := LREAL#10000.0, // Fixed high deceleration for homing stop 
    Done           => STS_HomeStopDone, // TRUE when stop is complete 
    Busy           => STS_HomeStopBusy, // TRUE when FB is executing 
    CommandAborted => STS_HomeStopCmdAb, // TRUE if command aborted 
    Error          => STS_HomeStopError, // TRUE if error occurred 
    ErrorID        => VAR_HomeStopErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_HomeStopError, VAR_HomeStopErrID, 'MC_Stop_2', fbErrorHandler.GetErrorMessage(VAR_HomeStopErrID), E_ErrorSeverity#MajorError); 

// Set Position, Absolute (MC_SetPosition)
MC_SetPosition_1(
    Axis       := AXI, // Logical axis reference 
    Execute    := CMD_AbsSetPos, // Execute set position command 
    Position   := VAR_SetPosValue, // Target position to set 
    Mode       := FALSE, // ABSOLUTE mode 
    Done       => STS_AbsSetPosDone, // TRUE when set position is complete 
    Busy       => STS_AbsSetPosBusy, // TRUE when FB is executing 
    Error      => STS_AbsSetPosError, // TRUE if error occurred 
    ErrorID    => VAR_AbsSetPosErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_AbsSetPosError, VAR_AbsSetPosErrID, 'MC_SetPosition_1', fbErrorHandler.GetErrorMessage(VAR_AbsSetPosErrID), E_ErrorSeverity#MajorError); 

// Set Position, Incremental (MC_SetPosition in relative mode)
MC_SetPosition_2(
    Axis       := AXI, // Logical axis reference 
    Execute    := CMD_IncSetPos, // Execute set position command 
    Position   := VAR_SetPosValue, // Incremental value to add/subtract from current position 
    Mode       := TRUE, // RELATIVE mode 
    Done       => STS_IncSetPosDone, // TRUE when set position is complete 
    Busy       => STS_IncSetPosBusy, // TRUE when FB is executing 
    Error      => STS_IncSetPosError, // TRUE if error occurred 
    ErrorID    => VAR_IncSetPosErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_IncSetPosError, VAR_IncSetPosErrID, 'MC_SetPosition_2', fbErrorHandler.GetErrorMessage(VAR_IncSetPosErrID), E_ErrorSeverity#MajorError); 

// Home Set Position, Absolute (MC_SetPosition for homing sequence)
MC_SetPosition_3(
    Axis       := AXI, // Logical axis reference 
    Execute    := CMD_HomeSetPos, // Execute set position command for homing 
    Position   := VAR_HomeSetPosValue, // Target position to set during homing 
    Mode       := FALSE, // ABSOLUTE mode 
    Done       => STS_HomeSetPosDone, // TRUE when set position is complete 
    Busy       => STS_HomeSetPosBusy, // TRUE when FB is executing 
    Error      => STS_HomeSetPosError, // TRUE if error occurred 
    ErrorID    => VAR_HomeSetPosErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_HomeSetPosError, VAR_HomeSetPosErrID, 'MC_SetPosition_3', fbErrorHandler.GetErrorMessage(VAR_HomeSetPosErrID), E_ErrorSeverity#MajorError); 

// Write Drive Parameter (Y_WriteDriveParameter_1 is likely vendor-specific)
Y_WriteDriveParameter_1(
    Axis               := AXI, // Logical axis reference 
    Execute            := CMD_WriteDrvPar, // Execute write drive parameter command 
    ParameterNumber    := VAR_ParNumber, // Parameter number to write 
    Value              := VAR_WriteDrvParValue, // Value to write to the parameter 
    Done               => STS_WriteDrvParDone, // TRUE when write is complete 
    Busy               => STS_WriteDrvParBusy, // TRUE when FB is executing 
    Error              => STS_WriteDrvParError, // TRUE if error occurred 
    ErrorID            => VAR_WriteDrvParErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_WriteDrvParError, VAR_WriteDrvParErrID, 'Y_WriteDriveParameter_1', fbErrorHandler.GetErrorMessage(VAR_WriteDrvParErrID), E_ErrorSeverity#MajorError); 

// Read Drive Parameter (Y_ReadDriveParameter_1 is likely vendor-specific)
Y_ReadDriveParameter_1(
    Axis               := AXI, // Logical axis reference 
    Execute            := CMD_ReadDrvPar, // Execute read drive parameter command 
    ParameterNumber    := VAR_ParNumber, // Parameter number to read 
    DataTypeOverride   := VAR_ParOverride, // Override for data type (if needed for specific parameters) 
    Done               => STS_ReadDrvParDone, // TRUE when read is complete 
    Busy               => STS_ReadDrvParBusy, // TRUE when FB is executing 
    Error              => STS_ReadDrvParError, // TRUE if error occurred 
    ErrorID            => STS_ReadDrvParErrID, // Error ID if Error is TRUE 
    Value              => VAR_ReadDrvParValue, // Value read from the parameter 
    DataType           => VAR_ReadDrvParDataType // Data type of the read parameter 
);
//fbErrorHandler.AddUpdateError(STS_ReadDrvParError, STS_ReadDrvParErrID, 'Y_ReadDriveParameter_1', fbErrorHandler.GetErrorMessage(STS_ReadDrvParErrID), E_ErrorSeverity#MajorError); 

// Step Ref Pulse (MC_StepRefPulse for Z-pulse homing)
MC_StepRefPulse_1(
    Axis               := AXI, // Logical axis reference 
    Execute            := CMD_StepRefPulse, // Execute step reference pulse command 
    Direction          := VAR_StepRefPulseDirection, // Direction for pulse search 
    Velocity           := VAR_StepRefPulseSpeed, // Velocity for pulse search 
    SetPosition        := LREAL#0.0, // Not used in this context (for setting a position after a pulse) 
    TorqueLimit        := LREAL#800.0, // Torque limit during pulse search (e.g., for mechanical stop homing) 
    Done               => STS_StepRefPulseDone, // TRUE when pulse search is complete 
    Busy               => STS_StepRefPulseBusy, // TRUE when FB is executing 
    Active             => STS_StepRefPulseActive, // TRUE when command is actively controlling the axis 
    CommandAborted     => STS_StepRefPulseCmdAb, // TRUE if command aborted 
    Error              => STS_StepRefPulseError, // TRUE if error occurred 
    ErrorID            => VAR_StepRefPulseErrID // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_StepRefPulseError, VAR_StepRefPulseErrID, 'MC_StepRefPulse_1', fbErrorHandler.GetErrorMessage(VAR_StepRefPulseErrID), E_ErrorSeverity#MajorError); 

// Absolute Position Manager (Vendor-specific for absolute encoder management)
AbsolutePositionManager_1(
    Axis               := AXI, // Logical axis reference 
    Enable             := CMD_AbsPosManEnable, // Enable/Disable the manager 
    SetPosition        := CMD_AbsPosManSetPos, // Command to set the absolute position 
    Position           := VAR_AbsPosManSetPos, // Target position for setting 
    ResetEncoder       := CMD_AbsPosManResetEnc, // Command to reset encoder errors 
    Valid              => STS_AbsPosManValid, // TRUE when manager is valid 
    Busy               => STS_AbsPosManBusy, // TRUE when FB is executing 
    SetPositionDone    => STS_AbsPosManSetPosDone, // TRUE when set position is complete 
    PositionValid      => STS_AbsPosManPosValid, // TRUE when absolute position is valid 
    ResetDone          => STS_AbsPosManResetDone, // TRUE when encoder reset is complete 
    EncoderAlarmID     => VAR_AbsPosManEncAlmId, // Encoder specific alarm ID 
    ControllerAlarmID  => VAR_AbsPosManControlAlmId, // Controller specific alarm ID 
    Error              => STS_AbsPosManError, // TRUE if error occurred 
    ErrorID            => VAR_AbsPosManErrId // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_AbsPosManError, VAR_AbsPosManErrId, 'AbsolutePositionManager_1', fbErrorHandler.GetErrorMessage(VAR_AbsPosManErrId), E_ErrorSeverity#MajorError); 
//fbErrorHandler.AddUpdateError(VAR_AbsPosManEncAlmId <> 0, VAR_AbsPosManEncAlmId, 'AbsolutePositionManager_1', 'Encoder Alarm', E_ErrorSeverity#MinorError); 
//fbErrorHandler.AddUpdateError(VAR_AbsPosManControlAlmId <> 0, VAR_AbsPosManControlAlmId, 'AbsolutePositionManager_1', 'Controller Alarm', E_ErrorSeverity#MinorError); 

// Brake Release (Y_BrakeRelease_1 is likely vendor-specific)
Y_BrakeRelease_1(
    Axis           := AXI, // Logical axis reference 
    BrakeOutput    := BrakeOutput, // Dedicated servo output for brake relay 
    Execute        := CMD_ManualBrake, // Execute brake release command 
    State          := VAR_ManualBrakeState, // Desired state of the brake (TRUE for released) 
    Done           => STS_BrakeReleaseDone, // TRUE when brake operation is complete 
    Busy           => STS_BrakeReleaseBusy, // TRUE when FB is executing 
    Error          => STS_BrakeReleaseError, // TRUE if error occurred 
    ErrorID        => VAR_BrakeReleaseErrorId // Error ID if Error is TRUE 
);
//fbErrorHandler.AddUpdateError(STS_BrakeReleaseError, VAR_BrakeReleaseErrorId, 'Y_BrakeRelease_1', fbErrorHandler.GetErrorMessage(VAR_BrakeReleaseErrorId), E_ErrorSeverity#MajorError);
