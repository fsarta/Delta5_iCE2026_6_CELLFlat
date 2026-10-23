// ====================================================================================================
// SECTION 1: COMMAND and SETTING MAPPINGS
// This section maps generic commands to the axis-specific data structure.
// ====================================================================================================
// Commands
CMD_Enable              := DATA_AXI.Command.Enable; 
CMD_JogFor              := DATA_AXI.Command.JogPos; 
CMD_JogRev              := DATA_AXI.Command.JogNeg; 
CMD_AbsPos              := DATA_AXI.Command.AbsPositioning; 
CMD_IncPos              := DATA_AXI.Command.IncPositioning; 
CMD_AbsSetPos           := DATA_AXI.Command.AbsSetPos; 
CMD_IncSetPos           := DATA_AXI.Command.IncSetPos; 
CMD_ResetFault          := DATA_AXI.Command.ResetFault; 
CMD_Stop                := DATA_AXI.Command.EmergencyStop; 
CMD_TouchProbe          := DATA_AXI.Command.TouchProbe; 
CMD_AbortTriggerActive  := DATA_AXI.Command.AbortTrigger;
CMD_TqCtrl              := DATA_AXI.Command.TorqueControl; 
CMD_WriteDrvPar         := DATA_AXI.Command.WriteDrvPar; 
CMD_Home                := DATA_AXI.Command.Home; 
CMD_HomeDir             := DATA_AXI.Command.HomeDir; 
CMD_HomeExtInRef        := DATA_AXI.Command.HomeExtInRef; 
CMD_HomeExtIn           := DATA_AXI.Command.HomeExtIn; 
CMD_HomeZPulse          := DATA_AXI.Command.HomeZPulse; 
CMD_HomeAbsEnc          := DATA_AXI.Command.HomeAbsEnc; 
CMD_ManualBrake         := DATA_AXI.Command.ManualBrake; 

// Settings
VAR_JogSpeed            := DATA_AXI.Setting.JogSpeed; 
VAR_JogAcc              := DATA_AXI.Setting.JogAcc; 
VAR_JogDec              := DATA_AXI.Setting.JogDec; 
VAR_AbsPosTarget        := DATA_AXI.Setting.AbsPositioningTarget; 
VAR_IncPosTarget        := DATA_AXI.Setting.IncPositioningTarget; 
VAR_PosSpeed            := DATA_AXI.Setting.PositioningSpeed; 
VAR_PosAcc              := DATA_AXI.Setting.PositioningAcc; 
VAR_PosDec              := DATA_AXI.Setting.PositioningDec; 
VAR_EmergencyStopRamp   := DATA_AXI.Setting.EmergencyStopRamp; 
VAR_SetPosValue         := DATA_AXI.Setting.SetPosValue; 
VAR_AbsPosDirection     := DATA_AXI.Setting.AbsPosDirection; 
VAR_AbsPosBufferMode    := DATA_AXI.Setting.AbsPosBufferMode; 
VAR_TqCtrlTorque        := DATA_AXI.Setting.TqCtrlTorque; 
VAR_TqCtrlTorqueRamp    := DATA_AXI.Setting.TqCtrlTorqueRamp; 
VAR_TqCtrlSpeed         := DATA_AXI.Setting.TqCtrlSpeed; 
VAR_TqCtrlAcc           := DATA_AXI.Setting.TqCtrlAcc; 
VAR_TqCtrlDec           := DATA_AXI.Setting.TqCtrlDec; 
VAR_TqCtrlDir           := DATA_AXI.Setting.TqCtrlDir; 
VAR_TqCtrlBufferMode    := DATA_AXI.Setting.TqCtrlBufferMode; 
VAR_TriggerInput        := DATA_AXI.Setting.TouchProbeTriggerInput; 
VAR_ParNumber           := DATA_AXI.Setting.WriteParNumber; 
VAR_IncPosBufferMode    := DATA_AXI.Setting.IncPosBufferMode; 
VAR_HomeIncPosBufferMode:= DATA_AXI.Setting.IncHomePosBufferMode; 
VAR_WriteDrvParValue    := DATA_AXI.Setting.WriteDrvParValue; 
VAR_HomeSpeed           := DATA_AXI.Setting.HomeSpeed; 
VAR_HomeOffsett         := DATA_AXI.Setting.HomeOffsett; 
VAR_HomeAcc             := DATA_AXI.Setting.HomeAcc; 
VAR_HomeDec             := DATA_AXI.Setting.HomeDec; 
VAR_HomePos             := DATA_AXI.Setting.HomePos; 
VAR_ManualBrakeState    := DATA_AXI.Setting.ManualBrakeState;