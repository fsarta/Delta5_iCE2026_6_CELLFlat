// --- POINT 0: Start from the centre of the base (Y = -41.5) ---
posTable.stEntry[0].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[0].aPosition[1]  := 0.0;     // X (Centro)
posTable.stEntry[0].aPosition[2]  := -41.5;   // Y (Fondo della bottiglia)
posTable.stEntry[0].aPosition[3]  := 0.0;
posTable.stEntry[0].aPosition[4]  := 0.0;
posTable.stEntry[0].aPosition[5]  := 0.0;
posTable.stEntry[0].aPosition[6]  := 0.0;
posTable.stEntry[0].fSpeed        := 50.0;
posTable.stEntry[0].nAcc          := 500.0;
posTable.stEntry[0].nDec          := 500.0;
posTable.stEntry[0].nBlendFactor  := MC_BufferMode#BlendingLow; 
posTable.stEntry[0].nActionID     := 0;
posTable.stEntry[0].stMoveOptions.VelocityUnit          := 0; 
posTable.stEntry[0].stMoveOptions.ProfileUnit           := 0; 
posTable.stEntry[0].stMoveOptions.TrajectoryShape       := 1; 
posTable.stEntry[0].stMoveOptions.AlternateVelocity     := 1440.0;
posTable.stEntry[0].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[0].nTransitionMode                     := 3; 
posTable.stEntry[0].aTransitionParam[3]                 := 0.0; 

posTable.stEntry[0].bSkipEntry     := FALSE;
posTable.stEntry[0].bLastEntry     := FALSE;

// --- POINT 1: Move to the bottom-right corner ---
posTable.stEntry[1].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[1].aPosition[1]  := 16.0;    // X
posTable.stEntry[1].aPosition[2]  := -41.5;   // Y
posTable.stEntry[1].aPosition[3]  := 0.0; 
posTable.stEntry[1].aPosition[4] := 0.0; 
posTable.stEntry[1].aPosition[5] := 0.0; 
posTable.stEntry[1].aPosition[6] := 0.0;
posTable.stEntry[1].fSpeed := 50.0; 
posTable.stEntry[1].nAcc := 500.0; 
posTable.stEntry[1].nDec := 500.0; 
posTable.stEntry[1].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[1].nActionID := 0;
posTable.stEntry[1].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[1].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[1].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[1].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[1].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[1].nTransitionMode                     := 3; 
posTable.stEntry[1].aTransitionParam[3]                 := 0.0; 

posTable.stEntry[1].bSkipEntry     := FALSE;
posTable.stEntry[1].bLastEntry     := FALSE;

// --- POINT 2: Start of the right shoulder (Y was 53, now 53 – 41.5 = 11.5) ---
posTable.stEntry[2].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[2].aPosition[1]  := 16.0;    // X
posTable.stEntry[2].aPosition[2]  := 11.5;    // Y
posTable.stEntry[2].aPosition[3]  := 0.0; 
posTable.stEntry[2].aPosition[4] := 0.0; 
posTable.stEntry[2].aPosition[5] := 0.0; 
posTable.stEntry[2].aPosition[6] := 0.0;
posTable.stEntry[2].fSpeed := 50.0; 
posTable.stEntry[2].nAcc := 500.0; 
posTable.stEntry[2].nDec := 500.0; 
posTable.stEntry[2].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[2].nActionID := 0;
posTable.stEntry[2].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[2].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[2].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[2].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[2].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[2].nTransitionMode                     := 3; 
posTable.stEntry[2].aTransitionParam[3]                 := 0.0; // Raccordo spalla

posTable.stEntry[2].bSkipEntry     := FALSE;
posTable.stEntry[2].bLastEntry     := FALSE;

// --- POINT 3: Base of the right neck (Y was 74, now 74 – 41.5 = 32.5) ---
posTable.stEntry[3].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[3].aPosition[1]  := 4.0;     // X 
posTable.stEntry[3].aPosition[2]  := 32.5;    // Y
posTable.stEntry[3].aPosition[3]  := 0.0; 
posTable.stEntry[3].aPosition[4] := 0.0; 
posTable.stEntry[3].aPosition[5] := 0.0; 
posTable.stEntry[3].aPosition[6] := 0.0;
posTable.stEntry[3].fSpeed := 50.0; 
posTable.stEntry[3].nAcc := 500.0; 
posTable.stEntry[3].nDec := 500.0; 
posTable.stEntry[3].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[3].nActionID := 0;
posTable.stEntry[3].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[3].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[3].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[3].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[3].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[3].nTransitionMode                     := 3; 
posTable.stEntry[3].aTransitionParam[3]                 := 6.0; 

posTable.stEntry[3].bSkipEntry     := FALSE;
posTable.stEntry[3].bLastEntry     := FALSE;

// --- POINT 4: Right upper lip (Y was 83, now 83 – 41.5 = 41.5) ---
posTable.stEntry[4].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[4].aPosition[1]  := 5.0;     // X 
posTable.stEntry[4].aPosition[2]  := 41.5;    // Y (Cima assoluta)
posTable.stEntry[4].aPosition[3]  := 0.0; 
posTable.stEntry[4].aPosition[4] := 0.0; 
posTable.stEntry[4].aPosition[5] := 0.0; 
posTable.stEntry[4].aPosition[6] := 0.0;
posTable.stEntry[4].fSpeed := 50.0; 
posTable.stEntry[4].nAcc := 500.0; 
posTable.stEntry[4].nDec := 500.0; 
posTable.stEntry[4].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[4].nActionID := 0;
posTable.stEntry[4].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[4].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[4].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[4].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[4].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[4].nTransitionMode                     := 3; 
posTable.stEntry[4].aTransitionParam[3]                 := 4.0; 

posTable.stEntry[4].bSkipEntry     := FALSE;
posTable.stEntry[4].bLastEntry     := FALSE;

// --- POINT 5: Left upper lip ---
posTable.stEntry[5].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[5].aPosition[1]  := -5.0;    // X
posTable.stEntry[5].aPosition[2]  := 41.5;    // Y
posTable.stEntry[5].aPosition[3]  := 0.0; 
posTable.stEntry[5].aPosition[4] := 0.0; 
posTable.stEntry[5].aPosition[5] := 0.0; 
posTable.stEntry[5].aPosition[6] := 0.0;
posTable.stEntry[5].fSpeed := 50.0; 
posTable.stEntry[5].nAcc := 500.0; 
posTable.stEntry[5].nDec := 500.0; 
posTable.stEntry[5].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[5].nActionID := 0;
posTable.stEntry[5].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[5].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[5].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[5].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[5].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[5].nTransitionMode                     := 3; 
posTable.stEntry[5].aTransitionParam[3]                 := 1.0; 

posTable.stEntry[5].bSkipEntry     := FALSE;
posTable.stEntry[5].bLastEntry     := FALSE;

// --- POINT 6: Left side of the neck ---
posTable.stEntry[6].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[6].aPosition[1]  := -4.0;    // X
posTable.stEntry[6].aPosition[2]  := 32.5;    // Y
posTable.stEntry[6].aPosition[3]  := 0.0; 
posTable.stEntry[6].aPosition[4] := 0.0; 
posTable.stEntry[6].aPosition[5] := 0.0; 
posTable.stEntry[6].aPosition[6] := 0.0;
posTable.stEntry[6].fSpeed := 50.0; 
posTable.stEntry[6].nAcc := 500.0; 
posTable.stEntry[6].nDec := 500.0; 
posTable.stEntry[6].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[6].nActionID := 0;
posTable.stEntry[6].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[6].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[6].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[6].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[6].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[6].nTransitionMode                     := 3; 
posTable.stEntry[6].aTransitionParam[3]                 := 1.0; 

posTable.stEntry[6].bSkipEntry     := FALSE;
posTable.stEntry[6].bLastEntry     := FALSE;

// --- POINT 7: Start at the left shoulder ---
posTable.stEntry[7].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[7].aPosition[1]  := -16.0;   // X
posTable.stEntry[7].aPosition[2]  := 11.5;    // Y
posTable.stEntry[7].aPosition[3]  := 0.0; 
posTable.stEntry[7].aPosition[4] := 0.0; 
posTable.stEntry[7].aPosition[5] := 0.0; 
posTable.stEntry[7].aPosition[6] := 0.0;
posTable.stEntry[7].fSpeed := 50.0; 
posTable.stEntry[7].nAcc := 500.0; 
posTable.stEntry[7].nDec := 500.0; 
posTable.stEntry[7].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[7].nActionID := 0;
posTable.stEntry[7].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[7].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[7].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[7].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[7].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[7].nTransitionMode                     := 3; 
posTable.stEntry[7].aTransitionParam[3]                 := 4.0; 

posTable.stEntry[7].bSkipEntry     := FALSE;
posTable.stEntry[7].bLastEntry     := FALSE;

// --- POINT 8: Bottom left corner ---
posTable.stEntry[8].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[8].aPosition[1]  := -16.0;   // X
posTable.stEntry[8].aPosition[2]  := -41.5;   // Y
posTable.stEntry[8].aPosition[3]  := 0.0; 
posTable.stEntry[8].aPosition[4] := 0.0; 
posTable.stEntry[8].aPosition[5] := 0.0; 
posTable.stEntry[8].aPosition[6] := 0.0;
posTable.stEntry[8].fSpeed := 50.0; 
posTable.stEntry[8].nAcc := 500.0; 
posTable.stEntry[8].nDec := 500.0; 
posTable.stEntry[8].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[8].nActionID := 0;
posTable.stEntry[8].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[8].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[8].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[8].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[8].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[8].nTransitionMode                     := 3; 
posTable.stEntry[8].aTransitionParam[3]                 := 6.0; 

posTable.stEntry[8].bSkipEntry     := FALSE;
posTable.stEntry[8].bLastEntry     := FALSE;

// --- POINT 9: Return to the centre of the base to finish ---
posTable.stEntry[9].eCoordSystem  := MC_CoordinateSystem#PCS;
posTable.stEntry[9].aPosition[1]  := 0.0;     // X 
posTable.stEntry[9].aPosition[2]  := -41.5;   // Y
posTable.stEntry[9].aPosition[3]  := 0.0; 
posTable.stEntry[9].aPosition[4] := 0.0; 
posTable.stEntry[9].aPosition[5] := 0.0; 
posTable.stEntry[9].aPosition[6] := 0.0;
posTable.stEntry[9].fSpeed := 50.0; 
posTable.stEntry[9].nAcc := 500.0; 
posTable.stEntry[9].nDec := 500.0; 
posTable.stEntry[9].nBlendFactor := MC_BufferMode#BlendingLow; 
posTable.stEntry[9].nActionID := 0;
posTable.stEntry[9].stMoveOptions.VelocityUnit := 0; 
posTable.stEntry[9].stMoveOptions.ProfileUnit := 0; 
posTable.stEntry[9].stMoveOptions.TrajectoryShape := 1; 
posTable.stEntry[9].stMoveOptions.AlternateVelocity := 1440.0; 
posTable.stEntry[9].stMoveOptions.AlternateAcceleration := 12000.0;
posTable.stEntry[9].nTransitionMode                     := 3; 
posTable.stEntry[9].aTransitionParam[3]                 := 0.0;

posTable.stEntry[9].bSkipEntry     := FALSE;
posTable.stEntry[9].bLastEntry     := TRUE;