(*
METHOD: State handler for IDLE state
DESCRIPTION: 
Implements the idle state logic that waits for power-up commands and manages mode transitions.
*)

LampIn := FALSE;
LampOut := FALSE;
MainValveGripper := FALSE;
SecondaryValveGripper := FALSE;

// Transition to POWERING_UP when valid power-up conditions
IF PowerUp AND 
   ((bAutoModeSelected AND NOT(E_Stop)) OR 
   (Safety_Button AND bManualModeSelected AND NOT(E_Stop))) THEN
    NextState := E_MachineState#POWERING_UP;
    bTransition := TRUE;
    PowerUp := FALSE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - IdleState','Ready to POWER UP', E_ErrorSeverity#Info); 
ELSIF HmiFramesData.StartTeach AND (State_MachineController = E_MachineState#IDLE OR State_MachineController = E_MachineState#OPERATIONAL_MANUAL) THEN 
    State_MachineController := E_MachineState#TEACH_FRAME;
    bTransition := TRUE;

//ELSIF (PowerDown AND bAutoModeSelected) OR 
//      (NOT(Safety_Button) AND bManualModeSelected AND //NOT(SystemControls.AllMotorsServoOff)) THEN
//      (DATA_Delta.Status.GroupControl.GroupStatus AND
//      DATA_Delta.Status.GroupControl.PowerStatus AND
//      DATA_FeedInAxis.Status.Enabled AND
//      DATA_FeedOutAxis.Status.Enabled AND
//      DATA_VirtAxis.Status.Enabled)) THEN
//    NextState := E_MachineState#STOPPING;
//    bTransition := TRUE;
//    fbErrorHandler.LogEvent(0, 'FB_MachineControl - IdleState','STOPPING', E_ErrorSeverity#Info);
ELSE
    PowerUp := FALSE;
    PowerDown := FALSE;
END_IF;