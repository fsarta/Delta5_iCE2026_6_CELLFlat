// METHOD: AddStep (Helper to fill the array)
IF iTotalSteps <= 100 THEN
    SequenceList[iTotalSteps] := eState;
    iTotalSteps := iTotalSteps + 1;
END_IF