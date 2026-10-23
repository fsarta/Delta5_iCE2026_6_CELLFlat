Y_CA_CamGenerator1(
    CamData := CamSystemData.CamGenerator.CamData, 
    CamTable := CamSystemData.CamGenerator.CamTable, 
    Execute := CamSystemData.CamGenerator.Execute, 
    TableSize := CamSystemData.CamGenerator.TableSize, 
    Done => CamSystemData.CamGenerator.Done, 
    Busy => CamSystemData.CamGenerator.Busy, 
    Error => CamSystemData.CamGenerator.Error, 
    ErrorID => CamSystemData.CamGenerator.ErrorID
    );

Y_CamStructSelect1(
    CamTable := CamSystemData.CamStructSelect.CamTable, 
    Execute := CamSystemData.CamStructSelect.Execute, 
    BlockSize := CamSystemData.CamStructSelect.BlockSize, 
    Done => CamSystemData.CamStructSelect.Done, 
    Busy => CamSystemData.CamStructSelect.Busy, 
    Error => CamSystemData.CamStructSelect.Error, 
    ErrorID => CamSystemData.CamStructSelect.ErrorID, 
    CamTableID => CamSystemData.CamStructSelect.CamTableID
    );

Y_CamIn1(
    Master := CamSystemData.Master, 
    Slave := CamSystemData.Slave, 
    Execute := CamSystemData.CamIn.Execute, 
    CamTableID := CamSystemData.CamIn.CamTableID, 
    EngagePosition := CamSystemData.CamIn.EngagePosition, 
    EngageWindow := CamSystemData.CamIn.EngageWindow, 
    EngageData := CamSystemData.CamIn.EngageData, 
    Periodic := CamSystemData.CamIn.Periodic, 
    InSync => CamSystemData.CamIn.InSync, 
    Busy => CamSystemData.CamIn.Busy, 
    Active => CamSystemData.CamIn.Active, 
    CommandAborted => CamSystemData.CamIn.CommandAborted, 
    Error => CamSystemData.CamIn.Error, 
    ErrorID => CamSystemData.CamIn.ErrorID, 
    EndOfProfile => CamSystemData.CamIn.EndOfProfile
    );

Y_CamOut1(
    Slave := CamSystemData.Slave, 
    Execute := CamSystemData.CamOut.Execute, 
    DisengagePosition := CamSystemData.CamOut.DisengagePosition, 
    DisengageWindow := CamSystemData.CamOut.DisengageWindow, 
    DisengageData := CamSystemData.CamOut.DisengageData, 
    Done => CamSystemData.CamOut.Done, 
    Busy => CamSystemData.CamOut.Busy, 
    Error => CamSystemData.CamOut.Error, 
    ErrorID => CamSystemData.CamOut.ErrorID
    );

Y_CamShift1(
    Master := CamSystemData.Master, 
    Slave := CamSystemData.Slave, 
    Execute := CamSystemData.CamShift.Execute, 
    PhaseShift := CamSystemData.CamShift.PhaseShift, 
    AdjustMode := CamSystemData.CamShift.AdjustMode, 
    MasterDistance := CamSystemData.CamShift.MasterDistance, 
    Duration := CamSystemData.CamShift.Duration, 
    StartPosition := CamSystemData.CamShift.StartPosition, 
    EndPosition := CamSystemData.CamShift.EndPosition, 
    BufferMode := CamSystemData.CamShift.BufferMode, 
    Done => CamSystemData.CamShift.Done, 
    Busy => CamSystemData.CamShift.Busy, 
    Active => CamSystemData.CamShift.Active, 
    CommandAborted => CamSystemData.CamShift.CommandAborted, 
    Error => CamSystemData.CamShift.Error, 
    ErrorID => CamSystemData.CamShift.ErrorID
    );
    
Y_SlaveOffset1(
    Master := CamSystemData.Master, 
    Slave := CamSystemData.Slave, 
    Execute := CamSystemData.SlaveOffset.Execute, 
    Offset := CamSystemData.SlaveOffset.Offset, 
    AdjustMode := CamSystemData.SlaveOffset.AdjustMode, 
    MasterDistance := CamSystemData.SlaveOffset.MasterDistance, 
    Duration := CamSystemData.SlaveOffset.Duration, 
    StartPosition := CamSystemData.SlaveOffset.StartPosition, 
    EndPosition := CamSystemData.SlaveOffset.EndPosition, 
    BufferMode := CamSystemData.SlaveOffset.BufferMode, 
    Done => CamSystemData.SlaveOffset.Done, 
    Busy => CamSystemData.SlaveOffset.Busy, 
    Active => CamSystemData.SlaveOffset.Active, 
    CommandAborted => CamSystemData.SlaveOffset.CommandAborted, 
    Error => CamSystemData.SlaveOffset.Error, 
    ErrorID => CamSystemData.SlaveOffset.ErrorID
    );

MC_TouchProbe1(
	Axis := CamSystemData.AxisTouchProbe, 
	TriggerInput := CamSystemData.TriggerInput, 
	Execute := CamSystemData.TouchProbe.Execute, 
	//WindowOnly := BOOL, 
	//FirstPosition := LREAL, 
	//LastPosition := LREAL, 
	Done => CamSystemData.TouchProbe.Done, 
	Busy => CamSystemData.TouchProbe.Busy, 
	CommandAborted => CamSystemData.TouchProbe.CommandAborted, 
	Error => CamSystemData.TouchProbe.Error, 
	ErrorID => CamSystemData.TouchProbe.ErrorID, 
	RecordedPosition => CamSystemData.TouchProbe.RecordedPosition
	);
	
MC_AbortTrigger1(
    Axis := CamSystemData.AxisTouchProbe, 
    TriggerInput := CamSystemData.TriggerInput, 
    Execute := CamSystemData.AbortTrigger.Execute, 
    Done => CamSystemData.AbortTrigger.Done, 
    Busy => CamSystemData.AbortTrigger.Busy, 
    Error => CamSystemData.AbortTrigger.Error, 
    ErrorID => CamSystemData.AbortTrigger.ErrorID
    );

MC_Stop1(
    Axis := CamSystemData.Slave, 
    Execute := StopAxis, 
    Deceleration := 10000.0
    // Jerk := LREAL, 
    // Done => BOOL, 
    // Busy => BOOL, 
    // CommandAborted => BOOL, 
    // Error => BOOL, 
    // ErrorID => UINT
    );
        
Y_CA_SetCamMasterCycle1(
    Master := CamSystemData.Master, 
    Slave := CamSystemData.Slave, 
    Execute := CamSystemData.SetCamMasterCycle.Execute, 
    CamTableID := CamSystemData.SetCamMasterCycle.CamTableID,
    Done => CamSystemData.SetCamMasterCycle.Done, 
    Busy => CamSystemData.SetCamMasterCycle.Busy, 
    CommandAborted => CamSystemData.SetCamMasterCycle.CommandAborted, 
    Error => CamSystemData.SetCamMasterCycle.Error, 
    ErrorID => CamSystemData.SetCamMasterCycle.ErrorID
    );
    
Y_CA_CamMasterLookup1(
    CamTable := CamSystemData.CamMasterLookup.CamTable, 
    Enable := CamSystemData.CamMasterLookup.Enable, 
    MasterMin := CamSystemData.CamMasterLookup.MasterMin, 
    SlavePosition := CamSystemData.CamMasterLookup.SlavePosition, 
    MasterMax := CamSystemData.CamMasterLookup.MasterMax, 
    Valid => CamSystemData.CamMasterLookup.Valid, 
    Error => CamSystemData.CamMasterLookup.Error, 
    ErrorID => CamSystemData.CamMasterLookup.ErrorID, 
    MasterPosition => CamSystemData.CamMasterLookup.MasterPosition
    );
    
Y_CA_SlaveOffsetControl1(
    Master := CamSystemData.Master, 
    Slave := CamSystemData.Slave, 
    RegistrationData := CamSystemData.SlaveOffsetControl.RegistrationData, 
    OffsetControlData := CamSystemData.SlaveOffsetControl.OffsetControlData, 
    Enable := CamSystemData.SlaveOffsetControl.Enable, 
    DefaultSize := CamSystemData.SlaveOffsetControl.DefaultSize, 
    TheoreticalFirstPosition := CamSystemData.SlaveOffsetControl.TheoreticalFirstPosition, 
    ManualOffset := CamSystemData.SlaveOffsetControl.ManualOffset, 
    UpdateUsePointer := CamSystemData.SlaveOffsetControl.UpdateUsePointer, 
    Action := CamSystemData.SlaveOffsetControl.Action, 
    Valid => CamSystemData.SlaveOffsetControl.Valid, 
    Offsetting => CamSystemData.SlaveOffsetControl.Offsetting, 
    Error => CamSystemData.SlaveOffsetControl.Error, 
    ErrorID => CamSystemData.SlaveOffsetControl.ErrorID, 
    ItemsProcessed => CamSystemData.SlaveOffsetControl.ItemsProcessed
    );
    
MC_ReadParameter1(
    Axis := CamSystemData.Slave, 
    Enable := TRUE,
    ParameterNumber := 1502, 
    //Valid => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT, 
    Value => CamSystemData.CamParams.v1502_CamMasterShiftedCyclic);
    
MC_ReadParameter2(
    Axis := CamSystemData.Slave, 
    Enable := TRUE,
    ParameterNumber := 1511, 
    //Valid => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT, 
    Value => CamSystemData.CamParams.v1511_CamMasterShift);

MC_ReadParameter3(
    Axis := CamSystemData.Slave, 
    Enable := TRUE,
    ParameterNumber := 1512, 
    //Valid => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT, 
    Value => CamSystemData.CamParams.v1512_CamMasterCycle);

MC_ReadParameter4(
    Axis := CamSystemData.Slave, 
    Enable := TRUE,
    ParameterNumber := 1540, 
    //Valid => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT, 
    Value => CamSystemData.CamParams.v1540_CamState);

