// METHOD: M_Step_InitParking

TrackConveyorBelt_FeedIn.Execute := FALSE;
TrackConveyorBelt_FeedOut.Execute := FALSE;

bActivateGripper1 := FALSE;
bActivateGripper2 := FALSE;

// This method deactivates all four Blend blocks and sets the pointer 
// so that the next movement starts afresh from Block 1.
THIS.M_Driver_InitPointers();

M_Step_InitParking := E_StepStatus#DONE;