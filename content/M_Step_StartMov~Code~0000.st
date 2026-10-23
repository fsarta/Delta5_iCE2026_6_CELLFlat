// METHOD: M_Step_StartMovePath
// DESCRIPTION: Waits for the conveyor to travel a bit before going up.

IF fbRotatePosition.bDone THEN
    io.bRun := TRUE;
    fbRotatePosition.bExecute := FALSE;
    M_Step_StartMovePath := E_StepStatus#BUSY;
ELSIF io.bDone THEN
    io.bRun := FALSE;
    M_Step_StartMovePath := E_StepStatus#DONE;   
ELSIF io.bError THEN
    M_Step_StartMovePath := E_StepStatus#ERROR; 
ELSE
    M_Step_StartMovePath := E_StepStatus#BUSY;
END_IF;