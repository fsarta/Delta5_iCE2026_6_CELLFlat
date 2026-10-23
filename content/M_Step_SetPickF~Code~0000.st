// METHOD: M_Step_SetPickFrame_Tracking
// DESCRIPTION: Transforms the FeedIn Frame relative to the product.

// 1. Entry Action
IF NOT bStepInitialized THEN
    // Copy Frame Data
    FrameTypeTransform_FeedIn.OO := HmiFramesData.aTeachFrame[1].OO;
    FrameTypeTransform_FeedIn.XX := HmiFramesData.aTeachFrame[1].XX;
    FrameTypeTransform_FeedIn.XY := HmiFramesData.aTeachFrame[1].XY;
    FrameTypeTransform_FeedIn.Execute := TRUE;
    
    bStepInitialized := TRUE;
    M_Step_SetPickFrame_Tracking := E_StepStatus#BUSY;
    RETURN;
END_IF;

// 2. Cyclic Check
IF FrameTypeTransform_FeedIn.Done THEN
    FrameTypeTransform_FeedOut.Execute := FALSE; // Clean the other frame
    M_Step_SetPickFrame_Tracking := E_StepStatus#DONE;
ELSIF FrameTypeTransform_FeedIn.Error THEN
    M_Step_SetPickFrame_Tracking := E_StepStatus#ERROR;
ELSE
    M_Step_SetPickFrame_Tracking := E_StepStatus#BUSY;
END_IF;