(*
METHOD: State handler for OPERATIONAL_AUTOMATIC state
DESCRIPTION: 
Implements automatic mode logic with motion control and safety monitoring.
*)

// --- AUTOCYCLE: Start/Stop cycle (automatic mode only) ---
// Start Cycle: starts the automatic cycle. Stop Cycle: soft stop (the current cycle
// ends and the robot moves to the parking position; see StopCycleEnabled in PickPlaceManager).
rtStartCycleBtn(CLK := CycleControls.StartCycle);
rtStopCycleBtn(CLK := CycleControls.StopCycle);
IF rtStartCycleBtn.Q THEN
    G_bAutoCycleRunning := TRUE;
END_IF;
IF rtStopCycleBtn.Q THEN
    G_bAutoCycleRunning := FALSE;
END_IF;


bServoError_Automatic := NOT(S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                   T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);

DATA_FeedInAxis.Command.JogPos := G_bAutoCycleRunning;
DATA_FeedOutAxis.Command.JogPos := G_bAutoCycleRunning;
LampIn := TRUE;
LampOut := TRUE;
xVision_StartCycle := G_bAutoCycleRunning;   // la visione segue il ciclo
io.bSystemReady := TRUE;
StartPickPlace_Delta := TRUE;   // resta TRUE in auto (non resettare il sequencer a meta ciclo)
                   
//fbErrorHandler.AddUpdateError(NOT(S_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'S Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(L_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'L Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(U_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'U Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(T_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'T Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(B_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'B Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedIn_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'CI Axis (Infeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedOut_Axis.Status.ServoOn), 0, 'FB_MachineControl - AutomaticState', 'CO Axis (Outfeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);                   

IF bServoError_Automatic THEN
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - AutomaticState', 'Error/Alarm', E_ErrorSeverity#MajorError); 
    RETURN;   
END_IF;

// Enable automatic movement
MovementAllowed := TRUE;

// Monitor for stop conditions
IF E_Stop OR PowerDown THEN
    NextState := E_MachineState#STOPPING;
    PowerDown := FALSE;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - AutomaticState', 'Emergency stop or manual power down, entering STOPPING mode', E_ErrorSeverity#Warning);
ELSIF G_bPickPlaceError OR (G_stOverallErrorStatus.eHighestSeverity >= E_ErrorSeverity#MajorError) THEN
    // sequencer error or critical error active -> controlled stop
    NextState := E_MachineState#STOPPING;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - AutomaticState', 'Pick&Place error or major error active - entering STOPPING mode', E_ErrorSeverity#Warning);
ELSIF NOT(bAutoModeSelected) AND bManualModeSelected AND Safety_Button THEN
    NextState := E_MachineState#OPERATIONAL_MANUAL;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - AutomaticState', 'Entering to MANUAL mode', E_ErrorSeverity#Info);
ELSIF NOT(bAutoModeSelected) THEN
    // No mode selected -> safety stop
    NextState := E_MachineState#STOPPING;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - AutomaticState', 'No mode selected - safety stop', E_ErrorSeverity#Warning);
END_IF;
