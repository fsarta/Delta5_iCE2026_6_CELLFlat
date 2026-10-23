(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTableRemainingEntries
 * Version            : 0.3.0
 * Date               : 2024-05-15
 * Author             : Rioual
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * remaining (valid) PosTable entries
 * -----------------------------------------------------------------------------
 *)
 
 IF (index < 0) OR (index > (posTableSize - 1)) THEN
  McePosTableRemainingEntries := 0;
  RETURN;
END_IF;

nCount := - 1;

Out := MEMORY_SET(stConditionResult1, 0, BYTE#0, SIZEOF(stConditionResult1));

nNextLoadIndex := THIS.McePosTableFindEntry(loadIndex, 1, posTableSize, rollOver);
bWaitForConditions := index = nNextLoadIndex;

// -------------------------------------
// forward direction
// -------------------------------------
// search through the remaining part of the array
FOR i1 := index TO (posTableSize - 1) DO
  IF NOT posTable.stEntry[i1].bSkipEntry THEN
    nCount := nCount + 1;

    // check conditions for the next valid position
    nNextIndex := THIS.McePosTableFindEntry(i1, 1, posTableSize, rollOver);
    IF nNextIndex >= 0 AND NOT ((index <= nNextIndex AND nNextIndex <= loadIndex) OR (loadIndex < index AND index < nNextIndex AND NOT bWaitForConditions)) THEN
      stConditionResult1 := THIS.McePosTableCheckConditions(nNextIndex, posTableSize, conditions);
    ELSE
      stConditionResult1.bConditionsOk := TRUE;
    END_IF;

    // entry with standstill action or next entry with conditions, stop searching
    IF (posTable.stEntry[i1].nActionID > 0) OR NOT stConditionResult1.bConditionsOk THEN
      McePosTableRemainingEntries := nCount;
      RETURN;

    // last move, ignore further entries
    ELSIF posTable.stEntry[i1].bLastEntry THEN
      EXIT;
    END_IF;
  END_IF;
END_FOR;

// search through the first part of the array
IF rollOver THEN
  FOR i1 := 0 TO index DO
    IF NOT posTable.stEntry[i1].bSkipEntry THEN
      nCount := nCount + 1;

      // check conditions for the next valid position
      nNextIndex := THIS.McePosTableFindEntry(i1, 1, posTableSize, FALSE);
      IF nNextIndex >= 0 AND NOT ((index <= nNextIndex AND nNextIndex <= loadIndex) OR (loadIndex < index AND index < nNextIndex AND NOT bWaitForConditions)) THEN
        stConditionResult1 := THIS.McePosTableCheckConditions(nNextIndex, posTableSize, conditions);
      END_IF;

      // entry with standstill action or next entry with conditions, stop searching
      IF (posTable.stEntry[i1].nActionID > 0) OR NOT stConditionResult1.bConditionsOk THEN
        McePosTableRemainingEntries := nCount;
        RETURN;

      // last move, ignore further entries
      ELSIF posTable.stEntry[i1].bLastEntry THEN
        EXIT;
      END_IF;
    END_IF;
  END_FOR;
  // unlimited entries to go
  nCount := 9999;
END_IF;

McePosTableRemainingEntries := nCount;

