PickPlace_Status := FALSE;
iCurrentStepIndex := 0;
bStepInitialized := FALSE;

// Stop all Motion/Tracking
TrackConveyorBelt_FeedIn.Execute := FALSE;
TrackConveyorBelt_FeedOut.Execute := FALSE;
MoveLinearAbsolute_Blend1.Execute := FALSE;
MoveLinearAbsolute_Blend2.Execute := FALSE;
MoveLinearAbsolute_Blend3.Execute := FALSE;
MoveLinearAbsolute_Blend4.Execute := FALSE;

// Reset Grippers
bActivateGripper1 := FALSE;
bActivateGripper2 := FALSE;

// Reset Internal FBs
CalcFrameOffset_Group.Enable := FALSE;