// METHOD: M_Step_InitializePlace
// DESCRIPTION: Resets specific flags for Place phase.
    
TrackConveyorBelt_FeedOut.Execute := FALSE;
GroupSetFrameOffset_FeedIn.Execute := FALSE;
TrackConveyorBelt_FeedIn.Execute := FALSE;
bPlacePhaseActive := TRUE;   // AUTOCYCLE: inizia la fase place (l'abort stop-cycle non si applica qui)


// Done immediately
M_Step_InitializePlace := E_StepStatus#DONE;