(*
METHOD: State handler for OPERATIONAL_MANUAL state
DESCRIPTION: 
Implements manual mode logic with button-based control.
*)

bServoError_Manual := NOT(S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                      T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);
                   
//fbErrorHandler.AddUpdateError(NOT(S_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'S Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(L_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'L Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(U_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'U Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(T_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'T Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(B_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'B Axis Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedIn_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'CI Axis (Infeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);
//fbErrorHandler.AddUpdateError(NOT(FeedOut_Axis.Status.ServoOn), 0, 'FB_MachineControl - ManualState', 'CO Axis (Outfeed) Servo is not ON (SVON).', E_ErrorSeverity#MajorError);                   

IF bServoError_Manual THEN
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0,'FB_MachineControl - ManualState', 'Error/Alarm', E_ErrorSeverity#MajorError);
    RETURN;
END_IF;

// Enable manual movement only with safety button
MovementAllowed := Safety_Button;

// Calculate the enabling condition for motion commands axes. This condition requires the system not to be in a 'StartCycle' and to be in 'bManualModeSelected'.
xMotionAxesEnableCondition := NOT(CycleControls.StartCycle) AND bManualModeSelected;

// Calculate the overall enabling condition for jog joint command.
xJogJointEnableCondition := RobotJog.Joint_Mode AND
                            NOT(RobotJog.Linear_Mode) AND
                            NOT(CycleControls.StartCycle) AND
                            bManualModeSelected;
                       
// Calculate the overall enabling condition for linear jogging.
xJogLinearEnableCondition := NOT(RobotJog.Joint_Mode) AND
                             RobotJog.Linear_Mode AND
                             NOT(CycleControls.StartCycle) AND
                             bManualModeSelected;         
                             
// Calculate the overall enabling condition for joint positioning.
xAbsPosJointEnableCondition := RobotJog.ACS_Mode AND
                            NOT(RobotJog.MCS_Mode) AND
                            NOT(CycleControls.StartCycle) AND
                            bManualModeSelected;
                       
// Calculate the overall enabling condition for linear positioning.
xAbsPosLinearEnableCondition := NOT(RobotJog.ACS_Mode) AND
                             RobotJog.MCS_Mode AND
                             NOT(CycleControls.StartCycle) AND
                             bManualModeSelected;                                                    
                       
// ------------------------------ AXES ------------------------------

// Absolute Positioning Command for Rotary Axis.
DATA_FeedInAxis.Command.AbsPositioning := DATA_Axes.Command.FeedInAxis.Start AND xMotionAxesEnableCondition;

// Absolute Positioning Command for Linear Axis
DATA_FeedOutAxis.Command.AbsPositioning := DATA_Axes.Command.FeedOutAxis.Start AND xMotionAxesEnableCondition;

// Jogging Control for Rotary Axis (Forward/Reverse with mutual exclusivity)
IF DATA_Axes.Command.FeedInAxis.JogFwd AND xMotionAxesEnableCondition THEN
    DATA_FeedInAxis.Command.JogPos := TRUE;
    DATA_FeedInAxis.Command.JogNeg := FALSE;        
ELSIF DATA_Axes.Command.FeedInAxis.JogRev AND xMotionAxesEnableCondition THEN
    DATA_FeedInAxis.Command.JogPos := FALSE;
    DATA_FeedInAxis.Command.JogNeg := TRUE;
ELSE
    DATA_FeedInAxis.Command.JogPos := FALSE;
    DATA_FeedInAxis.Command.JogNeg := FALSE;
END_IF;

// Jogging Control for Linear Axis (Forward/Reverse with mutual exclusivity)
IF DATA_Axes.Command.FeedOutAxis.JogFwd AND xMotionAxesEnableCondition THEN
    DATA_FeedOutAxis.Command.JogPos := TRUE;
    DATA_FeedOutAxis.Command.JogNeg := FALSE;        
ELSIF DATA_Axes.Command.FeedOutAxis.JogRev AND xMotionAxesEnableCondition THEN
    DATA_FeedOutAxis.Command.JogPos := FALSE;
    DATA_FeedOutAxis.Command.JogNeg := TRUE;
ELSE
    DATA_FeedOutAxis.Command.JogPos := FALSE;
    DATA_FeedOutAxis.Command.JogNeg := FALSE;
END_IF;

// Stopping Control for Rotary Axis
DATA_FeedInAxis.Command.EmergencyStop := DATA_Axes.Command.FeedInAxis.Stop;
// Stopping Control for Linear Axis
DATA_FeedOutAxis.Command.EmergencyStop := DATA_Axes.Command.FeedOutAxis.Stop;

// ------------------------------ DELTA ------------------------------

// Determine which specific joint is being jogged and in which direction.
IF (RobotJog.JogJoint.S_Plus OR RobotJog.JogJoint.S_Minus OR
   RobotJog.JogJoint.L_Plus OR RobotJog.JogJoint.L_Minus OR
   RobotJog.JogJoint.U_Plus OR RobotJog.JogJoint.U_Minus OR
   RobotJog.JogJoint.T_Plus OR RobotJog.JogJoint.T_Minus OR
   RobotJog.JogJoint.B_Plus OR RobotJog.JogJoint.B_Minus) AND
   xJogJointEnableCondition THEN
    DATA_Delta.Command.En_GroupJogJoint := TRUE;
ELSE
    // If no jog joint button is pressed or the general enable condition is false,
    // ensure no joint is selected and the overall jog enable for the FB is false.
    xJogJointEnableCondition := FALSE; // Force FB Enable to FALSE to stop jogging
    DATA_Delta.Command.En_GroupJogJoint := FALSE;
END_IF;

// Determine which specific joint is being jogged and in which direction.
IF (RobotJog.JogLinear.X_Plus OR RobotJog.JogLinear.X_Minus OR
   RobotJog.JogLinear.Y_Plus OR RobotJog.JogLinear.Y_Minus OR
   RobotJog.JogLinear.Z_Plus OR RobotJog.JogLinear.Z_Minus OR
   RobotJog.JogLinear.Rz_Plus OR RobotJog.JogLinear.Rz_Minus OR
   RobotJog.JogLinear.Ry_Plus OR RobotJog.JogLinear.Ry_Minus) AND
   xJogLinearEnableCondition THEN
    DATA_Delta.Command.En_GroupJogLinear := TRUE;
ELSE
    // If no jog joint button is pressed or the general enable condition is false,
    // ensure no joint is selected and the overall jog enable for the FB is false.
    xJogLinearEnableCondition := FALSE; // Force FB Enable to FALSE to stop jogging
    DATA_Delta.Command.En_GroupJogLinear := FALSE;
END_IF;

// Determine which specific movement is being commanded.
IF RobotJog.MoveAbsolute AND
   RobotJog.ACS_Mode AND
   NOT(RobotJog.MCS_Mode) AND
   xAbsPosJointEnableCondition THEN
    DATA_Delta.Command.En_MoveLinearAbsolute := TRUE;
ELSE
    // If no jog joint button is pressed or the general enable condition is false,
    // ensure no joint is selected and the overall jog enable for the FB is false.
    xAbsPosJointEnableCondition := FALSE; // Force FB Enable to FALSE to stop jogging
    DATA_Delta.Command.En_MoveLinearAbsolute := FALSE;
END_IF;

// Determine which specific movement is being commanded.
IF RobotJog.MoveAbsolute AND
   NOT(RobotJog.ACS_Mode) AND
   RobotJog.MCS_Mode AND
   xAbsPosLinearEnableCondition THEN
    DATA_Delta.Command.En_MoveLinearAbsolute := TRUE;
ELSE
    // If no jog joint button is pressed or the general enable condition is false,
    // ensure no joint is selected and the overall jog enable for the FB is false.
    xAbsPosLinearEnableCondition := FALSE; // Force FB Enable to FALSE to stop jogging
    DATA_Delta.Command.En_MoveLinearAbsolute := FALSE;
END_IF;


// Monitor safety button and mode changes
IF NOT Safety_Button OR PowerDown THEN
    NextState := E_MachineState#STOPPING;
    PowerDown := FALSE;
    DATA_FeedInAxis.Command.AbsPositioning := FALSE;
    DATA_FeedOutAxis.Command.AbsPositioning := FALSE;
    DATA_FeedInAxis.Command.JogPos := FALSE;
    DATA_FeedInAxis.Command.JogNeg := FALSE;
    DATA_FeedOutAxis.Command.JogPos := FALSE;
    DATA_FeedOutAxis.Command.JogNeg := FALSE;
    DATA_Delta.Command.En_GroupJogJoint := FALSE;  
    DATA_Delta.Command.En_GroupJogLinear := FALSE;  
    LampIn := FALSE;
    LampOut := FALSE;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - ManualState', 'Safety button released or PowerDown active, entering STOPPING mode', E_ErrorSeverity#Warning);
ELSIF bAutoModeSelected THEN
    NextState := E_MachineState#OPERATIONAL_AUTOMATIC;
    bTransition := TRUE;
    fbErrorHandler.LogEvent(0, 'FB_MachineControl - ManualState', 'Switching to AUTOMATIC mode', E_ErrorSeverity#Info);
END_IF;
