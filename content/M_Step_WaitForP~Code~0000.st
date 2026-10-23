IF TrackConveyorBelt_FeedIn.InSync OR DATA_FeedInAxis.Feedback.ActualPosition = 0.0 THEN
    DATA_Machine.Status.InSyncPick_Delta := TRUE;
    M_Step_WaitForPickSync := E_StepStatus#DONE;
ELSE
    M_Step_WaitForPickSync := E_StepStatus#BUSY;
END_IF