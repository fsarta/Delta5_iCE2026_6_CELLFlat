(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTableRecalcQA
 * Version            : 0.5.0
 * Date               : 2025-11-12
 * Author             : deGroot
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * Recalculate the Queuing Amount
 * -----------------------------------------------------------------------------
 *)
 
 nPosTableSize1 := TO_INT(SIZEOF(posTable) / SIZEOF(posTable.stEntry[0]));

// -----------------------------------------------------------------------------
// calculate remaining entries until standstill
// -----------------------------------------------------------------------------
nEntriesRemaining := THIS.McePosTableRemainingEntries(io.nIndex, loadIndex, nPosTableSize1, NOT(stopAfterLastEntry),conditions);

// -----------------------------------------------------------------------------
// bitstatus last entry / stop entry
// -----------------------------------------------------------------------------
bLastEntry := FALSE;
bStopEntry := FALSE;
bWaitBeforeNextEntry := FALSE;
IF (nEntriesRemaining <= 0) THEN
  Out := MEMORY_SET(stConditionResult1, 0, BYTE#0, SIZEOF(stConditionResult1));

  nNextIndex := THIS.McePosTableFindEntry(io.nIndex, 1, nPosTableSize1, NOT stopAfterLastEntry);
  IF nNextIndex >= 0 THEN
    stConditionResult1 := THIS.McePosTableCheckConditions(nNextIndex, nPosTableSize1, conditions);
    bWaitBeforeNextEntry := NOT stConditionResult1.bConditionsOk;
  ELSE
    bWaitBeforeNextEntry := FALSE;
  END_IF;
  
  IF (posTable.stEntry[io.nIndex].nActionID > 0) THEN
    bStopEntry := TRUE;
    // special case: the bStopEntry is also the bLastEntry
    bLastEntry := (THIS.McePosTableFindEntry(io.nIndex, 1, nPosTableSize1, FALSE) = - 1 );
  ELSIF NOT bWaitBeforeNextEntry THEN
    bLastEntry := TRUE;
  END_IF;
END_IF;


// -----------------------------------------------------------------------------
// calculate Queueing Amount (allowed number of motions to be queued)
// -----------------------------------------------------------------------------
// scenario 1; reduce QA till zero now
IF NOT allowQueuing THEN
  nQA := nQA - 1;
ELSE
  // scenario 2; reduce QA till zero by synchronizing to nEntriesRemaining
  IF (nEntriesRemaining < QA_MAX) THEN
    nQA := nEntriesRemaining;
  // scenario 3; use max QA
  ELSE
    nQA := QA_MAX;
  END_IF;
END_IF;

IF firstMove OR (nQA < 0) THEN
  nQA := 0;
END_IF;

