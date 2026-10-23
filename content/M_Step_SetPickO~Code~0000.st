// METHOD: M_Step_SetPickOffsetAndPCS_Tracking
// DESCRIPTION: Sets the offset between MCS and PCS.

// 1. Entry Action
IF NOT bStepInitialized THEN
    GroupSetFrameOffset_FeedIn.Offset := FeedIn_FrameOffset;
    GroupSetFrameOffset_FeedIn.ExecutionMode := MC_ExecutionMode#Immediately;
    GroupSetFrameOffset_FeedIn.RefCoordSystem := MC_CoordinateSystem#MCS;
    GroupSetFrameOffset_FeedIn.SetCoordSystem := MC_CoordinateSystem#PCS;
    GroupSetFrameOffset_FeedIn.Execute := TRUE;

    bStepInitialized := TRUE;
    M_Step_SetPickOffsetAndPCS_Tracking := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic Check
IF GroupSetFrameOffset_FeedIn.Done THEN
    GroupSetFrameOffset_FeedOut.Execute := FALSE;
    M_Step_SetPickOffsetAndPCS_Tracking := E_StepStatus#DONE;
ELSIF GroupSetFrameOffset_FeedIn.Error THEN
    M_Step_SetPickOffsetAndPCS_Tracking := E_StepStatus#ERROR;
ELSE
    M_Step_SetPickOffsetAndPCS_Tracking := E_StepStatus#BUSY;
END_IF;