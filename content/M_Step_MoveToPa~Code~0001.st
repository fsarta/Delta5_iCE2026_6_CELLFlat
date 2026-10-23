// METHOD: M_Step_MoveToParking_AfterPlace
// DESCRIPTION: Moves to intermediate parking position.

// 1. Entry
IF NOT bStepInitialized THEN

    stMoveOption.VelocityUnit := 2;
    stMoveOption.TrajectoryShape := 1;
    
    THIS.M_Driver_Motion_Cmd(
         DELTA.Machine.ActualPos[1]-20.0,//vFeedIn_FrameOffset[1], // fX
         DELTA.Machine.ActualPos[2],//vFeedIn_FrameOffset[2], // fY
         MIN(FeedIn_FrameOffset.Z, FeedOut_FrameOffset.Z), // fZ
         0.0, // fRx
         0.0, // fRy
         DELTA.Machine.ActualPos[6], // fRz
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
    M_Step_MoveToParking_AfterPlace := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic
M_Step_MoveToParking_AfterPlace := THIS.M_Driver_Motion_Check();

// 3. Exit
IF M_Step_MoveToParking_AfterPlace = E_StepStatus#ACTIVE THEN
    DATA_Machine.Status.InSyncPlace_Delta := FALSE;
    
    M_Step_MoveToParking_AfterPlace := E_StepStatus#DONE;
END_IF;