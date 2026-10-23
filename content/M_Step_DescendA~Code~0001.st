// METHOD: M_Step_DescendAndPlace

// 1. Entry
IF NOT bStepInitialized THEN

    stMoveOption.VelocityUnit := 2;   
    stMoveOption.TrajectoryShape := 1;

    THIS.M_Driver_Motion_Cmd(
         ActProdX_Place, // fX
         ActProdY_Place, // fY   
         DATA_Machine.Setting.Delta_Z_Place, // fZ
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
         TRUE // bExecute - Start Command
    );

    bStepInitialized := TRUE;
    M_Step_DescendAndPlace := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic
M_Step_DescendAndPlace := THIS.M_Driver_Motion_Check();

// 3. Exit Logic
IF M_Step_DescendAndPlace = E_StepStatus#ACTIVE OR M_Step_DescendAndPlace = E_StepStatus#DONE THEN
    
    TempPosConv := DATA_FeedOutAxis.Feedback.ActualPosition;
        
    M_Step_DescendAndPlace := E_StepStatus#DONE;
END_IF;