(*
METHOD: State handler for POWERING_UP state
DESCRIPTION: 
Implements motor enable sequence and monitors for completion.
*)

fbPowerUpTimer(IN := TRUE, PT := T#5S);

// Activate motor enable
DATA_Delta.Command.GroupControl.Enable := TRUE;
DATA_Delta.Command.GroupControl.En_Group := TRUE;
DATA_Delta.Command.GroupControl.En_Power := TRUE;

DATA_FeedInAxis.Command.Enable := TRUE;
DATA_FeedOutAxis.Command.Enable := TRUE;
DATA_VirtAxis.Command.Enable := TRUE;

bServosNotReady := NOT(S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                   T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);
                   
// Transition to next state based on enable result
IF bServosNotReady THEN
    DATA_Delta.Command.GroupControl.AlarmClear := TRUE;
    DATA_FeedInAxis.Command.ResetFault := TRUE;
    DATA_FeedOutAxis.Command.ResetFault := TRUE;
    
ELSIF DATA_Delta.Status.GroupControl.GroupStatus AND 
   DATA_Delta.Status.GroupControl.PowerStatus AND 
   DATA_FeedInAxis.Status.Enabled AND 
   DATA_FeedOutAxis.Status.Enabled AND
   DATA_VirtAxis.Status.Enabled THEN
    DATA_Delta.Command.GroupControl.AlarmClear := FALSE;
    DATA_FeedInAxis.Command.ResetFault := FALSE;
    DATA_FeedOutAxis.Command.ResetFault := FALSE;
    fbPowerUpTimer(IN := FALSE);
    NextState := E_MachineState#HOMING;
    bTransition := TRUE;
    //fbErrorHandler.LogEvent(0, 'FB_MachineControl - PowerUpState', 'Power up completed, transitioning to HOMING', E_ErrorSeverity#Info);
    bPowerUpStateEventOldState := fbErrorHandler.CheckAndEnqueueEvent(
        (*usiTaskID  *) 2,                                              
        (*bTrigger   *) TRUE,                                           
        (*bOldTrigger*) bPowerUpStateEventOldState,                     
        (*udiEventID *) 0,                                              
        (*sSource    *) 'FB_MachineControl - PowerUpState',             
        (*sMessage   *) 'Power up completed, transitioning to HOMING',  
        (*eSeverity  *) E_ErrorSeverity#Info                            
    );

ELSIF DATA_Delta.Error.GroupControl.Error OR
   DATA_FeedInAxis.Error.AxCtrl_Err OR
   DATA_FeedOutAxis.Error.AxCtrl_Err OR
   DATA_VirtAxis.Error.AxCtrl_Err THEN
    fbPowerUpTimer(IN := FALSE);
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - PowerUpState', 'Power up failed', E_ErrorSeverity#MajorError);    

END_IF;

IF fbPowerUpTimer.Q OR
   S_Axis.Status.Alarm OR 
   L_Axis.Status.Alarm OR
   U_Axis.Status.Alarm OR
   T_Axis.Status.Alarm OR
   (*B_Axis.Status.Alarm OR*)
   FeedIn_Axis.Status.Alarm OR
   FeedOut_Axis.Status.Alarm THEN
    fbPowerUpTimer(IN := FALSE);
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - PowerUpState', 'Power up failed', E_ErrorSeverity#MajorError);    
    bPowerUpStateOldError := fbErrorHandler.CheckAndEnqueue(
        (*usiTaskID    *) 2,                                 
        (*bCurrentState*) TRUE,                              
        (*bOldState    *) bPowerUpStateOldError,             
        (*udiErrorID   *) 0,                                 
        (*sSource      *) 'FB_MachineControl - PowerUpState',
        (*sMessage     *) 'Power up failed',                 
        (*eSeverity    *) E_ErrorSeverity#MajorError         
    );
END_IF;