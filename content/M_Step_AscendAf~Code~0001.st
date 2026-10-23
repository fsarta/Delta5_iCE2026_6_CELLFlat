// METHOD: M_Step_AscendAfterPlace

// 1. Entry
IF NOT bStepInitialized THEN
    
    stMoveOption.VelocityUnit := 2;
    stMoveOption.TrajectoryShape := 1;
    
    THIS.M_Driver_Motion_Cmd(
         ActProdX_Place, // fX
         ActProdY_Place, // fY   
         0.0, // fZ
         0.0, // fRx
         0.0, // fRy
         -45.0, // fRz
         DATA_Machine.Setting.ZPickPlaceSpeed, // fVel
         DATA_Machine.Setting.MinRamp_Delta, // fAcc
         DATA_Machine.Setting.MinRamp_Delta, // fDec
         MC_CoordinateSystem#PCS, // eCoordSys
         MC_BufferMode#BlendingPrevious, // eBufferMode
         MC_TransitionMode#TMStartVelocity, // eTransMode
         1, // param
         100.0, // eTransParam
         stMoveOption, // stMoveOption
         TRUE 
     );
    bStepInitialized := TRUE;
    M_Step_AscendAfterPlace := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic
M_Step_AscendAfterPlace := THIS.M_Driver_Motion_Check();

// 3. Exit
IF M_Step_AscendAfterPlace = E_StepStatus#DONE THEN
    DATA_Machine.Status.InSyncPlace_Delta := FALSE;
    
    TempPosConv := DATA_FeedOutAxis.Feedback.ActualPosition;

    M_Step_AscendAfterPlace := E_StepStatus#DONE;
END_IF;