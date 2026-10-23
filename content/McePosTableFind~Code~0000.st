(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTableFindEntry
 * Version            : 0.1.0
 * Date               : 2024-02-29
 * Author             : Rioual
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * Index of found PosTable entry (-1=no valid result found)
 * -----------------------------------------------------------------------------
 *)
 
 nEntriesFound := 0;

// -------------------------------------
// forward direction
// -------------------------------------
// search through the remaining part of the array
FOR i1 := index TO (posTableSize - 1) DO
  IF NOT posTable.stEntry[i1].bSkipEntry THEN
    nEntriesFound := nEntriesFound + 1;
    IF (nEntriesFound > offset) THEN
      McePosTableFindEntry := i1;
      RETURN;
    END_IF;
  END_IF;

  IF posTable.stEntry[i1].bLastEntry THEN
    EXIT;
  END_IF;
END_FOR;

// search through the first part of the array
IF rollOver THEN
  FOR i1 := 0 TO index DO
    IF NOT posTable.stEntry[i1].bSkipEntry THEN
      nEntriesFound := nEntriesFound + 1;
      IF (nEntriesFound > offset) THEN
        McePosTableFindEntry := i1;
        RETURN;
      END_IF;
    END_IF;

    IF posTable.stEntry[i1].bLastEntry THEN
      EXIT;
    END_IF;
  END_FOR;
END_IF;

// no valid result found
McePosTableFindEntry := - 1;

