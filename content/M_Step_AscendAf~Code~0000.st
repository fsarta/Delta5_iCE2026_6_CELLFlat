// METHOD: M_Step_AscendAfterPick
// DESCRIPTION: Raises Z-axis after picking.

// 1. Entry Action
IF NOT bStepInitialized THEN
    
    stMoveOption.VelocityUnit := 2;
    stMoveOption.TrajectoryShape := 1;
    
    THIS.M_Driver_Motion_Cmd(
         ActProdX_Pick, // fX
         ActProdY_Pick, // fY   
         0.0, // fZ
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
    M_Step_AscendAfterPick := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic Check
M_Step_AscendAfterPick := THIS.M_Driver_Motion_Check();

// 3. Exit Logic
IF M_Step_AscendAfterPick = E_StepStatus#DONE THEN
    DATA_Machine.Status.InSyncPick_Delta := FALSE;
    
    M_Step_AscendAfterPick := E_StepStatus#DONE;
END_IF;