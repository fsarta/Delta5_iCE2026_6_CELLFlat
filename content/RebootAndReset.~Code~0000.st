rtRebootDone_S_Axis(CLK := Y_AX_RebootServo_S_Axis.Done);
rtResetDone_S_Axis(CLK := MC_Reset_S_Axis.Done);
rtRebootDone_L_Axis(CLK := Y_AX_RebootServo_L_Axis.Done);
rtResetDone_L_Axis(CLK := MC_Reset_L_Axis.Done);
rtRebootDone_U_Axis(CLK := Y_AX_RebootServo_U_Axis.Done);
rtResetDone_U_Axis(CLK := MC_Reset_U_Axis.Done);
rtRebootDone_T_Axis(CLK := Y_AX_RebootServo_T_Axis.Done);
rtResetDone_T_Axis(CLK := MC_Reset_T_Axis.Done);
rtRebootDone_B_Axis(CLK := Y_AX_RebootServo_B_Axis.Done);
rtResetDone_B_Axis(CLK := MC_Reset_B_Axis.Done);
rtRebootDone_CI_Axis(CLK := Y_AX_RebootServo_CI_Axis.Done);
rtResetDone_CI_Axis(CLK := MC_Reset_CI_Axis.Done);
rtRebootDone_CO_Axis(CLK := Y_AX_RebootServo_CO_Axis.Done);
rtResetDone_CO_Axis(CLK := MC_Reset_CO_Axis.Done);

// =================================== S_Axis ===================================
Y_AX_RebootServo_S_Axis(
    Axis := S_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[1] AND S_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_S_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_S_Axis', 'S_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_S_Axis.Error, Y_AX_RebootServo_S_Axis.ErrorID, 'RebootAndReset - Reboot_S_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_S_Axis.ErrorID), E_ErrorSeverity#MajorError);		

bEvtOld_Reboot_S_Axis := fbErrorHandler.CheckAndEnqueueEvent(
	(*usiTaskID    *) 2,
	(*bTrigger     *) rtRebootDone_S_Axis.Q,
	(*bOldTriger   *) FALSE,
    (*udiEventID   *) 0,
	(*sSource      *) 'RebootAndReset - Reboot_S_Axis',
	(*sMessage     *) '',
	(*eSeverity    *) E_ErrorSeverity#Info
);
bOld_Reboot_S_Axis := fbErrorHandler.CheckAndEnqueue(
	(*usiTaskID    *) 2,
	(*bCurrentState*) Y_AX_RebootServo_S_Axis.Error,
	(*bOldState    *) bOld_Reboot_S_Axis,
	(*udiErrorID   *) 0,
	(*sSource      *) 'RebootAndReset - Reboot_S_Axis',
	(*sMessage     *) '',
	(*eSeverity    *) E_ErrorSeverity#MajorError
);		


MC_Reset_S_Axis(
    Axis := S_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[1]) OR
               (DATA_Machine.Command.RebootAxis[1] AND S_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_S_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_S_Axis', 'S_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_S_Axis.Error, MC_Reset_S_Axis.ErrorID, 'RebootAndReset - Reset_S_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_S_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[1] := (Y_AX_RebootServo_S_Axis.Done OR DATA_Machine.Command.ResetAxis[1]) AND NOT MC_Reset_S_Axis.Done;

// =================================== L_Axis ===================================
Y_AX_RebootServo_L_Axis(
    Axis := L_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[2] AND L_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_L_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_L_Axis', 'L_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_L_Axis.Error, Y_AX_RebootServo_L_Axis.ErrorID, 'RebootAndReset - Reboot_L_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_L_Axis.ErrorID), E_ErrorSeverity#MajorError);		

MC_Reset_L_Axis(
    Axis := L_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[2]) OR
               (DATA_Machine.Command.RebootAxis[2] AND L_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_L_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_L_Axis', 'L_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_L_Axis.Error, MC_Reset_L_Axis.ErrorID, 'RebootAndReset - Reset_L_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_L_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[2] := (Y_AX_RebootServo_L_Axis.Done OR DATA_Machine.Command.ResetAxis[2]) AND NOT MC_Reset_L_Axis.Done;

// =================================== U_Axis ===================================
Y_AX_RebootServo_U_Axis(
    Axis := U_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[3] AND U_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_U_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_U_Axis', 'U_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_U_Axis.Error, Y_AX_RebootServo_U_Axis.ErrorID, 'RebootAndReset - Reboot_U_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_U_Axis.ErrorID), E_ErrorSeverity#MajorError);		

MC_Reset_U_Axis(
    Axis := U_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[3]) OR
               (DATA_Machine.Command.RebootAxis[3] AND U_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_U_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_U_Axis', 'U_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_U_Axis.Error, MC_Reset_U_Axis.ErrorID, 'RebootAndReset - Reset_U_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_U_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[3] := (Y_AX_RebootServo_U_Axis.Done OR DATA_Machine.Command.ResetAxis[3]) AND NOT MC_Reset_U_Axis.Done;

// =================================== T_Axis ===================================
Y_AX_RebootServo_T_Axis(
    Axis := T_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[4] AND T_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_T_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_T_Axis', 'T_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_T_Axis.Error, Y_AX_RebootServo_T_Axis.ErrorID, 'RebootAndReset - Reboot_T_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_T_Axis.ErrorID), E_ErrorSeverity#MajorError);		

MC_Reset_T_Axis(
    Axis := T_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[4]) OR
               (DATA_Machine.Command.RebootAxis[4] AND T_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_T_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_T_Axis', 'T_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_T_Axis.Error, MC_Reset_T_Axis.ErrorID, 'RebootAndReset - Reset_T_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_T_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[4] := (Y_AX_RebootServo_T_Axis.Done OR DATA_Machine.Command.ResetAxis[4]) AND NOT MC_Reset_T_Axis.Done;

// =================================== B_Axis ===================================
Y_AX_RebootServo_B_Axis(
    Axis := B_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[5] AND B_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_B_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_B_Axis', 'B_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_B_Axis.Error, Y_AX_RebootServo_B_Axis.ErrorID, 'RebootAndReset - Reboot_B_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_B_Axis.ErrorID), E_ErrorSeverity#MajorError);		

MC_Reset_B_Axis(
    Axis := B_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[5]) OR
               (DATA_Machine.Command.RebootAxis[5] AND B_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_B_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_B_Axis', 'B_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_B_Axis.Error, MC_Reset_B_Axis.ErrorID, 'RebootAndReset - Reset_B_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_B_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[5] := (Y_AX_RebootServo_B_Axis.Done OR DATA_Machine.Command.ResetAxis[5]) AND NOT MC_Reset_B_Axis.Done;

// =================================== FeedIn_Axis ===================================
Y_AX_RebootServo_CI_Axis(
    Axis := FeedIn_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[6] AND FeedIn_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_CI_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_CI_Axis', 'CI_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_CI_Axis.Error, Y_AX_RebootServo_CI_Axis.ErrorID, 'RebootAndReset - Reboot_CI_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_CI_Axis.ErrorID), E_ErrorSeverity#MajorError);		

MC_Reset_CI_Axis(
    Axis := FeedIn_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[6]) OR
               (DATA_Machine.Command.RebootAxis[6] AND FeedIn_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_CI_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_CI_Axis', 'CI_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_CI_Axis.Error, MC_Reset_CI_Axis.ErrorID, 'RebootAndReset - Reset_CI_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_CI_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[6] := (Y_AX_RebootServo_CI_Axis.Done OR DATA_Machine.Command.ResetAxis[6]) AND NOT MC_Reset_CI_Axis.Done;

// =================================== FeedOout_Axis ===================================
Y_AX_RebootServo_CO_Axis(
    Axis := FeedOut_Axis, 
    Execute := DATA_Machine.Command.RebootAxis[7] AND FeedOut_Axis.Status.Alarm AND SystemControls.AllMotorsServoOff 
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtRebootDone_CO_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reboot_CO_Axis', 'CO_Axis has been rebooted', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(Y_AX_RebootServo_CO_Axis.Error, Y_AX_RebootServo_CO_Axis.ErrorID, 'RebootAndReset - Reboot_CO_Axis', fbErrorHandler.GetErrorMessage(Y_AX_RebootServo_CO_Axis.ErrorID), E_ErrorSeverity#MajorError);		

MC_Reset_CO_Axis(
    Axis := FeedOut_Axis, 
    Execute := (DATA_Machine.Command.ResetAxis[7]) OR
               (DATA_Machine.Command.RebootAxis[7] AND FeedOut_Axis.Status.Warning)
    //Done => BOOL, 
    //Busy => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT
);
IF rtResetDone_CO_Axis.Q THEN
    fbErrorHandler.LogEvent(0, 'RebootAndReset - Reset_CO_Axis', 'CO_Axis has been reset', E_ErrorSeverity#Info);		
END_IF;
//fbErrorHandler.AddUpdateError(MC_Reset_CO_Axis.Error, MC_Reset_CO_Axis.ErrorID, 'RebootAndReset - Reset_CO_Axis', fbErrorHandler.GetErrorMessage(MC_Reset_CO_Axis.ErrorID), E_ErrorSeverity#MajorError);		

DATA_Machine.Command.ResetAxis[7] := (Y_AX_RebootServo_CO_Axis.Done OR DATA_Machine.Command.ResetAxis[7]) AND NOT MC_Reset_CO_Axis.Done;


// =================================== AllMotorsServoOff ===================================
SystemControls.AllMotorsServoOff := NOT(S_Axis.Status.ServoOn) AND
                                    NOT(L_Axis.Status.ServoOn) AND
                                    NOT(U_Axis.Status.ServoOn) AND
                                    NOT(T_Axis.Status.ServoOn) AND
                                    NOT(B_Axis.Status.ServoOn) AND
                                    NOT(FeedIn_Axis.Status.ServoOn) AND
                                    NOT(FeedOut_Axis.Status.ServoOn);

// =================================== AllMotorsServoOn ====================================
SystemControls.AllMotorsServoOn := S_Axis.Status.ServoOn AND
                                    L_Axis.Status.ServoOn AND
                                    U_Axis.Status.ServoOn AND
                                    T_Axis.Status.ServoOn AND
                                    B_Axis.Status.ServoOn AND
                                    FeedIn_Axis.Status.ServoOn AND
                                    FeedOut_Axis.Status.ServoOn;
                                 
// =================================== ServoMotorsAlarm ===================================
SystemControls.ServoMotorsAlarm := S_Axis.Status.Alarm OR S_Axis.Status.Warning OR
                                   L_Axis.Status.Alarm OR L_Axis.Status.Warning OR
                                   U_Axis.Status.Alarm OR U_Axis.Status.Warning OR
                                   T_Axis.Status.Alarm OR T_Axis.Status.Warning OR
                                   B_Axis.Status.Alarm OR B_Axis.Status.Warning OR
                                   FeedIn_Axis.Status.Alarm OR FeedIn_Axis.Status.Warning OR
                                   FeedOut_Axis.Status.Alarm OR FeedOut_Axis.Status.Warning;                               