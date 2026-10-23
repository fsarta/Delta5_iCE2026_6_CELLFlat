(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTableUpdateLoadIndex
 * Version            : 0.5.0
 * Date               : 2025-11-12
 * Author             : deGroot
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * Update the PosTable LoadIndex; for sending next motion
 * -----------------------------------------------------------------------------
 *)
 
 nPosTableSize := TO_INT(SIZEOF(PosTable) / SIZEOF(PosTable.stEntry[0]));

// -----------------------------------------------------------------------------
// calculate loadIndex
// -----------------------------------------------------------------------------

// -------------------------------------
// not using queueing
// -------------------------------------
IF (nQA = 0) OR firstMove THEN
  io.nLoadIndex := index;

// -------------------------------------
// using queueing
// -------------------------------------
ELSE
  // update load index to the next valid PosTableEntry
  io.nLoadIndex := THIS.McePosTableFindEntry(io.nLoadIndex, 1, nPosTableSize, TRUE);

  // no valid result found
  IF (io.nLoadIndex < 0) THEN
    io.nLoadIndex := index;
  END_IF;
END_IF;

// -----------------------------------------------------------------------------
// calculating QA in case of firstMove
// -----------------------------------------------------------------------------
IF firstMove AND allowQueuing THEN
  // -------------------------------------
  // calculate remaining entries until standstill
  // -------------------------------------
  nEntriesRemaining := THIS.McePosTableRemainingEntries(index, io.nLoadIndex, nPosTableSize, NOT(stopAfterLastEntry), conditions);

  // -------------------------------------
  // calculate Queueing Amount (allowed number of motions to be queued)
  // -------------------------------------
  nQA := nEntriesRemaining;

  IF (nEntriesRemaining > QA_MAX) THEN
    nQA := QA_MAX;
  END_IF;

  IF nQA < 0 THEN
    nQA := 0;
  END_IF;
END_IF;

