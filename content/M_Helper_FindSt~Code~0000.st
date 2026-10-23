
M_Helper_FindStepIndex := -1; // Default error

FOR i := 0 TO iTotalSteps - 1 DO
    IF SequenceList[i] = eTargetState THEN
        M_Helper_FindStepIndex := i;
        RETURN; // Trovato!
    END_IF;
END_FOR;