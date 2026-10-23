// Inizializzazione iniziale
IF State_MachineController = E_MachineState#INIT THEN
    State_MachineController := E_MachineState#IDLE;
    // Reset output di default
    DATA_Delta.Command.GroupControl.Enable := FALSE;
    DATA_Delta.Command.GroupControl.En_Group := FALSE;
    DATA_Delta.Command.GroupControl.En_Power := FALSE;
    DATA_FeedInAxis.Command.Enable := FALSE;
    DATA_FeedOutAxis.Command.Enable := FALSE;
    DATA_VirtAxis.Command.Enable := FALSE;
    MovementAllowed := FALSE;
    DATA_Delta.Command.En_EmergencyGroupStop := FALSE;
    DATA_FeedInAxis.Command.EmergencyStop := FALSE;
    DATA_FeedOutAxis.Command.EmergencyStop := FALSE;
    DATA_VirtAxis.Command.EmergencyStop := FALSE;
END_IF;

IF HmiFramesData.StartTeach AND (State_MachineController = E_MachineState#IDLE OR State_MachineController = E_MachineState#OPERATIONAL_MANUAL) THEN 
    State_MachineController := E_MachineState#TEACH_FRAME;
END_IF

// AUTOCYCLE: automatic cycle enable latch (Start/Stop Cycle, automatic mode only).
// Outside OPERATIONAL_AUTOMATIC, latch = FALSE: when the machine enters automatic mode, it is READY
// but STATIONARY (the cycle only starts with Start Cycle).
IF State_MachineController <> E_MachineState#OPERATIONAL_AUTOMATIC THEN
    G_bAutoCycleRunning := FALSE;
END_IF;


// Macchina a stati principale
CASE State_MachineController OF
    E_MachineState#IDLE: 
        THIS.HandleIdleState();
        
    E_MachineState#TEACH_FRAME: 
        THIS.HandleTeachFrameState();
        
    E_MachineState#POWERING_UP: 
        THIS.HandlePowerUpState();
        
    E_MachineState#HOMING: 
        THIS.HandleHomingState();
        
    E_MachineState#WAIT_FOR_COMMISSIONING:
        THIS.HandleCommissioningState();
                
    E_MachineState#OPERATIONAL_AUTOMATIC:
        THIS.HandleAutomaticState();
        
    E_MachineState#OPERATIONAL_MANUAL:
        THIS.HandleManualState();
        
    E_MachineState#STOPPING:
        THIS.HandleStoppingState();
        
    E_MachineState#UNPOWERING:
        THIS.HandleUnpoweringState();
        
    E_MachineState#SHUTDOWN:
        THIS.HandleShutdownState();
        
    E_MachineState#ERROR:
        THIS.HandleErrorState();
END_CASE;

//IF G_stOverallErrorStatus.bAnyErrorActive THEN
//    NextState := E_MachineState#ERROR;
//    bTransition := TRUE;
//END_IF;

// Gestione transizione
IF bTransition THEN
    State_MachineController := NextState;
    bTransition := FALSE;
END_IF;