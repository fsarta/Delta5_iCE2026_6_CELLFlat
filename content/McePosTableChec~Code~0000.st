(*
 * -----------------------------------------------------------------------------
 * Name               : McePosTableCheckConditions
 * Version            : 0.1.0
 * Date               : 2024-03-28
 * Author             : deGroot
 * Family             : YaskawaMce
 * Organisation       : github.com/YaskawaEurope/mlx-examples
 * 
 * -----------------------------------------------------------------------------
 * Check start conditions of a PosTable entry
 * -----------------------------------------------------------------------------
 *)

Out := MEMORY_SET(stConditionResult, 0, BYTE#0, SIZEOF(stConditionResult));

// check if this entry has start conditions
stConditionResult.bHasConditions := FALSE;
stConditionResult.bConditionsOk := TRUE;
IF index >= 0 THEN
  FOR i1 := 0 TO CONDITIONS_UBOUND DO
    stConditionResult.bHasConditions := stConditionResult.bHasConditions OR posTable.stEntry[index].aStartCondition[i1];
    stConditionResult.bConditionsOk := stConditionResult.bConditionsOk AND (NOT posTable.stEntry[index].aStartCondition[i1] OR (posTable.stEntry[index].aStartCondition[i1] AND conditions[i1]));
    stConditionResult.aMissingConditions[i1] := posTable.stEntry[index].aStartCondition[i1] AND NOT conditions[i1];
  END_FOR
END_IF;

McePosTableCheckConditions := stConditionResult;

