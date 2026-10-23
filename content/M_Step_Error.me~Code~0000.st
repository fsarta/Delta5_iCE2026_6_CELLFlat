// METHOD: M_Step_Error
// DESCRIPTION: Holding state when an error occurs.

// Logic to handle error acknowledgment could go here.
// For now, it stays BUSY until external reset via StartPickPlace=FALSE or similar.
bActivateGripper1 := FALSE;
bActivateGripper2 := FALSE; 

M_Step_Error := E_StepStatus#BUSY;