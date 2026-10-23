bDone  := FALSE;
bError := FALSE;

IF bExecute AND NOT bLastExecute THEN

    nGimbalCount := 0;
    oPosTable    := iPosTable;   

    // 1) Matrice di rotazione globale da applicare
    mGlobal := THIS.M_BuildRotMatrix(fDeltaRx, fDeltaRy, fDeltaRz);
    
    nLastIdx := TO_INT(SIZEOF(iPosTable.stEntry));
    FOR i := 0 TO nLastIdx-1 DO
        IF iPosTable.stEntry[i].bLastEntry THEN
            nLastIdx    := i;
            EXIT;
        END_IF
    END_FOR;

    // 2) Elaborazione di ogni punto
    FOR i := 0 TO nLastIdx DO

        // ── 2a. Rotazione della POSIZIONE (X,Y,Z) ─────────────
        vRelX := iPosTable.stEntry[i].aPosition[1] - fPivotX;
        vRelY := iPosTable.stEntry[i].aPosition[2] - fPivotY;
        vRelZ := iPosTable.stEntry[i].aPosition[3] - fPivotZ;

        // v_rot = mGlobal * v_rel
        vRotX := mGlobal[1]*vRelX + mGlobal[2]*vRelY + mGlobal[3]*vRelZ;
        vRotY := mGlobal[4]*vRelX + mGlobal[5]*vRelY + mGlobal[6]*vRelZ;
        vRotZ := mGlobal[7]*vRelX + mGlobal[8]*vRelY + mGlobal[9]*vRelZ;

        oPosTable.stEntry[i].aPosition[1] := vRotX + fPivotX;
        oPosTable.stEntry[i].aPosition[2] := vRotY + fPivotY;
        oPosTable.stEntry[i].aPosition[3] := vRotZ + fPivotZ;

        // ── 2b. Composizione dell'ORIENTAMENTO (Rx,Ry,Rz) ─────
        // R_combined = R_global * R_point
        mPoint    := THIS.M_BuildRotMatrix(
                        iPosTable.stEntry[i].aPosition[4],
                        iPosTable.stEntry[i].aPosition[5],
                        iPosTable.stEntry[i].aPosition[6]);

        mCombined := THIS.M_MatMul(mGlobal, mPoint);

        // Estrazione angoli dalla matrice combinata
        stEuler   := THIS.M_MatToEuler(mCombined);

        oPosTable.stEntry[i].aPosition[4] := stEuler.fRx;
        oPosTable.stEntry[i].aPosition[5] := stEuler.fRy;
        oPosTable.stEntry[i].aPosition[6] := stEuler.fRz;

        IF stEuler.bGimbalLock THEN
            nGimbalCount := nGimbalCount + 1;
            bError       := TRUE;
        END_IF

    END_FOR;

    bDone := TRUE;

END_IF;

bLastExecute := bExecute;