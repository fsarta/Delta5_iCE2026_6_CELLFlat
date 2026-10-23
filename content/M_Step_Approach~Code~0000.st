// METHOD M_Step_ApproachPick_Tracking : E_StepStatus

// 1. Entry Action: Trigger Movement
IF NOT bStepInitialized THEN
    
    stMoveOption.VelocityUnit := 2;     
    stMoveOption.TrajectoryShape := 1;
    
    // Call the Driver to Setup and Execute Block #1
    THIS.M_Driver_Motion_Cmd(
         ActProdX_Pick, // fX
         ActProdY_Pick, // fY   
         0.0, // fZ
         0.0, // fRx
         0.0, // fRy
         vFeedIn_FrameOffset[6], // fRz
         DATA_Machine.Setting.MinVelocity_Delta, // fVel
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
    M_Step_ApproachPick_Tracking := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic Check: Ask the Driver for current block status
M_Step_ApproachPick_Tracking := THIS.M_Driver_Motion_Check();

// 3. Exit Cleanup (If needed)
IF M_Step_ApproachPick_Tracking = E_StepStatus#ACTIVE THEN
     
    M_Step_ApproachPick_Tracking := E_StepStatus#DONE;
    
END_IF