// METHOD PRIVATE M_Driver_ResetMove : BOOL

// Safely remove the Execute command from the specified block
CASE iBlockID OF
    E_MotionChannel#Blend1:
        MoveLinearAbsolute_Blend1.Execute := FALSE;
    E_MotionChannel#Blend2:
        MoveLinearAbsolute_Blend2.Execute := FALSE;
    E_MotionChannel#Blend3:
        MoveLinearAbsolute_Blend3.Execute := FALSE;
    E_MotionChannel#Blend4:
        MoveLinearAbsolute_Blend4.Execute := FALSE;
END_CASE

M_Driver_ResetMove := TRUE;