// METHOD: M_Step_SetPlaceFrame_Tracking
// DESCRIPTION: Transforms the FeedOut Frame.

// 1. Entry
IF NOT bStepInitialized THEN
    FrameTypeTransform_FeedOut.OO := HmiFramesData.aTeachFrame[2].OO;
    FrameTypeTransform_FeedOut.XX := HmiFramesData.aTeachFrame[2].XX;
    FrameTypeTransform_FeedOut.XY := HmiFramesData.aTeachFrame[2].XY;
    FrameTypeTransform_FeedOut.Execute := TRUE;
    
    bStepInitialized := TRUE;
    M_Step_SetPlaceFrame_Tracking := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic
IF FrameTypeTransform_FeedOut.Done THEN
    FrameTypeTransform_FeedIn.Execute := FALSE;
    M_Step_SetPlaceFrame_Tracking := E_StepStatus#DONE;
ELSE
    M_Step_SetPlaceFrame_Tracking := E_StepStatus#BUSY;
END_IF;