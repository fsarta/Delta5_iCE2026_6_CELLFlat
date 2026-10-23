// METHOD: M_Step_MoveToParking_SafePosition

// 1. Entry
IF NOT bStepInitialized THEN

    stMoveOption.VelocityUnit := 2;
    stMoveOption.TrajectoryShape := 1;

    THIS.M_Driver_Motion_Cmd(
         0.0, // fX
         0.0, // fY   
         720.0, // fZ
         0.0, // fRx
         0.0, // fRy
         0.0, // fRz
         DATA_Machine.Setting.MinVelocity_Delta, // fVel
         DATA_Machine.Setting.MinRamp_Delta, // fAcc
         DATA_Machine.Setting.MinRamp_Delta, // fDec
         MC_CoordinateSystem#MCS, // eCoordSys
         MC_BufferMode#BlendingPrevious, // eBufferMode
         MC_TransitionMode#TMStartVelocity, // eTransMode
         1, // param
         100.0, // eTransParam
         stMoveOption, // stMoveOption
         TRUE // bExecute - Start Command
    );
    
    bStepInitialized := TRUE;
    M_Step_MoveToParking_SafePosition := E_StepStatus#BUSY;
END_IF;

// 2. Cyclic
M_Step_MoveToParking_SafePosition := THIS.M_Driver_Motion_Check();

IF M_Step_MoveToParking_SafePosition = E_StepStatus#DONE THEN
     THIS.M_Driver_Motion_Cmd(
        0.0, // fX
        0.0, // fY
        0.0, // fZ
        0.0, // fRx
        0.0, // fRy
        0.0, // fRz
        0.0, // fVel
        0.0, // fAcc
        0.0, // fDec
        MC_CoordinateSystem#PCS, // eCoordSys
        MC_BufferMode#BlendingPrevious, // eBufferMode
        MC_TransitionMode#TMStartVelocity, // eTransMode
        1, // param
        0.0, // eTransParam
        stMoveOption, // stMoveOption
        FALSE // bExecute
    ); 
END_IF;