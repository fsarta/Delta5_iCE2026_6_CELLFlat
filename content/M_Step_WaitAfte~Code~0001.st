// METHOD: M_Step_WaitAfterPlace_Tracking

// Gripper logic in the middle of wait
//IF (DATA_FeedOutAxis.Feedback.ActualPosition - TempPosConv) >= 50.0 THEN
     bActivateGripper1 := FALSE;
     bActivateGripper2 := FALSE;
//END_IF;

IF (DATA_FeedOutAxis.Feedback.ActualPosition - TempPosConv) >= 20.0 THEN
     M_Step_WaitAfterPlace_Tracking := E_StepStatus#DONE;
ELSE
     M_Step_WaitAfterPlace_Tracking := E_StepStatus#BUSY;
END_IF;