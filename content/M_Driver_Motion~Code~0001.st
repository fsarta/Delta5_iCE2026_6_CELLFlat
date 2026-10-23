// METHOD M_Driver_Motion_Check : E_StepStatus

// 1. Fetch status based on internal current ID
CASE eCurrentMoveID OF
    E_MotionChannel#Blend1:
        bLocalActive := MoveLinearAbsolute_Blend1.Active;
        bLocalDone   := MoveLinearAbsolute_Blend1.Done;
        bLocalError  := MoveLinearAbsolute_Blend1.Error;
    E_MotionChannel#Blend2:
        bLocalActive := MoveLinearAbsolute_Blend2.Active;
        bLocalDone   := MoveLinearAbsolute_Blend2.Done;
        bLocalError  := MoveLinearAbsolute_Blend2.Error;
    E_MotionChannel#Blend3:
        bLocalActive := MoveLinearAbsolute_Blend3.Active;
        bLocalDone   := MoveLinearAbsolute_Blend3.Done;
        bLocalError  := MoveLinearAbsolute_Blend3.Error;
    E_MotionChannel#Blend4:
        bLocalActive := MoveLinearAbsolute_Blend4.Active;
        bLocalDone   := MoveLinearAbsolute_Blend4.Done;
        bLocalError  := MoveLinearAbsolute_Blend4.Error;
ELSE
    // Invalid ID implies Error
    M_Driver_Motion_Check := E_StepStatus#ERROR;
    RETURN;
END_CASE;

// 2. Logic to determine Step Status
IF bLocalActive THEN
    M_Driver_Motion_Check := E_StepStatus#ACTIVE; 
ELSIF bLocalDone THEN
    M_Driver_Motion_Check := E_StepStatus#DONE; 
ELSIF bLocalError THEN
    M_Driver_Motion_Check := E_StepStatus#ERROR;
ELSE
    M_Driver_Motion_Check := E_StepStatus#BUSY;
END_IF;

// --- 3. AUTO-RESET OF THE PREVIOUS BLOCK ---
IF (M_Driver_Motion_Check = E_StepStatus#ACTIVE OR M_Driver_Motion_Check = E_StepStatus#DONE) THEN
    
    IF bHasPreviousMove THEN
        // Automatically switch off the Execute of the previous block
        THIS.M_Driver_ResetMove(ePreviousMoveID);
        
        // Lower the flag to prevent continuous resets
        bHasPreviousMove := FALSE; 
    END_IF
    
END_IF;