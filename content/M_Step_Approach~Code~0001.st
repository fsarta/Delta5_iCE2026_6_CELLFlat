// METHOD: M_Step_ApproachPlace_Tracking

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
         //ActProdRZ_Place, // fRz
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
    M_Step_ApproachPlace_Tracking := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic
M_Step_ApproachPlace_Tracking :=THIS. M_Driver_Motion_Check();

// 3. Exit Cleanup
IF M_Step_ApproachPlace_Tracking = E_StepStatus#ACTIVE THEN
    M_Step_ApproachPlace_Tracking := E_StepStatus#DONE;
END_IF;