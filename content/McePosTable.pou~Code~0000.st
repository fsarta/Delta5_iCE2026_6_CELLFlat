(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTable
 * Version            : 1.0.0
 * Date               : 2026-03-17
 * Author             : FraSar
 * Family             : McePosTable
 * 
 * -----------------------------------------------------------------------------
 * Performed a trajectory stored in a PosTable
 * -----------------------------------------------------------------------------
 *)
 
 posTable := posTable_In;
 io := io_In;

// =============================================================================
// 1. INITIALIZATION & EDGE DETECTION
// =============================================================================
// Calculate table boundaries safely
nPosTableSize := TO_INT(SIZEOF(posTable) / SIZEOF(posTable.stEntry[0]));
io.nIndex := LIMIT(0, io.nIndex, nPosTableSize - 1);
io.nLoadIndex := LIMIT(0, io.nLoadIndex, nPosTableSize - 1);

// Generate pulses (One-Shots) for inputs
bOsrStep := io.bStep AND NOT aOneShots[0];
aOneShots[0] := io.bStep;

bOsrSystemReady := io.bSystemReady AND NOT aOneShots[1];
aOneShots[1] := io.bSystemReady;

bOsrRecalcQA := io.bRecalcQA AND NOT aOneShots[2];
aOneShots[2] := io.bRecalcQA;

bOsfRun := NOT io.bRun AND aOneShots[3];
aOneShots[3] := io.bRun;

// Search for the last entry of PosTable (either bLastEntry or last not skipped entry)
nLastEntryIndex := 0;
FOR i := 0 TO nPosTableSize - 1 DO
  IF posTable.stEntry[i].bLastEntry OR NOT posTable.stEntry[i].bSkipEntry THEN
    nLastEntryIndex := i;
    IF posTable.stEntry[i].bLastEntry THEN
      EXIT;
    END_IF;
  END_IF;
END_FOR;

bLastEntryInProcess := posTable.stEntry[io.nIndex].bLastEntry OR (io.nIndex = nLastEntryIndex);
bOsfLastMoveInProcess := NOT bLastEntryInProcess AND aOneShots[4];
aOneShots[4] := bLastEntryInProcess;

bOsrRun := io.bRun AND NOT aOneShots[5];
aOneShots[5] := io.bRun;

// Count the number of cycles
IF bOsfLastMoveInProcess AND io.bBusy THEN
  io.nCycleNr := io.nCycleNr + 1;
END_IF;

bStopAfterLastEntry := ((io.nCycleNr + 1) >= io.nNrOfCycles) AND NOT (io.nNrOfCycles = 0);

// Check if next conditions are valid to update the Queue array (QA)
bUpdateQA := FALSE;
IF io.bRun AND (io.nMode = PT_MODE_0) AND (nQA < QA_MAX) THEN
  nNextValidLoadIndex := THIS.McePosTableFindEntry(io.nLoadIndex, 1, nPosTableSize, NOT(bStopAfterLastEntry));
  IF nNextValidLoadIndex >= 0 AND posTable.stEntry[io.nLoadIndex].nActionID = 0 THEN
    stConditionResult := THIS.McePosTableCheckConditions(nNextValidLoadIndex, nPosTableSize, io.aConditions);
    bUpdateQA := stConditionResult.bConditionsOk;
  END_IF;
END_IF;

bWaiting := FALSE;

bAllowQueuing := (io.nMode = PT_MODE_0) AND io.bRun;

Out := MEMORY_SET(stConditionResult, 0, BYTE#0, SIZEOF(stConditionResult));

// clear Enable signals but keep signals enabled if an error occurs
IF io.nSmPosTable <> 99 THEN
  Out := MEMORY_SET(aEnable, 0, BYTE#0, SIZEOF(aEnable));
END_IF;
io.bError := FALSE;

// Update QA
bUpdateQA := bUpdateQA OR bOsrRecalcQA OR (bOsrSystemReady AND io.nSmPosTable >= 10 AND io.nSmPosTable < 30);
IF bUpdateQA THEN
  bFirstMove := bFirstMove OR bOsrSystemReady OR bOsrRun;
  THIS.McePosTableRecalcQA(bAllowQueuing, bFirstMove, bStopAfterLastEntry, io.aConditions, io.nLoadIndex);
END_IF;

// -----------------------------------------------------------------------------
// state machine 1: Motion
// -----------------------------------------------------------------------------
CASE io.nSmPosTable OF
  // -------------------------------------
  // state 0 - idle, not ready for start
  // -------------------------------------
  0:
    IF bOsfRun THEN 
      io.nSmPosTable := 60;
    ELSIF io.bSystemReady THEN
      io.nErrorCode := 0;
      io.nSmPosTable := 1;
    END_IF;

  // -------------------------------------
  // state 1 - idle, ready for start
  // -------------------------------------
  1:
    IF NOT io.bSystemReady THEN 
      io.nSmPosTable := 0;
    ELSIF bOsfRun THEN 
      io.nSmPosTable := 60;
    ELSIF io.bSystemReady THEN
        
      bWaiting := (io.nMode = PT_MODE_2) AND io.bRun;
      bFirstMove := TRUE;

      IF ((io.nMode <> PT_MODE_2 AND io.bRun) OR (io.nMode = PT_MODE_2 AND bOsrStep AND io.bRun)) THEN
        io.nLoadIndex := io.nIndex;
        THIS.McePosTableUpdateIndex(bAllowQueuing, bFirstMove, bStopAfterLastEntry, io.aConditions, io.nLoadIndex);
        
        IF io.nIndex < 0 THEN
          io.nIndex := 0;
          io.nSmPosTable := 50;
        ELSE
          stConditionResult := THIS.McePosTableCheckConditions(io.nIndex, nPosTableSize, io.aConditions);
          IF NOT stConditionResult.bConditionsOk THEN 
            io.nSmPosTable := 5; 
          ELSE 
            io.nSmPosTable := 10; 
          END_IF;
        END_IF;
      END_IF;
    END_IF;

  // -------------------------------------
  // state 5 - wait for conditions
  // -------------------------------------
  5:
    IF NOT io.bRun THEN 
      io.nSmPosTable := 50;
    ELSIF io.bSystemReady THEN
      stConditionResult := THIS.McePosTableCheckConditions(io.nIndex, nPosTableSize, io.aConditions);
      
      IF stConditionResult.bConditionsOk AND ((io.nMode <> PT_MODE_2 AND io.bRun) OR (bOsrStep OR (nQA > 0))) THEN
        bWaitBeforeNextEntry := FALSE;
        THIS.McePosTableRecalcQA(bAllowQueuing, bFirstMove, bStopAfterLastEntry, io.aConditions, io.nLoadIndex);
        io.nSmPosTable := 10;
      END_IF;
    END_IF;

  // -------------------------------------
  // state 10..29 - handle motion commands
  // -------------------------------------
  10..29:
    FOR i := 0 TO QA_MAX DO
      nInstanceNumber[i] := io.nSmPosTable + TO_INT(i) - 10;
      IF nInstanceNumber[i] > QA_MAX THEN 
        nInstanceNumber[i] := nInstanceNumber[i] - (QA_MAX + 1); 
      END_IF;
    END_FOR;

    IF NOT io.bRun AND ((io.nAbortingMode = 1) OR NOT io.bSystemReady) THEN 
      io.nSmPosTable := 50;
    ELSIF io.bSystemReady THEN
      // start this motion
      aEnable[nInstanceNumber[0]] := TRUE;

      // queue next motions
      FOR i := 1 TO QA_MAX DO
        aEnable[nInstanceNumber[i]] := (aMoveCmd[nInstanceNumber[i-1]].bDone OR aMoveCmd[nInstanceNumber[i-1]].bActive) AND (nQA >= i);
      END_FOR;

      // motion completed (Done = motion reached end of trajectory)
      IF aMoveCmd[nInstanceNumber[0]].bDone THEN
        IF NOT io.bRun AND (nQA = 0) THEN 
          io.nSmPosTable := 50;
        ELSIF bStopEntry THEN 
          io.nSmPosTable := 30; // Need to stop and do an action
        ELSIF bLastEntry THEN 
          io.nSmPosTable := 40; // End of path
        ELSE
          bWaiting := (io.nMode = PT_MODE_2);
          IF (io.nMode <> PT_MODE_2 AND io.bRun) OR (bOsrStep OR (nQA > 0)) THEN
            aEnable[nInstanceNumber[0]] := FALSE;
            IF bWaitBeforeNextEntry THEN 
              io.nSmPosTable := 5; 
            ELSE 
              io.nSmPosTable := nInstanceNumber[1] + 10; 
            END_IF;
            THIS.McePosTableUpdateIndex(bAllowQueuing, bFirstMove, bStopAfterLastEntry, io.aConditions, io.nLoadIndex);
          END_IF;
        END_IF;
      END_IF;
    END_IF;

  // -------------------------------------
  // state 30 - waiting before performing action at standstill
  // -------------------------------------
  30:
    IF NOT io.bRun THEN 
      io.nSmPosTable := 50;
    ELSIF io.bSystemReady THEN
      bWaiting := (io.nMode = PT_MODE_2);
      IF (io.nMode <> PT_MODE_2) OR bOsrStep THEN 
        io.nSmPosTable := 31; 
      END_IF;
    END_IF;

  // -------------------------------------
  // state 31 - perform action at standstill
  // -------------------------------------
  31:
    IF NOT io.bRun THEN 
     io.nSmPosTable := 50;
    ELSIF io.bSystemReady THEN
      bWaiting := (bDefaultActionDone OR io.bCustomActionDone) AND (io.nMode = PT_MODE_2);
      bCustomActionDone := io.bCustomActionDone AND (io.nActionID > RESERVED_ACTIONID_UBOUND);
      IF bDefaultActionDone OR bCustomActionDone THEN 
        io.nSmPosTable := 32; 
      END_IF;
    END_IF;

  // -------------------------------------
  // state 32 - waiting after performing action
  // -------------------------------------
  32:
    IF NOT io.bRun THEN 
      io.nSmPosTable := 50;
    ELSIF io.bSystemReady THEN
      bWaiting := (io.nMode = PT_MODE_2);
      IF (io.nMode <> PT_MODE_2) OR bOsrStep THEN
        IF bLastEntry AND (io.nNrOfCycles - io.nCycleNr <= 1) THEN 
          io.nSmPosTable := 40;
        ELSE
          IF bWaitBeforeNextEntry THEN 
            io.nSmPosTable := 5; 
          ELSE 
            io.nSmPosTable := 10; 
          END_IF;
          THIS.McePosTableUpdateIndex(bAllowQueuing, bFirstMove, bStopAfterLastEntry, io.aConditions, io.nLoadIndex);
        END_IF;
      END_IF;
    END_IF;

  // -------------------------------------
  // state 40 - cycle completed
  // -------------------------------------
  40:
    io.nCycleNr := io.nCycleNr + 1;
    IF NOT io.bRun THEN 
      io.nSmPosTable := 50;
    ELSIF ((io.nCycleNr < io.nNrOfCycles) OR (io.nNrOfCycles = 0)) AND (io.nMode <> PT_MODE_2) THEN
      IF bWaitBeforeNextEntry THEN 
        io.nSmPosTable := 5; 
      ELSE 
        io.nSmPosTable := 10; 
      END_IF;
      THIS.McePosTableUpdateIndex(bAllowQueuing, bFirstMove, FALSE, io.aConditions, io.nLoadIndex);
    ELSE 
      io.nSmPosTable := 50;
    END_IF;

  // -------------------------------------
  // state 50 - wait at the end of cycle
  // -------------------------------------
  50: 
    IF NOT io.bRun THEN 
      io.nSmPosTable := 60; 
    END_IF;
    
  // -------------------------------------
  // state 60 - reset cycle
  // -------------------------------------
  60:
    io.nIndex := 0;
    io.nLoadIndex := 0;
    io.nCycleNr := 0;
    io.nSmPosTable := 0;

  // -------------------------------------
  // state 99 - state machine error
  // -------------------------------------
  99:
    io.bError := TRUE;
    IF NOT io.bRun THEN
      Out := MEMORY_SET(aEnable, 0, BYTE#0, SIZEOF(aEnable));
      io.nSmPosTable := 60;
    END_IF;
END_CASE;

// -----------------------------------------------------------------------------
// actions
// -----------------------------------------------------------------------------
io.bActionStart := (io.nSmPosTable = 31);
io.nActionID := posTable.stEntry[io.nIndex].nActionID;

IF io.bActionStart THEN
  // map PosTable actions
  CASE io.nActionID OF
    0: //ACTIONID_NO_ACTION:
      bDefaultActionDone := TRUE;
    1: //ACTIONID_WAIT_ONE_SCAN:
      bDefaultActionDone := TRUE;
    2: //ACTIONID_WAIT_STEP:
      bWaiting := TRUE; 
      bDefaultActionDone := bOsrStep;
  ELSE 
    bDefaultActionDone := io.nActionID <= RESERVED_ACTIONID_UBOUND;
  END_CASE;
ELSE 
  bDefaultActionDone := FALSE; 
END_IF;

// -----------------------------------------------------------------------------
// state monitoring
// Waiting condition is used to exclude the time where it is waiting for the Step button
// -----------------------------------------------------------------------------
io.nStateTime := THIS.MceStateMonitoring(io.nSmPosTable, bWaiting OR NOT io.bSystemReady OR (io.nSmPosTable >= 40) OR (io.nSmPosTable < 10), stStateMonitoringData);

// -----------------------------------------------------------------------------
// process move commands
// -----------------------------------------------------------------------------
FOR i := 0 TO QA_MAX DO
  aOsrEnable[i] := aEnable[i] AND NOT aOneShots[i+6];
  aOneShots[i+6] := aEnable[i];
  
  IF aOsrEnable[i] THEN
    THIS.McePosTableUpdateLoadIndex(bAllowQueuing, bFirstMove, ((io.nCycleNr + 1) >= io.nNrOfCycles) AND NOT (io.nNrOfCycles = 0), io.nIndex, io.aConditions);
    
    // ROUTE TO EXPLICIT FB INSTANCES
    CASE i OF
      // -----------------------------------------------------------------------
      // INSTANCE 0
      // -----------------------------------------------------------------------
      0:
          fbMoveLinearAbsolute_0.Position     := posTable.stEntry[io.nLoadIndex].aPosition;
          fbMoveLinearAbsolute_0.Velocity     := posTable.stEntry[io.nLoadIndex].fSpeed;
          fbMoveLinearAbsolute_0.Acceleration := posTable.stEntry[io.nLoadIndex].nAcc;
          fbMoveLinearAbsolute_0.Deceleration := posTable.stEntry[io.nLoadIndex].nDec;
          fbMoveLinearAbsolute_0.MoveOptions  := posTable.stEntry[io.nLoadIndex].stMoveOptions;
          fbMoveLinearAbsolute_0.CoordSystem  := posTable.stEntry[io.nLoadIndex].eCoordSystem;
          fbMoveLinearAbsolute_0.BufferMode   := posTable.stEntry[io.nLoadIndex].nBlendFactor;
          fbMoveLinearAbsolute_0.TransitionMode := posTable.stEntry[io.nLoadIndex].nTransitionMode;
          fbMoveLinearAbsolute_0.TransitionParameter := posTable.stEntry[io.nLoadIndex].aTransitionParam;

      // -----------------------------------------------------------------------
      // INSTANCE 1
      // -----------------------------------------------------------------------
      1:
          fbMoveLinearAbsolute_1.Position     := posTable.stEntry[io.nLoadIndex].aPosition;
          fbMoveLinearAbsolute_1.Velocity     := posTable.stEntry[io.nLoadIndex].fSpeed;
          fbMoveLinearAbsolute_1.Acceleration := posTable.stEntry[io.nLoadIndex].nAcc;
          fbMoveLinearAbsolute_1.Deceleration := posTable.stEntry[io.nLoadIndex].nDec;
          fbMoveLinearAbsolute_1.MoveOptions  := posTable.stEntry[io.nLoadIndex].stMoveOptions;
          fbMoveLinearAbsolute_1.CoordSystem  := posTable.stEntry[io.nLoadIndex].eCoordSystem;          
          fbMoveLinearAbsolute_1.BufferMode   := posTable.stEntry[io.nLoadIndex].nBlendFactor;
          fbMoveLinearAbsolute_1.TransitionMode := posTable.stEntry[io.nLoadIndex].nTransitionMode;
          fbMoveLinearAbsolute_1.TransitionParameter := posTable.stEntry[io.nLoadIndex].aTransitionParam;   

      // -----------------------------------------------------------------------
      // INSTANCE 2
      // -----------------------------------------------------------------------
      2:
          fbMoveLinearAbsolute_2.Position     := posTable.stEntry[io.nLoadIndex].aPosition;
          fbMoveLinearAbsolute_2.Velocity     := posTable.stEntry[io.nLoadIndex].fSpeed;
          fbMoveLinearAbsolute_2.Acceleration := posTable.stEntry[io.nLoadIndex].nAcc;
          fbMoveLinearAbsolute_2.Deceleration := posTable.stEntry[io.nLoadIndex].nDec;
          fbMoveLinearAbsolute_2.MoveOptions  := posTable.stEntry[io.nLoadIndex].stMoveOptions;
          fbMoveLinearAbsolute_2.CoordSystem  := posTable.stEntry[io.nLoadIndex].eCoordSystem;                    
          fbMoveLinearAbsolute_2.BufferMode   := posTable.stEntry[io.nLoadIndex].nBlendFactor;
          fbMoveLinearAbsolute_2.TransitionMode := posTable.stEntry[io.nLoadIndex].nTransitionMode;
          fbMoveLinearAbsolute_2.TransitionParameter := posTable.stEntry[io.nLoadIndex].aTransitionParam;;
        
    END_CASE;

    bFirstMove := FALSE;
  END_IF;

  // ---------------------------------------------------------------------------
  // ENABLE LOGIC & FB EXECUTION (PLCopen: Execute on rising edge)
  // ---------------------------------------------------------------------------
  CASE i OF
    0:
      fbMoveLinearAbsolute_0.Execute   := aEnable[0];

      // TODO: Call actual PLCopen FB instances here
      // fbMoveAbsolute_0(AxesGroup := AxesGroup);
      
      fbMoveLinearAbsolute_0(AxesGroup := AxesGroup);

      // Read Status - PLCopen standard
      aMoveCmd[0].bDone           := fbMoveLinearAbsolute_0.Done;
      aMoveCmd[0].bBusy           := fbMoveLinearAbsolute_0.Busy;
      aMoveCmd[0].bActive         := fbMoveLinearAbsolute_0.Active;
      aMoveCmd[0].bCommandAborted := fbMoveLinearAbsolute_0.CommandAborted;
      aMoveCmd[0].bError          := fbMoveLinearAbsolute_0.Error;
      aMoveCmd[0].nErrorID        := fbMoveLinearAbsolute_0.ErrorID;

    1:
      fbMoveLinearAbsolute_1.Execute   := aEnable[1];

      // TODO: Call actual PLCopen FB instances here

      fbMoveLinearAbsolute_1(AxesGroup := AxesGroup);
      
      aMoveCmd[1].bDone           := fbMoveLinearAbsolute_1.Done;
      aMoveCmd[1].bBusy           := fbMoveLinearAbsolute_1.Busy;
      aMoveCmd[1].bActive         := fbMoveLinearAbsolute_1.Active;
      aMoveCmd[1].bCommandAborted := fbMoveLinearAbsolute_1.CommandAborted;
      aMoveCmd[1].bError          := fbMoveLinearAbsolute_1.Error;
      aMoveCmd[1].nErrorID        := fbMoveLinearAbsolute_1.ErrorID;

    2:
      fbMoveLinearAbsolute_2.Execute   := aEnable[2];

      // TODO: Call actual PLCopen FB instances here

      fbMoveLinearAbsolute_2(AxesGroup := AxesGroup);
      
      aMoveCmd[2].bDone           := fbMoveLinearAbsolute_2.Done;
      aMoveCmd[2].bBusy           := fbMoveLinearAbsolute_2.Busy;
      aMoveCmd[2].bActive         := fbMoveLinearAbsolute_2.Active;
      aMoveCmd[2].bCommandAborted := fbMoveLinearAbsolute_2.CommandAborted;
      aMoveCmd[2].bError          := fbMoveLinearAbsolute_2.Error;
      aMoveCmd[2].nErrorID        := fbMoveLinearAbsolute_2.ErrorID;

  END_CASE;
END_FOR;

// -----------------------------------------------------------------------------
// map nPercentComplete (simplified - PLCopen doesn't have PercentComplete)
// -----------------------------------------------------------------------------
CASE io.nSmPosTable OF
  10..29: 
    IF aMoveCmd[nInstanceNumber[0]].bActive THEN
      io.nPercentComplete := 50; // placeholder: active motion in progress
    ELSIF aMoveCmd[nInstanceNumber[0]].bDone THEN
      io.nPercentComplete := 100;
    ELSE
      io.nPercentComplete := 0;
    END_IF;
  30..50: 
    io.nPercentComplete := 100;
  ELSE    
    io.nPercentComplete := 0;
END_CASE;


// -----------------------------------------------------------------------------
// PosTable status
// -----------------------------------------------------------------------------
io.bWaitForStep := bWaiting;
io.bDone := (io.nSmPosTable = 50);
io.bIdle := (io.nSmPosTable < 5);
io.bBusy := (io.nSmPosTable >= 5 AND io.nSmPosTable < 50);
io.aMissingConditions := stConditionResult.aMissingConditions;

// Check errors from all instances
bError := FALSE;

// Check errors for Instance 0
bError := bError OR aMoveCmd[0].bError;

// Check errors for Instance 1
bError := bError OR aMoveCmd[1].bError;

// Check errors for Instance 2
bError := bError OR aMoveCmd[2].bError;

IF bError AND NOT (io.nSmPosTable = 99) THEN
  io.nErrorCode := 1000 + INT_TO_UDINT(io.nSmPosTable);
  io.nSmPosTable := 99;
END_IF;

posTable_In := posTable;
io_In := io;