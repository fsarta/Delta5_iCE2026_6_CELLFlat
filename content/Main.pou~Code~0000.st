SecuredArea := ToLinkVar;

FB_MachineController1();

// KPI: motore KPI (vedi KPI/GUIDA_KPI.md) - istanza retain, contatori lifetime conservati
fbKPI(
    xEnable     := TRUE,
    xResetShift := G_xKPI_ResetShift
);

//FB_VisionApplication1(
//    xStartSequence := BOOL, 
//    xResetError := BOOL, 
//    xEnableCyclicTrigger := BOOL, 
//    tCyclicTriggerTime := TIME, 
//    VisorEIP_Receive := Yt_ByteArray72, 
//    i_stConnectionStatus := EIP_STATUS_REF, 
//    Visor_Transmit => Yt_ByteArray3, 
//    eState => E_VisionMgr_State, 
//    xActive => BOOL, 
//    xDone => BOOL, 
//    xError => BOOL, 
//    stLastGoodResult => DT_VISOR_Assem5_ResultData, 
//    xVisorConnected => BOOL, 
//    xVisorReady => BOOL
//    );

(*
// --- Byte 0: Status_Bits ---
stInput.Status_Bits.Ready           := (VisorEIP_Receive[0] AND BYTE#1) <> 0;
stInput.Status_Bits.Spare0_1        := (VisorEIP_Receive[0] AND BYTE#2) <> 0;
stInput.Status_Bits.TriggerAck      := (VisorEIP_Receive[0] AND BYTE#4) <> 0;
stInput.Status_Bits.ChangeJobAck    := (VisorEIP_Receive[0] AND BYTE#8) <> 0;
stInput.Status_Bits.SwitchToRunAck  := (VisorEIP_Receive[0] AND BYTE#16) <> 0;
stInput.Status_Bits.Spare0_5        := (VisorEIP_Receive[0] AND BYTE#32) <> 0;
stInput.Status_Bits.Spare0_6        := (VisorEIP_Receive[0] AND BYTE#64) <> 0;
stInput.Status_Bits.Spare0_7        := (VisorEIP_Receive[0] AND BYTE#128) <> 0;

// --- Byte 1: Spare ---
stInput.Spare_Byte1                 := VisorEIP_Receive[1];

// --- Byte 2-7: Dati di Stato ---
stInput.DigitalResults              := VisorEIP_Receive[2];
stInput.JobNumber                   := TO_USINT(VisorEIP_Receive[3]); // USINT
stInput.ImageId                     := TO_USINT(VisorEIP_Receive[4]); // USINT
stInput.Status_Byte5                := VisorEIP_Receive[5];
stInput.Data_ImageId                := TO_USINT(VisorEIP_Receive[6]); // USINT
stInput.DataStatus_Byte7            := VisorEIP_Receive[7];

// --- Byte 8-39: ResultData ---
//stInput.ResultData.Part_Index       := FC_BytesToInt(VisorEIP_Receive[8], VisorEIP_Receive[9]);
//stInput.ResultData.Part_Type        := FC_BytesToInt(VisorEIP_Receive[10], VisorEIP_Receive[11]);
stInput.ResultData.Pos_X[0]         := FC_BytesToReal(VisorEIP_Receive[8], VisorEIP_Receive[9], VisorEIP_Receive[10], VisorEIP_Receive[11]) / 1000.0;
stInput.ResultData.Pos_X[1]         := FC_BytesToReal(VisorEIP_Receive[12], VisorEIP_Receive[13], VisorEIP_Receive[14], VisorEIP_Receive[15]) / 1000.0;
stInput.ResultData.Pos_X[2]         := FC_BytesToReal(VisorEIP_Receive[16], VisorEIP_Receive[17], VisorEIP_Receive[18], VisorEIP_Receive[19]) / 1000.0;
stInput.ResultData.Pos_X[3]         := FC_BytesToReal(VisorEIP_Receive[20], VisorEIP_Receive[21], VisorEIP_Receive[22], VisorEIP_Receive[23]) / 1000.0;

stInput.ResultData.Pos_Y[0]         := FC_BytesToReal(VisorEIP_Receive[24], VisorEIP_Receive[25], VisorEIP_Receive[26], VisorEIP_Receive[27]) / 1000.0;
stInput.ResultData.Pos_Y[1]         := FC_BytesToReal(VisorEIP_Receive[28], VisorEIP_Receive[29], VisorEIP_Receive[30], VisorEIP_Receive[31]) / 1000.0;
stInput.ResultData.Pos_Y[2]         := FC_BytesToReal(VisorEIP_Receive[32], VisorEIP_Receive[33], VisorEIP_Receive[34], VisorEIP_Receive[35]) / 1000.0;
stInput.ResultData.Pos_Y[3]         := FC_BytesToReal(VisorEIP_Receive[36], VisorEIP_Receive[37], VisorEIP_Receive[38], VisorEIP_Receive[39]) / 1000.0;

stInput.ResultData.Angle_Rz[0]      := FC_BytesToReal(VisorEIP_Receive[40], VisorEIP_Receive[41], VisorEIP_Receive[42], VisorEIP_Receive[43]) / 1000.0;
stInput.ResultData.Angle_Rz[1]      := FC_BytesToReal(VisorEIP_Receive[44], VisorEIP_Receive[45], VisorEIP_Receive[46], VisorEIP_Receive[47]) / 1000.0;
stInput.ResultData.Angle_Rz[2]      := FC_BytesToReal(VisorEIP_Receive[48], VisorEIP_Receive[49], VisorEIP_Receive[50], VisorEIP_Receive[51]) / 1000.0;
stInput.ResultData.Angle_Rz[3]      := FC_BytesToReal(VisorEIP_Receive[52], VisorEIP_Receive[53], VisorEIP_Receive[54], VisorEIP_Receive[55]) / 1000.0;

stInput.ResultData.Part_Count       := VisorEIP_Receive[56];

VisorEIP_Transmit[0].X2             := TestTrigger;

R_TRIG1(CLK := TestTrigger);

IF R_TRIG1.Q THEN
    FeedInPositionTrigger := DATA_FeedInAxis.Feedback.ActualPosition;
END_IF;
*)