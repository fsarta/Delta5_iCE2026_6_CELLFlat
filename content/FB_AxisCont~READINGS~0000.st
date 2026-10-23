// ====================================================================================================
// SECTION 2: AXIS FEEDBACK READINGS
// This section reads various feedback parameters from the axis.
// ====================================================================================================

// Command Position
fbReadCommandPosition(
    Axis            := AXI,                 // Logical axis reference 
    Enable          := NOT(STS_AxCtrlFault),// Enable only if axis control is not in fault 
    ParameterNumber := UINT#1010,           // CommandedPosition in user units 
    Valid           => STS_ReadComPosValid, // Indicates valid data 
    Busy            => STS_ReadComPosBusy,  // Indicates the FB is busy 
    Error           => STS_ReadComPosErr,   // Indicates an error occurred 
    ErrorID         => VAR_ReadComPosErrID, // Error ID if an error occurred 
    Value           => VAR_CommandPosition  // Output: Commanded position value 
);
//fbErrorHandler.AddUpdateError(STS_ReadComPosErr, VAR_ReadComPosErrID, 'fbReadCommandPosition', fbErrorHandler.GetErrorMessage(VAR_ReadComPosErrID), E_ErrorSeverity#MinorError);

// Position Error (Following Error)
fbReadPositionError(
    Axis            := AXI,                     // Logical axis reference 
    Enable          := NOT(STS_AxCtrlFault),    // Enable only if axis control is not in fault 
    ParameterNumber := UINT#1130,               // PositionError (following error) in user units 
    Valid           => STS_ReadFollErrValid,    // Indicates valid data 
    Busy            => STS_ReadFollErrBusy,     // Indicates the FB is busy 
    Error           => STS_ReadFollErrError,    // Indicates an error occurred 
    ErrorID         => STS_ReadFollErrErrID,    // Error ID if an error occurred 
    Value           => VAR_FollErr              // Output: Position error value 
);
//fbErrorHandler.AddUpdateError(STS_ReadFollErrError, STS_ReadFollErrErrID, 'fbReadPositionError', fbErrorHandler.GetErrorMessage(STS_ReadFollErrErrID), E_ErrorSeverity#MinorError);

// Actual Position
MC_ReadActualPosition_1(
    Axis        := AXI,                 // Logical axis reference 
    Enable      := TRUE,                // Always enable reading actual position, even during fault for diagnostics 
    ErrorID     => VAR_ReadActPosErrID, // Error ID if an error occurred 
    Position    => VAR_ActualPosition   // Output: Actual position value 
);
// Note: MC_ReadActualPosition_1 typically does not have direct Error output, it logs to ErrorID.
//fbErrorHandler.AddUpdateError(VAR_ReadActPosErrID <> 0, VAR_ReadActPosErrID, 'MC_ReadActualPosition_1', fbErrorHandler.GetErrorMessage(VAR_ReadActPosErrID), E_ErrorSeverity#MinorError);


// Command Speed
fbReadCommandSpeed(
    Axis            := AXI,                     // Logical axis reference 
    Enable          := NOT(STS_AxCtrlFault),    // Enable only if axis control is not in fault 
    ParameterNumber := UINT#1011,               // CommandedVelocity in user units/second 
    Valid           => STS_ReadComSpValid,      // Indicates valid data 
    Busy            => STS_ReadComSpBusy,       // Indicates the FB is busy 
    Error           => STS_ReadComSpErr,        // Indicates an error occurred 
    ErrorID         => VAR_ReadComSpErrID,      // Error ID if an error occurred 
    Value           => VAR_CommandSpeed         // Output: Commanded speed value 
);
//fbErrorHandler.AddUpdateError(STS_ReadComSpErr, VAR_ReadComSpErrID, 'fbReadCommandSpeed', fbErrorHandler.GetErrorMessage(VAR_ReadComSpErrID), E_ErrorSeverity#MinorError);

// Actual Speed
MC_ReadActualVelocity_1(
    Axis        := AXI, // Logical axis reference 
    Enable      := NOT(STS_AxCtrlFault),    // Enable only if axis control is not in fault 
    ErrorID     => VAR_ReadActSpErrID,      // Error ID if an error occurred 
    Velocity    => VAR_ActualSpeed          // Output: Actual speed value 
);
//fbErrorHandler.AddUpdateError(VAR_ReadActSpErrID <> 0, VAR_ReadActSpErrID, 'MC_ReadActualVelocity_1', fbErrorHandler.GetErrorMessage(VAR_ReadActSpErrID), E_ErrorSeverity#MinorError);

// Actual Torque
MC_ReadActualTorque_1(
    Axis    := AXI, // Logical axis reference 
    Enable  := NOT(STS_AxCtrlFault),    // Enable only if axis control is not in fault 
    ErrorID => VAR_ReadActTqErrID,      // Error ID if an error occurred 
    Torque  => VAR_ActualTorque         // Output: Actual torque value 
);
//fbErrorHandler.AddUpdateError(VAR_ReadActTqErrID <> 0, VAR_ReadActTqErrID, 'MC_ReadActualTorque_1', fbErrorHandler.GetErrorMessage(VAR_ReadActTqErrID), E_ErrorSeverity#MinorError);

// Axis Status
MC_ReadStatus_1(
    Axis                := AXI,                         // Logical axis reference 
    Enable              := TRUE,                        // Always enable reading axis status 
    Valid               => STS_ReadStatusValid,         // Indicates if the status is valid 
    Busy                => STS_ReadStatusBusy,          // Indicates the FB is busy 
    ErrorStop           => STS_ReadStatusErrorStop,     // Axis is in error stop 
    Disabled            => STS_ReadStatusDisabled,      // Axis is disabled 
    Stopping            => STS_ReadStatusStopping,      // Axis is stopping 
    StandStill          => STS_ReadStatusStandStill,    // Axis is at standstill 
    DiscreteMotion      => STS_ReadStatusDiscrMotion,   // Axis is performing discrete motion 
    ContinuousMotion    => STS_ReadStatusContMotion,    // Axis is performing continuous motion 
    SynchronizedMotion  => STS_ReadStatusSyncMotion,    // Axis is performing synchronized motion 
    Homing              => STS_ReadStatusHoming,        // Axis is in homing process 
    ConstantVelocity    => STS_ReadStatusConstVel,      // Axis is moving at constant velocity 
    Accelerating        => STS_ReadStatusAccelerating,  // Axis is accelerating 
    Decelerating        => STS_ReadStatusDecelerating,  // Axis is decelerating 
    Error               => STS_ReadStatusError,         // Indicates an error occurred 
    ErrorID             => VAR_ReadStatusErrID          // Error ID if an error occurred 
);
//fbErrorHandler.AddUpdateError(STS_ReadStatusError, VAR_ReadStatusErrID, 'MC_ReadStatus_1', fbErrorHandler.GetErrorMessage(VAR_ReadStatusErrID), E_ErrorSeverity#MinorError);
