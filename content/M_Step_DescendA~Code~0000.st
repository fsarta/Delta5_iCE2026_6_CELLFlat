// METHOD: M_Step_DescendAndPick
// DESCRIPTION: Lowers Z-axis to pick position and activates gripper.

// 1. Entry Action
IF NOT bStepInitialized THEN
    // Activate Gripper
    bActivateGripper1 := (iGripperForThisCycle = 0);
    bActivateGripper2 := (iGripperForThisCycle <> 0);
    
    stMoveOption.VelocityUnit := 2;
    stMoveOption.TrajectoryShape := 1;

    // Command Motion    
    THIS.M_Driver_Motion_Cmd(
         ActProdX_Pick, // fX
         ActProdY_Pick, // fY   
         DATA_Machine.Setting.Delta_Z_Pick, // fZ
         0.0, // fRx
         0.0, // fRy
         vFeedIn_FrameOffset[6], // fRz
         DATA_Machine.Setting.ZPickPlaceSpeed, // fVel
         DATA_Machine.Setting.MinRamp_Delta, // fAcc
         DATA_Machine.Setting.MinRamp_Delta, // fDec
         MC_CoordinateSystem#PCS, // eCoordSys
         MC_BufferMode#BlendingPrevious, // eBufferMode
         MC_TransitionMode#TMStartVelocity, // eTransMode
         1, // param
         100.0, // eTransParam
         stMoveOption, // stMoveOption
         TRUE // bExecute - Start Command
    );
    
    bStepInitialized := TRUE;
    M_Step_DescendAndPick := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic Check
M_Step_DescendAndPick := THIS.M_Driver_Motion_Check();

// 3. Exit Logic: Capture Conveyor Position
IF M_Step_DescendAndPick = E_StepStatus#ACTIVE OR M_Step_DescendAndPick = E_StepStatus#DONE THEN
    
    TempPosConv := DATA_FeedInAxis.Feedback.ActualPosition;
    
    M_Step_DescendAndPick := E_StepStatus#DONE;    
END_IF;