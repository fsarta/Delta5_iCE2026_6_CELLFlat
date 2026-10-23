// METHOD M_Driver_InitPointers : BOOL
// Prepare the ring buffer: start at the end so the first trigger shifts to Blend1
eCurrentMoveID   := E_MotionChannel#Blend4; 
bIsFirstMove     := TRUE;
bHasPreviousMove := FALSE;

// Reset all Execute flags to ensure a clean state
THIS.M_Driver_ResetMove(E_MotionChannel#Blend1);
THIS.M_Driver_ResetMove(E_MotionChannel#Blend2);
THIS.M_Driver_ResetMove(E_MotionChannel#Blend3);
THIS.M_Driver_ResetMove(E_MotionChannel#Blend4);

M_Driver_InitPointers := TRUE;