// METHOD: M_Step_WaitForPlaceSync

IF TrackConveyorBelt_FeedOut.InSync THEN
    DATA_Machine.Status.InSyncPlace_Delta := TRUE;
    M_Step_WaitForPlaceSync := E_StepStatus#DONE;
ELSE
    M_Step_WaitForPlaceSync := E_StepStatus#BUSY;
END_IF;