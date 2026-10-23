// METHOD: M_Step_WaitAfterPick_Tracking
// DESCRIPTION: Waits for the conveyor to travel a bit before going up.

IF (DATA_FeedInAxis.Feedback.ActualPosition - TempPosConv) >= 100.0 THEN
    M_Step_WaitAfterPick_Tracking := E_StepStatus#DONE;
ELSE
    M_Step_WaitAfterPick_Tracking := E_StepStatus#BUSY;
END_IF;