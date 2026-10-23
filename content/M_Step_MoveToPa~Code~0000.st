// METHOD: M_Step_MoveToParking_AfterPick
// DESCRIPTION: Moves to intermediate parking position.

// 1. Entry Action
IF NOT bStepInitialized THEN

    stMoveOption.VelocityUnit := 2;
    stMoveOption.TrajectoryShape := 1;

    THIS.M_Driver_Motion_Cmd(
         FeedOut_FrameOffset.X, // fX
         FeedOut_FrameOffset.Y, // fY   
         MIN(FeedIn_FrameOffset.Z, FeedOut_FrameOffset.Z), // fZ
         0.0, // fRx
         0.0, // fRy
         -45.0, // fRz
         DATA_Machine.Setting.MinVelocity_Delta, // fVel
         DATA_Machine.Setting.MinRamp_Delta, // fAcc
         DATA_Machine.Setting.MinRamp_Delta, // fDec
         MC_CoordinateSystem#MCS, // eCoordSys
         MC_BufferMode#Aborting, // eBufferMode
         MC_TransitionMode#TMStartVelocity, // eTransMode
         1, // param
         100.0, // eTransParam
         stMoveOption, // stMoveOption
         TRUE // bExecute - Start Command
    );
    
    bStepInitialized := TRUE;
    M_Step_MoveToParking_AfterPick := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic Check
M_Step_MoveToParking_AfterPick := THIS.M_Driver_Motion_Check();

// 3. Exit Logic
IF M_Step_MoveToParking_AfterPick = E_StepStatus#ACTIVE THEN
    DATA_Machine.Status.InSyncPick_Delta := FALSE;
    
    M_Step_MoveToParking_AfterPick := E_StepStatus#DONE;
    
END_IF;