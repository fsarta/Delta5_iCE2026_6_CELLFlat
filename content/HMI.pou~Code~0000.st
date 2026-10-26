(*============================================================================================*)
(*                                          DASHBOARD                                         *)
(*============================================================================================*)

HMI_Data.Dashboard.SoftwareVersion.Motion   := "0_08_02";
HMI_Data.Dashboard.SoftwareVersion.HMI      := "0_02_00";

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
PowerUp                     := HMI_Data.Dashboard.Command.PowerUp;
PowerDown                   := HMI_Data.Dashboard.Command.PowerDown;
CycleControls.StartCycle    := HMI_Data.Dashboard.Command.StartCycle;
CycleControls.StopCycle     := HMI_Data.Dashboard.Command.StopCycle;
bManualModeSelected         := HMI_Data.Dashboard.Command.ManualMode;
bAutoModeSelected           := HMI_Data.Dashboard.Command.AutomaticMode;
Safety_Button               := HMI_Data.Dashboard.Command.SafetuButton;

IF HMI_Data.Dashboard.Command.SetSpeedOverride > 100.0 THEN
    MotionDataOverride := 100.0;
ELSIF HMI_Data.Dashboard.Command.SetSpeedOverride <= 0.0 THEN
    MotionDataOverride := 0.1;
ELSE
    MotionDataOverride := HMI_Data.Dashboard.Command.SetSpeedOverride;
END_IF;

G_bResetAllErrors           := HMI_Data.Dashboard.Command.ResetErrors;
G_bAcknowledgeAllErrors     := HMI_Data.Dashboard.Command.AckErrors;

DATA_Machine.Command.ResetAxis[1]   := HMI_Data.Dashboard.Command.ResetAxis[1];
DATA_Machine.Command.ResetAxis[2]   := HMI_Data.Dashboard.Command.ResetAxis[2];
DATA_Machine.Command.ResetAxis[3]   := HMI_Data.Dashboard.Command.ResetAxis[3];
DATA_Machine.Command.ResetAxis[4]   := HMI_Data.Dashboard.Command.ResetAxis[4];
DATA_Machine.Command.ResetAxis[5]   := HMI_Data.Dashboard.Command.ResetAxis[5];
DATA_Machine.Command.ResetAxis[6]   := HMI_Data.Dashboard.Command.ResetAxis[6];
DATA_Machine.Command.ResetAxis[7]   := HMI_Data.Dashboard.Command.ResetAxis[7];

DATA_Machine.Command.RebootAxis[1]  := HMI_Data.Dashboard.Command.RebootAxis[1];
DATA_Machine.Command.RebootAxis[2]  := HMI_Data.Dashboard.Command.RebootAxis[2];
DATA_Machine.Command.RebootAxis[3]  := HMI_Data.Dashboard.Command.RebootAxis[3];
DATA_Machine.Command.RebootAxis[4]  := HMI_Data.Dashboard.Command.RebootAxis[4];
DATA_Machine.Command.RebootAxis[5]  := HMI_Data.Dashboard.Command.RebootAxis[5];
DATA_Machine.Command.RebootAxis[6]  := HMI_Data.Dashboard.Command.RebootAxis[6];
DATA_Machine.Command.RebootAxis[7]  := HMI_Data.Dashboard.Command.RebootAxis[7];

(*------------------------------------------- STATUS -----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)
HMI_Data.Dashboard.Status.AllMotorsServoOn  := SystemControls.AllMotorsServoOn;
HMI_Data.Dashboard.Status.AllMotorsServoOff := SystemControls.AllMotorsServoOff;
HMI_Data.Dashboard.Status.CurrentSpeed    := TO_REAL(DATA_FeedInAxis.Feedback.ActualSpeed); // KPI
HMI_Data.Dashboard.Status.CycleTime       := KPI_Data.tCycleTimeLast; // KPI
HMI_Data.Dashboard.Status.IsAutoMode      := bAutoModeSelected;
HMI_Data.Dashboard.Status.IsManualMode    := bManualModeSelected;
HMI_Data.Dashboard.Status.IsRunning       := (State_MachineController = E_MachineState#OPERATIONAL_AUTOMATIC);   // KPI
HMI_Data.Dashboard.Status.ProductsPerMin  := TO_REAL(KPI_Data.rProductsPerMin);   // KPI
HMI_Data.Dashboard.Status.SafetyOk        := NOT E_Stop;   // KPI (E_Stop TRUE = arresto emergenza attivo)
HMI_Data.Dashboard.Status.ServoMotorsAlarm  :=  S_Axis.Status.Alarm OR
                                                L_Axis.Status.Alarm OR
                                                U_Axis.Status.Alarm OR
                                                T_Axis.Status.Alarm OR
                                                (*B_Axis.Status.Alarm OR*)
                                                FeedIn_Axis.Status.Alarm OR
                                                FeedOut_Axis.Status.Alarm;   
                                                
HMI_Data.Dashboard.Status.State_MachineController := State_MachineController;

// ---- KPI: stato processo / visione / asse (da FB_KPI -> KPI_Data, vedi KPI/GUIDA_KPI.md) ----
HMI_Data.Process.Status.CurrentState   := KPI_Data.iCurrentState;
HMI_Data.Process.Status.PickedCount    := KPI_Data.udiPiecesPicked;
HMI_Data.Process.Status.PlacedCount    := KPI_Data.udiPiecesPlaced;
HMI_Data.Process.Status.TrackingActive := KPI_Data.xTrackingActive;
HMI_Data.Vision.Status.IsConnected     := (VisorSensoPart_1_ConnectionState.ConnectionState = 4);
HMI_Data.Vision.Status.LastProcTime    := TO_UINT(TIME_TO_DINT(KPI_Data.tVisionProcLast));
HMI_Data.Vision.Status.TotalPartsFound := KPI_Data.udiProductsDetected;
HMI_Data.Vision.LastProduct.X          := TO_LREAL(aBuffer_X[0]);
HMI_Data.Vision.LastProduct.Y          := TO_LREAL(aBuffer_Y[0]);
HMI_Data.Vision.LastProduct.Rotation   := TO_LREAL(aBuffer_Rz[0]);
HMI_Data.Vision.LastProduct.ClassID    := 0;   (* il telegramma VISOR non fornisce ClassID *)
HMI_Data.Axis.FeedIn.Status.IsHomed    := DATA_FeedInAxis.Status.Homed;
HMI_Data.Axis.FeedIn.Status.IsPowered  := DATA_FeedInAxis.Status.Enabled;
HMI_Data.Axis.FeedIn.Status.IsOn       := DATA_FeedInAxis.Status.Enabled;
HMI_Data.Axis.FeedIn.Status.IsMoving   := NOT DATA_FeedInAxis.Status.StandStill;
HMI_Data.Axis.FeedIn.Status.Error      := DATA_FeedInAxis.Status.Errors;
HMI_Data.Axis.FeedIn.Status.ErrorID    := DATA_FeedInAxis.Feedback.DriveAlarmID;


(*============================================================================================*)
(*                                            ROBOT                                           *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
RobotJog.Joint_Mode     := HMI_Data.Robot.Command.Joint_Mode;
RobotJog.Linear_Mode    := HMI_Data.Robot.Command.Linear_Mode;
RobotJog.ACS_Mode       := HMI_Data.Robot.Command.ACS_Mode;
RobotJog.MCS_Mode       := HMI_Data.Robot.Command.MCS_Mode;

DATA_DELTA.Command.En_EmergencyGroupStop := HMI_Data.Robot.Command.Stop;
        
DATA_DELTA.Command.TestGroupBlend := HMI_Data.Robot.Command.Dance AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);

RobotJog.JogJoint.S_Plus   := HMI_Data.Robot.Command.JogJoint.S_Plus;
RobotJog.JogJoint.S_Minus  := HMI_Data.Robot.Command.JogJoint.S_Minus;
RobotJog.JogJoint.L_Plus   := HMI_Data.Robot.Command.JogJoint.L_Plus;
RobotJog.JogJoint.L_Minus  := HMI_Data.Robot.Command.JogJoint.L_Minus;
RobotJog.JogJoint.U_Plus   := HMI_Data.Robot.Command.JogJoint.U_Plus;
RobotJog.JogJoint.U_Minus  := HMI_Data.Robot.Command.JogJoint.U_Minus;
RobotJog.JogJoint.B_Plus   := HMI_Data.Robot.Command.JogJoint.B_Plus;
RobotJog.JogJoint.B_Minus  := HMI_Data.Robot.Command.JogJoint.B_Minus;
RobotJog.JogJoint.T_Plus   := HMI_Data.Robot.Command.JogJoint.T_Plus;
RobotJog.JogJoint.T_Minus  := HMI_Data.Robot.Command.JogJoint.T_Minus;
        
RobotJog.JogLinear.X_Plus  := HMI_Data.Robot.Command.JogLinear.X_Plus;
RobotJog.JogLinear.X_Minus := HMI_Data.Robot.Command.JogLinear.X_Minus;
RobotJog.JogLinear.Y_Plus  := HMI_Data.Robot.Command.JogLinear.Y_Plus;
RobotJog.JogLinear.Y_Minus := HMI_Data.Robot.Command.JogLinear.Y_Minus;
RobotJog.JogLinear.Z_Plus  := HMI_Data.Robot.Command.JogLinear.Z_Plus;
RobotJog.JogLinear.Z_Minus := HMI_Data.Robot.Command.JogLinear.Z_Minus;
RobotJog.JogLinear.Rz_Plus := HMI_Data.Robot.Command.JogLinear.Rz_Plus;
RobotJog.JogLinear.Rz_Minus:= HMI_Data.Robot.Command.JogLinear.Rz_Minus;
RobotJog.JogLinear.Ry_Plus := HMI_Data.Robot.Command.JogLinear.Ry_Plus;
RobotJog.JogLinear.Ry_Minus:= HMI_Data.Robot.Command.JogLinear.Ry_Minus;

RobotJog.Slow_Speed     := HMI_Data.Robot.Command.Slow_Speed;
RobotJog.Medium_Speed   := HMI_Data.Robot.Command.Medium_Speed;
RobotJog.Fast_Speed     := HMI_Data.Robot.Command.Fast_Speed;
RobotJog.Speed_Selected_HMI := HMI_Data.Robot.Command.Speed_Selected_HMI;
        
DATA_DELTA.Command.En_GroupSetPosition  := HMI_Data.Robot.Command.GroupSetPosition AND ((State_MachineController = E_MachineState#OPERATIONAL_MANUAL) OR (State_MachineController = E_MachineState#WAIT_FOR_COMMISSIONING));
DATA_Delta.Command.SetPosition.Axis_S   := HMI_Data.Robot.Command.SetPosition[0] AND ((State_MachineController = E_MachineState#OPERATIONAL_MANUAL) OR (State_MachineController = E_MachineState#WAIT_FOR_COMMISSIONING));
DATA_Delta.Command.SetPosition.Axis_L   := HMI_Data.Robot.Command.SetPosition[1] AND ((State_MachineController = E_MachineState#OPERATIONAL_MANUAL) OR (State_MachineController = E_MachineState#WAIT_FOR_COMMISSIONING));
DATA_Delta.Command.SetPosition.Axis_U   := HMI_Data.Robot.Command.SetPosition[2] AND ((State_MachineController = E_MachineState#OPERATIONAL_MANUAL) OR (State_MachineController = E_MachineState#WAIT_FOR_COMMISSIONING));
DATA_Delta.Command.SetPosition.Axis_T   := HMI_Data.Robot.Command.SetPosition[3] AND ((State_MachineController = E_MachineState#OPERATIONAL_MANUAL) OR (State_MachineController = E_MachineState#WAIT_FOR_COMMISSIONING));
DATA_Delta.Command.SetPosition.Axis_B   := HMI_Data.Robot.Command.SetPosition[4] AND ((State_MachineController = E_MachineState#OPERATIONAL_MANUAL) OR (State_MachineController = E_MachineState#WAIT_FOR_COMMISSIONING));
DATA_DELTA.Command.En_MoveLinearAbsolute:= HMI_Data.Robot.Command.MoveAbsolute AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_DELTA.Command.En_MoveLinearRelative:= HMI_Data.Robot.Command.MoveRelative AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
DATA_DELTA.Setting.GroupSetPosition.Position        := HMI_Data.Robot.Setting.HomingPosition;
DATA_DELTA.Setting.SetPosition.Axis_S.Position      := HMI_Data.Robot.Setting.HomingPosition[1];
DATA_DELTA.Setting.SetPosition.Axis_L.Position      := HMI_Data.Robot.Setting.HomingPosition[2];
DATA_DELTA.Setting.SetPosition.Axis_U.Position      := HMI_Data.Robot.Setting.HomingPosition[3];
DATA_DELTA.Setting.SetPosition.Axis_T.Position      := HMI_Data.Robot.Setting.HomingPosition[4];
DATA_DELTA.Setting.SetPosition.Axis_B.Position      := HMI_Data.Robot.Setting.HomingPosition[5];
DATA_DELTA.Setting.MoveLinearAbsolute.Position      := HMI_Data.Robot.Setting.CommandPosition;
//DATA_DELTA.Setting.MoveLinearAbsolute.Velocity      := HMI_Data.Robot.Setting.CommandVelocity;
//DATA_DELTA.Setting.MoveLinearAbsolute.Acceleration  := HMI_Data.Robot.Setting.CommandAcceleration;
//DATA_DELTA.Setting.MoveLinearAbsolute.Deceleration  := HMI_Data.Robot.Setting.CommandDeceleration;
DATA_DELTA.Setting.MoveLinearRelative.Distance      := HMI_Data.Robot.Setting.CommandDistance;
//DATA_DELTA.Setting.MoveLinearRelative.Velocity      := HMI_Data.Robot.Setting.CommandVelocity;
//DATA_DELTA.Setting.MoveLinearRelative.Acceleration  := HMI_Data.Robot.Setting.CommandAcceleration;
//DATA_DELTA.Setting.MoveLinearRelative.Deceleration  := HMI_Data.Robot.Setting.CommandDeceleration;

(*------------------------------------------- STATUS -----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)
HMI_Data.Robot.Status.IsHomed    := GroupIsHomed;
HMI_Data.Robot.Status.IsPowered  := DATA_DELTA.Status.GroupControl.PowerStatus;
HMI_Data.Robot.Status.IsMoving   := DATA_DELTA.Status.GroupReadStatus.GroupMoving;
HMI_Data.Robot.Status.Error      := DATA_DELTA.Status.GroupControl.GroupError;
HMI_Data.Robot.Status.ErrorID    := DATA_DELTA.Status.GroupControl.GroupErrorID;  

(*------------------------------------------ FEEDBACK ----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)
HMI_Data.Robot.Feedback.Linear_Position  := DELTA.Machine.ActualPos;
HMI_Data.Robot.Feedback.Linear_Velocity  := DELTA.Machine.ActualVel;
HMI_Data.Robot.Feedback.Joint_Position   := DELTA.Axis.ActualPos;
HMI_Data.Robot.Feedback.Joint_Velocity   := DELTA.Axis.ActualVel;

// HMI page "ROBOT & PART POSITIONS": TCP e giunti come scalari (piu' semplici da
// mappare in JMobile rispetto agli elementi di un VECTOR).
// Attenzione: nel VECTOR l'indice 0 non e' usato, le componenti sono [1..6] / [1..5].
HMI_Data.Robot.Feedback.TCP.X    := TO_LREAL(DELTA.Machine.ActualPos[1]);
HMI_Data.Robot.Feedback.TCP.Y    := TO_LREAL(DELTA.Machine.ActualPos[2]);
HMI_Data.Robot.Feedback.TCP.Z    := TO_LREAL(DELTA.Machine.ActualPos[3]);
HMI_Data.Robot.Feedback.TCP.Rx   := TO_LREAL(DELTA.Machine.ActualPos[4]);
HMI_Data.Robot.Feedback.TCP.Ry   := TO_LREAL(DELTA.Machine.ActualPos[5]);
HMI_Data.Robot.Feedback.TCP.Rz   := TO_LREAL(DELTA.Machine.ActualPos[6]);
HMI_Data.Robot.Feedback.Joint[0] := TO_LREAL(DELTA.Axis.ActualPos[1]);
HMI_Data.Robot.Feedback.Joint[1] := TO_LREAL(DELTA.Axis.ActualPos[2]);
HMI_Data.Robot.Feedback.Joint[2] := TO_LREAL(DELTA.Axis.ActualPos[3]);
HMI_Data.Robot.Feedback.Joint[3] := TO_LREAL(DELTA.Axis.ActualPos[4]);
HMI_Data.Robot.Feedback.Joint[4] := TO_LREAL(DELTA.Axis.ActualPos[5]);

(*============================================================================================*)
(*                                            AXIS                                            *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)

// FeedIn
DATA_Axes.Command.FeedInAxis.JogFwd     := HMI_Data.Axis.FeedIn.Command.JogFWD;
DATA_Axes.Command.FeedInAxis.JogRev     := HMI_Data.Axis.FeedIn.Command.JogREV;
DATA_FeedInAxis.Command.AbsPositioning  := HMI_Data.Axis.FeedIn.Command.MoveAbsolute AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_FeedInAxis.Command.IncPositioning  := HMI_Data.Axis.FeedIn.Command.MoveRelative AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_FeedInAxis.Command.AbsSetPos       := HMI_Data.Axis.FeedIn.Command.SetPosition AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_FeedInAxis.Command.EmergencyStop   := HMI_Data.Axis.FeedIn.Command.Stop;
        
// FeedOut
DATA_Axes.Command.FeedOutAxis.JogFwd    := HMI_Data.Axis.FeedOut.Command.JogFWD;
DATA_Axes.Command.FeedOutAxis.JogRev    := HMI_Data.Axis.FeedOut.Command.JogREV;
DATA_FeedOutAxis.Command.AbsPositioning := HMI_Data.Axis.FeedOut.Command.MoveAbsolute AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_FeedOutAxis.Command.IncPositioning := HMI_Data.Axis.FeedOut.Command.MoveRelative AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_FeedOutAxis.Command.AbsSetPos      := HMI_Data.Axis.FeedOut.Command.SetPosition AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_FeedOutAxis.Command.EmergencyStop  := HMI_Data.Axis.FeedOut.Command.Stop;

// Virtual
DATA_VirtAxis.Command.JogPos            := HMI_Data.Axis.Virtual.Command.JogFWD AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_VirtAxis.Command.JogNeg            := HMI_Data.Axis.Virtual.Command.JogREV AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_VirtAxis.Command.AbsPositioning    := HMI_Data.Axis.Virtual.Command.MoveAbsolute AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_VirtAxis.Command.IncPositioning    := HMI_Data.Axis.Virtual.Command.MoveRelative AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);
DATA_VirtAxis.Command.AbsSetPos         := HMI_Data.Axis.Virtual.Command.SetPosition AND (State_MachineController = E_MachineState#OPERATIONAL_MANUAL);

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)

// FeedIn
DATA_FeedInAxis.Setting.AbsPositioningTarget    := HMI_Data.Axis.FeedIn.Setting.CommandPosition;
DATA_FeedInAxis.Setting.IncPositioningTarget    := HMI_Data.Axis.FeedIn.Setting.CommandDistance;
DATA_FeedInAxis.Setting.PositioningSpeed        := HMI_Data.Axis.FeedIn.Setting.CommandVelocity;
DATA_FeedInAxis.Setting.PositioningAcc          := HMI_Data.Axis.FeedIn.Setting.CommandAcceleration;
DATA_FeedInAxis.Setting.PositioningDec          := HMI_Data.Axis.FeedIn.Setting.CommandDeceleration;
DATA_FeedInAxis.Setting.HomePos                 := HMI_Data.Axis.FeedIn.Setting.HomingPosition;
DATA_FeedInAxis.Setting.JogSpeed                := MIN(HMI_Data.Axis.FeedIn.Setting.CommandVelocity, FeedIn_SmoothSpeed); //HMI_Data.Axis.FeedIn.Setting.CommandVelocity;
DATA_FeedInAxis.Setting.JogAcc                  := MIN(HMI_Data.Axis.FeedIn.Setting.CommandAcceleration, FeedIn_SmoothAcceleration); //HMI_Data.Axis.FeedIn.Setting.CommandAcceleration;
(* DECELERAZIONE FEEDIN = FEEDOUT:
   la decelerazione NON deve essere ridotta da FeedIn_SmoothDeceleration. E' l'unico
   parametro che il drive usa quando il jog viene rilasciato: se lo si abbassa al valore
   "morbido" (dec_min), allo Stop Ciclo il nastro FeedIn frena con una rampa lentissima
   mentre il FeedOut (che usa CommandDeceleration) si ferma subito.
   La rampa di velocita' del tracking e' gia' data dal setpoint (FB_ConveyorController),
   non serve una decelerazione ridotta. *)
DATA_FeedInAxis.Setting.JogDec                  := HMI_Data.Axis.FeedIn.Setting.CommandDeceleration;

        
// FeedOut
DATA_FeedOutAxis.Setting.AbsPositioningTarget   := HMI_Data.Axis.FeedOut.Setting.CommandPosition;
DATA_FeedOutAxis.Setting.IncPositioningTarget   := HMI_Data.Axis.FeedOut.Setting.CommandDistance;
DATA_FeedOutAxis.Setting.PositioningSpeed       := HMI_Data.Axis.FeedOut.Setting.CommandVelocity;
DATA_FeedOutAxis.Setting.PositioningAcc         := HMI_Data.Axis.FeedOut.Setting.CommandAcceleration;
DATA_FeedOutAxis.Setting.PositioningDec         := HMI_Data.Axis.FeedOut.Setting.CommandDeceleration;
DATA_FeedOutAxis.Setting.HomePos                := HMI_Data.Axis.FeedOut.Setting.HomingPosition;
DATA_FeedOutAxis.Setting.JogSpeed               := HMI_Data.Axis.FeedOut.Setting.CommandVelocity;
DATA_FeedOutAxis.Setting.JogAcc                  := HMI_Data.Axis.FeedOut.Setting.CommandAcceleration;
DATA_FeedOutAxis.Setting.JogDec                  := HMI_Data.Axis.FeedOut.Setting.CommandDeceleration;

// Virtual
DATA_VirtAxis.Setting.AbsPositioningTarget      := HMI_Data.Axis.Virtual.Setting.CommandPosition;
DATA_VirtAxis.Setting.IncPositioningTarget      := HMI_Data.Axis.Virtual.Setting.CommandDistance;
DATA_VirtAxis.Setting.PositioningSpeed          := HMI_Data.Axis.Virtual.Setting.CommandVelocity;
DATA_VirtAxis.Setting.PositioningAcc            := HMI_Data.Axis.Virtual.Setting.CommandAcceleration;
DATA_VirtAxis.Setting.PositioningDec            := HMI_Data.Axis.Virtual.Setting.CommandDeceleration;
DATA_VirtAxis.Setting.HomePos                   := HMI_Data.Axis.Virtual.Setting.HomingPosition;
DATA_VirtAxis.Setting.JogSpeed                  := HMI_Data.Axis.Virtual.Setting.CommandVelocity;
DATA_VirtAxis.Setting.JogAcc                    := HMI_Data.Axis.Virtual.Setting.CommandAcceleration;
DATA_VirtAxis.Setting.JogDec                    := HMI_Data.Axis.Virtual.Setting.CommandDeceleration;

(*------------------------------------------- STATUS -----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)

// FeedIn
HMI_Data.Axis.FeedIn.Status.IsHomed    := FeedIn_Axis.Status.Homed;
HMI_Data.Axis.FeedIn.Status.IsPowered  := FeedIn_Axis.Status.PowerOn;
HMI_Data.Axis.FeedIn.Status.IsOn       := FeedIn_Axis.Status.ServoOn;
HMI_Data.Axis.FeedIn.Status.IsMoving   := NOT DATA_FeedInAxis.Status.StandStill;
HMI_Data.Axis.FeedIn.Status.Error      := DATA_FeedInAxis.Status.Errors;
HMI_Data.Axis.FeedIn.Status.ErrorID    := DATA_FeedInAxis.Feedback.DriveAlarmID;


// FeedOut
HMI_Data.Axis.FeedOut.Status.IsHomed    := FeedOut_Axis.Status.Homed;
HMI_Data.Axis.FeedOut.Status.IsPowered  := FeedOut_Axis.Status.PowerOn;
HMI_Data.Axis.FeedOut.Status.IsOn       := FeedOut_Axis.Status.ServoOn;
HMI_Data.Axis.FeedOut.Status.IsMoving   := NOT DATA_FeedOutAxis.Status.StandStill;
HMI_Data.Axis.FeedOut.Status.Error      := DATA_FeedOutAxis.Status.Errors;
HMI_Data.Axis.FeedOut.Status.ErrorID    := DATA_FeedOutAxis.Feedback.DriveAlarmID;

// Virtual
HMI_Data.Axis.Virtual.Status.IsHomed    := VIRTUAL_Axis.Status.Homed;
HMI_Data.Axis.Virtual.Status.IsPowered  := VIRTUAL_Axis.Status.PowerOn;
HMI_Data.Axis.Virtual.Status.IsOn       := VIRTUAL_Axis.Status.ServoOn;
//HMI_Data.Axis.Virtual.Status.IsMoving   := ;
HMI_Data.Axis.Virtual.Status.Error      := DATA_VirtAxis.Status.Errors;
//HMI_Data.Axis.Virtual.Status.ErrorID    := ;  

(*------------------------------------------ FEEDBACK ----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)

// FeedIn
HMI_Data.Axis.FeedIn.Feedback.Position  := DATA_FeedInAxis.Feedback.ActualPosition;
HMI_Data.Axis.FeedIn.Feedback.Velocity  := DATA_FeedInAxis.Feedback.ActualSpeed;
HMI_Data.Axis.FeedIn.Feedback.Torque    := DATA_FeedInAxis.Feedback.ActualTorque;

// FeedOut
HMI_Data.Axis.FeedOut.Feedback.Position := DATA_FeedOutAxis.Feedback.ActualPosition;
HMI_Data.Axis.FeedOut.Feedback.Velocity := DATA_FeedOutAxis.Feedback.ActualSpeed;
HMI_Data.Axis.FeedOut.Feedback.Torque   := DATA_FeedOutAxis.Feedback.ActualTorque;

// Virtual
HMI_Data.Axis.Virtual.Feedback.Position := DATA_VirtAxis.Feedback.ActualPosition;
HMI_Data.Axis.Virtual.Feedback.Velocity := DATA_VirtAxis.Feedback.ActualSpeed;
HMI_Data.Axis.Virtual.Feedback.Torque   := DATA_VirtAxis.Feedback.ActualTorque;

(*============================================================================================*)
(*                                         TEACH FRAME                                        *)
(*============================================================================================*)

(*---------------------------------------- (HMI to PLC) --------------------------------------*)
HmiFramesData.StartTeach    := HMI_Data.TeachFrame.StartTeach;
HmiFramesData.SelectedFrame := HMI_Data.TeachFrame.SelectedFrame;
HmiFramesData.SelectedPoint := HMI_Data.TeachFrame.SelectedPoint;
HmiFramesData.ConfirmPoint  := HMI_Data.TeachFrame.ConfirmPoint;
HmiFramesData.aTeachFrame[1]:= HMI_Data.TeachFrame.aTeachFrame[1];
HmiFramesData.aTeachFrame[2]:= HMI_Data.TeachFrame.aTeachFrame[2];
vConfig_Offset_FeedIn       := HMI_Data.TeachFrame.vDistVisionRobot_FeedIn;
vConfig_Offset_FeedOut      := HMI_Data.TeachFrame.vDistVisionRobot_FeedOut;


(*---------------------------------------- (PLC to HMI) --------------------------------------*)
HMI_Data.TeachFrame.aFrameResult[1]             := HmiFramesData.aFrameResult[1];
HMI_Data.TeachFrame.aFrameResult[2]             := HmiFramesData.aFrameResult[2];
HMI_Data.TeachFrame.vFrameResult[1]             := vFeedIn_FrameOffset;
HMI_Data.TeachFrame.vFrameResult[2]             := vFeedOut_FrameOffset;

(*============================================================================================*)
(*                                           PROCESS                                          *)
(*============================================================================================*)

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
CycleControls.OperationMode := HMI_Data.Process.Setting.OperationMode;   
//HMI_Data.Process.Setting.PickHeight       : LREAL; // Z pick position 
//HMI_Data.Process.Setting.PlaceHeight      : LREAL; // Z place position
//HMI_Data.Process.Setting.TravelHeight     : LREAL; // Z movement position (safety)

// Tracking parameters
//HMI_Data.Process.Setting.PickStartDist : LREAL; // Start of tracking window - PICK
//HMI_Data.Process.Setting.PickEndDist   : LREAL; // End of tracking window - PICK
//HMI_Data.Process.Setting.PlaceStartDist: LREAL; // Start of tracking window - PLACE
//HMI_Data.Process.Setting.PlaceEndDist  : LREAL; // End of tracking window - PLACE

// Double pick parameters
Gripper1_Offset     := HMI_Data.Process.Setting.Gripper1_Offset;
Gripper2_Offset     := HMI_Data.Process.Setting.Gripper2_Offset;
DoublePlace_Offset  := HMI_Data.Process.Setting.DoublePlace_Offset;

(*------------------------------------------- STATUS -----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)
//HMI_Data.Process.Status.CurrentState
//HMI_Data.Process.Status.Gripper1_State  := SB_do1.Out.PIQ0;
//HMI_Data.Process.Status.Gripper2_State  := SB_do1.Out.PIQ1;
//HMI_Data.Process.Status.PickedCount
//HMI_Data.Process.Status.PlacedCount
//HMI_Data.Process.Status.TrackingActive

HMI_Data.Dashboard.InputOutput.DI0.x0 := DeltaGuardLocked;
HMI_Data.Dashboard.InputOutput.DI0.x1 := CameraGuardLocked;
HMI_Data.Dashboard.InputOutput.DI0.x2 := GreenInputButton;
HMI_Data.Dashboard.InputOutput.DI0.x3 := YellowInputButton;
HMI_Data.Dashboard.InputOutput.DI0.x4 := DI0_4_Spare;
HMI_Data.Dashboard.InputOutput.DI0.x5 := BrakeLockUp;
HMI_Data.Dashboard.InputOutput.DI0.x6 := DI0_6_Spare;
HMI_Data.Dashboard.InputOutput.DI0.x7 := DI0_7_Spare;

HMI_Data.Dashboard.InputOutput.DO0.x0 := xPhysTriggerCamera;
HMI_Data.Dashboard.InputOutput.DO0.x1 := DO0_1_Spare;
HMI_Data.Dashboard.InputOutput.DO0.x2 := GreenLedButton;
HMI_Data.Dashboard.InputOutput.DO0.x3 := YellowLedButton;
HMI_Data.Dashboard.InputOutput.DO0.x4 := MainValveGripper;
HMI_Data.Dashboard.InputOutput.DO0.x5 := SecondaryValveGripper;
HMI_Data.Dashboard.InputOutput.DO0.x6 := LampIn;
HMI_Data.Dashboard.InputOutput.DO0.x7 := LampOut;

HMI_Data.Dashboard.InputOutput.SI0.x0 := safeEmergency_CH0;
HMI_Data.Dashboard.InputOutput.SI0.x1 := safeEmergency_CH1;
HMI_Data.Dashboard.InputOutput.SI0.x2 := safedi_1_DI2;
HMI_Data.Dashboard.InputOutput.SI0.x3 := safedi_1_DI3;

HMI_Data.Dashboard.InputOutput.SI1.x0 := safeDeltaDoor_CH0;
HMI_Data.Dashboard.InputOutput.SI1.x1 := safeDeltaDoor_CH1;
HMI_Data.Dashboard.InputOutput.SI1.x2 := safeCameraDoor_CH0;
HMI_Data.Dashboard.InputOutput.SI1.x3 := safeCameraDoor_CH1;

HMI_Data.Dashboard.InputOutput.SO0.x0 := safePilzSTO_SL;
HMI_Data.Dashboard.InputOutput.SO0.x1 := safePilzSTO_UB;
HMI_Data.Dashboard.InputOutput.SO0.x2 := safePilzSTO_TInv;
HMI_Data.Dashboard.InputOutput.SO0.x3 := safePilzSTO_Spare;

HMI_Data.Dashboard.InputOutput.SO1.x0 := safeOutDeltaDoor;
HMI_Data.Dashboard.InputOutput.SO1.x1 := safeOutCameraDoor;
HMI_Data.Dashboard.InputOutput.SO1.x2 := safeOutSpare2;
HMI_Data.Dashboard.InputOutput.SO1.x3 := safeOutSpare3;

(*============================================================================================*)
(*                                           VISION                                           *)
(*============================================================================================*)

(*------------------------------------------ COMMAND -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
//HMI_Data.Vision.Command.TriggerCamera
//HMI_Data.Vision.Command.ChangeJob

(*------------------------------------------ SETTING -----------------------------------------*)
(*---------------------------------------- (HMI to PLC) --------------------------------------*)
//OffsetVisionRobotWorkspace := HMI_Data.Vision.Setting.DistanceVisionRobotWorkspace;   
//HMI_Data.Process.Setting.PickHeight       : LREAL; // Z pick position 

(*------------------------------------------- STATUS -----------------------------------------*)
(*---------------------------------------- (PLC to HMI) --------------------------------------*)
//HMI_Data.Vision.Status.IsConnected
//HMI_Data.Vision.Status.LastProcTime
//HMI_Data.Vision.Status.TotalPartsFound

//HMI_Data.Vision.LastProduct

(*============================================================================================*)
(*                        TRACKING · CODA PEZZI FEEDIN (pagina HMI)                           *)
(*============================================================================================*)
(* MultiGrpProductData NON e' pubblicato su OPC (IsOpc = False nel DataList): questa sezione
   ne costruisce il "mirror" dentro HMI_Data.Tracking, che invece e' pubblicato insieme a
   HMI_Data. Gira in SlowTask (32 ms), sufficiente per una pagina di monitoraggio.

   Quantita' usate (identiche a quelle della logica di tracking):
     BeltPos[i]      = ActualPosition - RecordedPosition - OffsetCamera
                       (e' la stessa grandezza di "DistanceFromOrigin[1] - OffsetCamera"
                        usata da PickPlaceManager per il pezzo in uso: cresce mentre il
                        pezzo avanza verso il robot)
     WindowStart     = vFeedIn_FrameOffset[1] + DATA_Machine.Setting.TrackingWindowStart (300 mm)
     WindowEnd       = vFeedIn_FrameOffset[1] + DATA_Machine.Setting.TrackingWindowEnd   (450 mm)
     DistToWindow[i] = MAX(0, WindowStart - BeltPos[i])

   I due offset vengono da Init.pou (vedi DT_Machine.Setting): stessa sorgente usata da
   PickPlaceManager per la rampa del nastro, quindi pagina HMI e logica non possono divergere.
*)

HMI_Data.Tracking.WindowStart       := vFeedIn_FrameOffset[1] + DATA_Machine.Setting.TrackingWindowStart;
HMI_Data.Tracking.WindowEnd         := vFeedIn_FrameOffset[1] + DATA_Machine.Setting.TrackingWindowEnd;
HMI_Data.Tracking.BeltSpeedSetpoint := FeedIn_SmoothSpeed;
HMI_Data.Tracking.BeltSpeedActual   := TO_LREAL(DATA_FeedInAxis.Feedback.ActualSpeed);

// --- puntatori dell'anello della coda prodotti ---
iTrackMax  := MultiGrpProductData[0].BufferSize;
IF iTrackMax <= 0 THEN
    iTrackMax := 150;   // default: dimensione impostata in VisionManager
END_IF
iTrackIdx  := MultiGrpProductData[0].UsePointer;    // prossimo pezzo da prelevare
iTrackStop := MultiGrpProductData[0].StorePointer;  // primo posto libero

// pezzi presenti in coda (distanza sull'anello, gestendo il wrap)
iTrackLevel := iTrackStop - iTrackIdx;
IF iTrackLevel < 0 THEN
    iTrackLevel := iTrackLevel + iTrackMax;
END_IF
IF iTrackLevel > iTrackMax THEN
    iTrackLevel := iTrackMax;
END_IF
HMI_Data.Tracking.BufferLevel := iTrackLevel;

// --- azzeramento righe non valide ---
FOR iTrackRow := 0 TO 7 DO
    HMI_Data.Tracking.Id[iTrackRow]           := 0;
    HMI_Data.Tracking.Valid[iTrackRow]        := FALSE;
    HMI_Data.Tracking.X[iTrackRow]            := 0.0;
    HMI_Data.Tracking.Y[iTrackRow]            := 0.0;
    HMI_Data.Tracking.Rz[iTrackRow]           := 0.0;
    HMI_Data.Tracking.BeltPos[iTrackRow]      := 0.0;
    HMI_Data.Tracking.DistToWindow[iTrackRow] := 0.0;
    HMI_Data.Tracking.State[iTrackRow]        := 0;
END_FOR

// --- copia le prime 8 righe della coda (dalla piu' vecchia = prossima al prelievo) ---
iTrackRow := 0;
FOR iTrackLoop := 0 TO 7 DO
    IF (iTrackRow >= iTrackLevel) OR (iTrackIdx < 0) OR (iTrackIdx >= iTrackMax) THEN
        EXIT;
    END_IF

    lrTrackBeltPos := TO_LREAL(DATA_FeedInAxis.Feedback.ActualPosition)
                      - TO_LREAL(MultiGrpProductData[0].ProductDetails[iTrackIdx].RecordedPosition)
                      - TO_LREAL(DATA_Machine.Setting.OffsetCamera);

    HMI_Data.Tracking.Id[iTrackRow]           := iTrackIdx;
    HMI_Data.Tracking.Valid[iTrackRow]        := TRUE;
    HMI_Data.Tracking.X[iTrackRow]            := TO_LREAL(MultiGrpProductData[0].ProductDetails[iTrackIdx].ProductPosition[1]);
    HMI_Data.Tracking.Y[iTrackRow]            := TO_LREAL(MultiGrpProductData[0].ProductDetails[iTrackIdx].ProductPosition[2]);
    HMI_Data.Tracking.Rz[iTrackRow]           := TO_LREAL(MultiGrpProductData[0].ProductDetails[iTrackIdx].ProductPosition[6]);
    HMI_Data.Tracking.BeltPos[iTrackRow]      := lrTrackBeltPos;
    HMI_Data.Tracking.DistToWindow[iTrackRow] := MAX(0.0, HMI_Data.Tracking.WindowStart - lrTrackBeltPos);

    // Stato: 0 QUEUED / 1 IN_WINDOW / 2 TRACKING / 3 PAST
    IF lrTrackBeltPos >= HMI_Data.Tracking.WindowEnd THEN
        iTrackState := 3;
    ELSIF lrTrackBeltPos >= HMI_Data.Tracking.WindowStart THEN
        iTrackState := 1;
    ELSE
        iTrackState := 0;
    END_IF
    // il pezzo in uso dal sequencer (UsePointer) + tracking attivo -> TRACKING
    IF (iTrackState = 1) AND (iTrackIdx = MultiGrpProductData[0].UsePointer) AND KPI_Data.xTrackingActive THEN
        iTrackState := 2;
    END_IF
    HMI_Data.Tracking.State[iTrackRow] := iTrackState;

    // avanza sull'anello
    iTrackIdx := iTrackIdx + 1;
    IF iTrackIdx >= iTrackMax THEN
        iTrackIdx := 0;
    END_IF
    iTrackRow := iTrackRow + 1;
END_FOR

HMI_Data.Tracking.Count := iTrackRow;

// --- NEXT PICK TARGET ---
// 1) primo pezzo in finestra (il piu' avanti, cioe' il piu' vicino a WindowEnd)
// 2) se nessuno e' in finestra: il pezzo in coda piu' avanti (il primo che entrera')
iTrackBest := -1;
FOR iTrackRow := 0 TO 7 DO
    IF HMI_Data.Tracking.Valid[iTrackRow] AND ((HMI_Data.Tracking.State[iTrackRow] = 1) OR (HMI_Data.Tracking.State[iTrackRow] = 2)) THEN
        IF (iTrackBest < 0) OR (HMI_Data.Tracking.BeltPos[iTrackRow] > HMI_Data.Tracking.BeltPos[iTrackBest]) THEN
            iTrackBest := iTrackRow;
        END_IF
    END_IF
END_FOR
IF iTrackBest < 0 THEN
    FOR iTrackRow := 0 TO 7 DO
        IF HMI_Data.Tracking.Valid[iTrackRow] AND (HMI_Data.Tracking.State[iTrackRow] = 0) THEN
            IF (iTrackBest < 0) OR (HMI_Data.Tracking.BeltPos[iTrackRow] > HMI_Data.Tracking.BeltPos[iTrackBest]) THEN
                iTrackBest := iTrackRow;
            END_IF
        END_IF
    END_FOR
END_IF

IF iTrackBest >= 0 THEN
    HMI_Data.Tracking.NextValid        := TRUE;
    HMI_Data.Tracking.NextId           := HMI_Data.Tracking.Id[iTrackBest];
    HMI_Data.Tracking.NextX            := HMI_Data.Tracking.X[iTrackBest];
    HMI_Data.Tracking.NextY            := HMI_Data.Tracking.Y[iTrackBest];
    HMI_Data.Tracking.NextRz           := HMI_Data.Tracking.Rz[iTrackBest];
    HMI_Data.Tracking.NextBeltPos      := HMI_Data.Tracking.BeltPos[iTrackBest];
    HMI_Data.Tracking.NextDistToWindow := HMI_Data.Tracking.DistToWindow[iTrackBest];
ELSE
    HMI_Data.Tracking.NextValid        := FALSE;
    HMI_Data.Tracking.NextId           := 0;
    HMI_Data.Tracking.NextX            := 0.0;
    HMI_Data.Tracking.NextY            := 0.0;
    HMI_Data.Tracking.NextRz           := 0.0;
    HMI_Data.Tracking.NextBeltPos      := 0.0;
    HMI_Data.Tracking.NextDistToWindow := 0.0;
END_IF
