(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTableUpdateIndex
 * Version            : 0.3.0
 * Date               : 2024-05-15
 * Author             : Rioual
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * Update the PosTable Index
 * -----------------------------------------------------------------------------
 *)
 
 nPosTableSize1 := TO_INT(SIZEOF(posTable) / SIZEOF(posTable.stEntry[0]));


// -----------------------------------------------------------------------------
// update index
// -----------------------------------------------------------------------------
// update index to the next valid PosTableEntry
IF firstMove THEN
  // just validate the current index on the first move
  io.nIndex := THIS.McePosTableFindEntry(io.nIndex, 0, nPosTableSize1, TRUE);
ELSE
  // increase the index
  io.nIndex := THIS.McePosTableFindEntry(io.nIndex, 1, nPosTableSize1, TRUE);
END_IF;

// -----------------------------------------------------------------------------
// calculate Queueing Amount (allowed number of motions to be queued)
// -----------------------------------------------------------------------------
IF (NOT bWaitBeforeNextEntry OR firstMove) AND (io.nIndex >= 0) THEN
  THIS.McePosTableRecalcQA(allowQueuing, firstMove, stopAfterLastEntry, conditions, loadIndex);
END_IF;

