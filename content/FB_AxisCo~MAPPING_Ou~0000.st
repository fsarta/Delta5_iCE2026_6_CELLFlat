// ====================================================================================================
// SECTION 1: STATUS, FEEDBACK and ERROR MAPPINGS
// This section maps generic commands to the axis-specific data structure.
// ====================================================================================================

// Status
DATA_AXI.Status.Fault           := STS_AxCtrlFault; 
DATA_AXI.Status.Enabled         := STS_AxCtrlEnabled; 
DATA_AXI.Status.JogInVelocity   := STS_JogInVelocity; 
DATA_AXI.Status.AbsPosDone      := STS_AbsPosDone; 
DATA_AXI.Status.IncPosDone      := STS_IncPosDone; 
DATA_AXI.Status.StandStill      := STS_ReadStatusStandStill; 
DATA_AXI.Status.Stopping        := STS_ReadStatusStopping; 
DATA_AXI.Status.AbsSetPosDone   := STS_AbsSetPosDone; 
DATA_AXI.Status.IncSetPosDone   := STS_IncSetPosDone; 
DATA_AXI.Status.InTorque        := STS_TqCtrlInTorque; 
DATA_AXI.Status.TouchProbeDone  := STS_TouchProbeDone; 
DATA_AXI.Status.WriteParDone    := STS_WriteParDone; 
DATA_AXI.Status.Homed           := STS_HomeDone; 
DATA_AXI.Status.Errors          := STS_AbsPosManError OR STS_AxCtrlError OR STS_JogError OR STS_HomeJogError OR
                                   STS_AbsPosError OR STS_IncPosError OR STS_HomeIncPosError OR
                                   STS_ReadComPosErr OR STS_ReadFollErrError OR STS_ReadComSpErr OR STS_ReadStatusError OR
                                   STS_AbsSetPosError OR STS_IncSetPosError OR STS_HomeSetPosError OR STS_StepRefPulseError OR
                                   STS_StopError OR STS_HomeStopError OR STS_BrakeReleaseError OR STS_ReadDrvParError OR
                                   STS_WriteDrvParError OR STS_TouchProbeError OR STS_AbortTriggerError; 

// Feedbacks
DATA_AXI.Feedback.CommandPosition   := VAR_CommandPosition; 
DATA_AXI.Feedback.ActualPosition    := VAR_ActualPosition; 
DATA_AXI.Feedback.CommandSpeed      := VAR_CommandSpeed; 
DATA_AXI.Feedback.ActualSpeed       := VAR_ActualSpeed; 
DATA_AXI.Feedback.ActualTorque      := VAR_ActualTorque; 
DATA_AXI.Feedback.FollErr           := VAR_FollErr; 
DATA_AXI.Feedback.DriveAlarmID      := VAR_AxCtrlDriveAlarmID; 
DATA_AXI.Feedback.TouchProbeRecPos  := VAR_TouchProbeRecPos; 

// Errors
DATA_AXI.Error.AbsPosManager_Err        := STS_AbsPosManError; 
DATA_AXI.Error.AbsPosManager_ErrId      := VAR_AbsPosManErrId; 
DATA_AXI.Error.AxCtrl_Err               := STS_AxCtrlError; 
DATA_AXI.Error.AxCtrl_ErrId             := VAR_AxCtrlErrID; 
DATA_AXI.Error.Jog_Err                  := STS_JogError; 
DATA_AXI.Error.Jog_ErrId                := VAR_JogErrID; 
DATA_AXI.Error.HomeJog_Err              := STS_HomeJogError; 
DATA_AXI.Error.HomeJog_ErrId            := VAR_HomeJogErrID; 
DATA_AXI.Error.MoveAbs_Err              := STS_AbsPosError; 
DATA_AXI.Error.MoveAbs_ErrId            := VAR_AbsPosErrID; 
DATA_AXI.Error.MoveInc_Err              := STS_IncPosError; 
DATA_AXI.Error.MoveInc_ErrId            := VAR_IncPosErrID; 
DATA_AXI.Error.MoveIncHome_Err          := STS_HomeIncPosError; 
DATA_AXI.Error.MoveIncHome_ErrId        := VAR_HomeIncPosErrID; 
DATA_AXI.Error.ReadActPos_ErrId         := VAR_ReadActPosErrID; 
DATA_AXI.Error.ReadActTq_ErrId          := VAR_ReadActTqErrID; 
DATA_AXI.Error.ReadActSp_ErrId          := VAR_ReadActSpErrID; 
DATA_AXI.Error.ReadComPos_Err           := STS_ReadComPosErr; 
DATA_AXI.Error.ReadComPos_ErrId         := VAR_ReadComPosErrID; 
DATA_AXI.Error.ReadPosErr_Err           := STS_ReadFollErrError; 
DATA_AXI.Error.ReadPosErr_ErrId         := STS_ReadFollErrErrID; 
DATA_AXI.Error.ReadComSp_Err            := STS_ReadComSpErr; 
DATA_AXI.Error.ReadComSp_ErrId          := VAR_ReadComSpErrID; 
DATA_AXI.Error.ReadStatus_Err           := STS_ReadStatusError; 
DATA_AXI.Error.ReadStatus_ErrId         := VAR_ReadStatusErrID; 
DATA_AXI.Error.AbsSetPos_Err            := STS_AbsSetPosError; 
DATA_AXI.Error.AbsSetPos_ErrId          := VAR_AbsSetPosErrID; 
DATA_AXI.Error.IncSetPos_Err            := STS_IncSetPosError; 
DATA_AXI.Error.IncSetPos_ErrId          := VAR_IncSetPosErrID; 
DATA_AXI.Error.HomeSetPos_Err           := STS_HomeSetPosError; 
DATA_AXI.Error.HomeSetPos_ErrId         := VAR_HomeSetPosErrID; 
DATA_AXI.Error.StepRefPulse_Err         := STS_StepRefPulseError; 
DATA_AXI.Error.StepRefPulse_ErrId       := VAR_StepRefPulseErrID; 
DATA_AXI.Error.Stop_Err                 := STS_StopError; 
DATA_AXI.Error.Stop_ErrId               := VAR_StopErrID; 
DATA_AXI.Error.HomeStop_Err             := STS_HomeStopError; 
DATA_AXI.Error.HomeStop_ErrId           := VAR_HomeStopErrID; 
DATA_AXI.Error.TqCtrl_Err               := STS_TqCtrlError; 
DATA_AXI.Error.TqCtrl_ErrId             := STS_TqCtrlErrId; 
DATA_AXI.Error.TouchProbe_Err           := STS_TouchProbeError; 
DATA_AXI.Error.TouchProbe_ErrId         := VAR_TouchProbeErrID; 
DATA_AXI.Error.AbortTrigger_Err         := STS_AbortTriggerError; 
DATA_AXI.Error.AbortTrigger_ErrId       := VAR_AbortTriggerErrID; 
DATA_AXI.Error.BrakeRelease_Err         := STS_BrakeReleaseError; 
DATA_AXI.Error.BrakeRelease_ErrId       := VAR_BrakeReleaseErrorId; 
DATA_AXI.Error.ReadDrvPar_Err           := STS_ReadDrvParError; 
DATA_AXI.Error.ReadDrvPar_ErrId         := STS_ReadDrvParErrID; 
DATA_AXI.Error.WriteDrvPar_Err          := STS_WriteDrvParError; 
DATA_AXI.Error.WriteDrvPar_ErrId        := VAR_WriteDrvParErrID; 
