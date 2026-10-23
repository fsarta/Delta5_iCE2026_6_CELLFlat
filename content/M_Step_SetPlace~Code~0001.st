// METHOD: M_Step_SetPlaceOffsetAndPCS_Tracking
// DESCRIPTION: Sets the offset between MCS and PCS.

// 1. Entry
IF NOT bStepInitialized THEN
    GroupSetFrameOffset_FeedOut.Offset := FeedOut_FrameOffset;
    GroupSetFrameOffset_FeedOut.ExecutionMode := MC_ExecutionMode#Immediately;
    GroupSetFrameOffset_FeedOut.RefCoordSystem := MC_CoordinateSystem#MCS;
    GroupSetFrameOffset_FeedOut.SetCoordSystem := MC_CoordinateSystem#PCS;
    GroupSetFrameOffset_FeedOut.Execute := TRUE;

    bStepInitialized := TRUE;
    M_Step_SetPlaceOffsetAndPCS_Tracking := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic
IF GroupSetFrameOffset_FeedOut.Done THEN
    GroupSetFrameOffset_FeedIn.Execute := FALSE;
    M_Step_SetPlaceOffsetAndPCS_Tracking := E_StepStatus#DONE;
ELSIF GroupSetFrameOffset_FeedOut.Error THEN
    M_Step_SetPlaceOffsetAndPCS_Tracking := E_StepStatus#ERROR;    
ELSE
    M_Step_SetPlaceOffsetAndPCS_Tracking := E_StepStatus#BUSY;
END_IF;