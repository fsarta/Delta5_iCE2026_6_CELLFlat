(* -------- START OF PRG_Manager IMPLEMENTATION -------- *)

// 1. Read HMI and System Inputs 
bHMI_Start := CycleControls.StartCycle;
bHMI_Stop := CycleControls.StopCycle;
eHMI_OperationMode := CycleControls.OperationMode; 

// 2. Detect Start Button press
trigStart(CLK := bHMI_Start);
rtStopCycle(CLK := bHMI_Stop);   // 

// AUTOCYCLE: Stop Cycle latch (soft stop). The current cycle ends and the robot
// moves to the parking position (StopCycleEnabled); the latch remains active until
// Start Cycle is pressed or the automatic mode is exited.
IF rtStopCycle.Q THEN
    bStopCycleLatch := TRUE;
END_IF;
IF trigStart.Q OR NOT(StartPickPlace_Delta) THEN
    bStopCycleLatch := FALSE;
END_IF;


// 3. Reset piece counter if the FB signals Place is complete
IF FB_PickPlace_Sequencer1.bPlaceCycleComplete THEN
    iPartOnGripper := 0;
END_IF;

// 4. Handle Stop/AutoMode OFF
IF NOT(StartPickPlace_Delta) OR bHMI_Stop OR NOT G_bAutoCycleRunning THEN
    // System is stopped or not in auto
    iPartOnGripper := 0;       // Reset counter
    bStartCmd := FALSE;  // Ensure no start pulse is sent
ELSE
    // --- CONTINUOUS CYCLE LOGIC (AutoMode is ON and NOT Stopped) ---
    IF FB_PickPlace_Sequencer1.bSM_isIdle THEN
        
        // --- Single Pick Mode Logic ---
        IF eHMI_OperationMode = E_PickPlaceMode#MODE_SINGLE_PICK THEN
            IF iPartOnGripper = 0 THEN // Gripper is empty, good to go
                iGripperToUseCmd := 0;
                bDoubleModeCmd := FALSE;
                bStartCmd := TRUE; // Send the pulse
            END_IF;
        
        // --- Double Pick Mode Logic ---
        ELSIF eHMI_OperationMode = E_PickPlaceMode#MODE_DOUBLE_PICK THEN
            IF iPartOnGripper = 0 THEN // Gripper empty, pick Piece 1
                iGripperToUseCmd := 0;
                bDoubleModeCmd := TRUE;
                bStartCmd := TRUE; // Send the pulse
                iPartOnGripper := 1; // We now have 1 piece
                
            ELSIF iPartOnGripper = 1 THEN // Gripper has 1, pick Piece 2
                iGripperToUseCmd := 1;
                bDoubleModeCmd := TRUE;
                bStartCmd := TRUE; // Send the pulse
                iPartOnGripper := 2; // We now have 2 pieces
            END_IF;
        END_IF;
    END_IF;
END_IF;

// 5. Call the Function Block 
FB_PickPlace_Sequencer1(
    (* --- Axis & Group References --- *)
    GroupRef := DELTA,
    FeedInRef := FeedIn_Axis,
    FeedOutRef := FeedOut_Axis,
    
    (* --- Machine Data & Settings --- *)
    //DATA_Machine := DATA_Machine,
    //DATA_Group := DATA_Delta,
    //DATA_FeedInAxis := DATA_FeedInAxis,
    //DATA_FeedOutAxis := DATA_FeedOutAxis,
    RobotJog := RobotJog, 
    
    (* --- Commands from Manager --- *)
    StartCycle := bStartCmd,
    bDoubleMode := bDoubleModeCmd,
    iGripperToUse := iGripperToUseCmd,
    StopCycleEnabled := bHMI_Stop OR bStopCycleLatch,   // AUTOCYCLE: end cycle parking 
    
    (* --- System & Mode Inputs --- *)
    StartPickPlace := StartPickPlace_Delta,
    bAutoModeSelected := bAutoModeSelected,
    bManualModeSelected := bManualModeSelected,
    bResetAllErrors := G_bResetAllErrors,
    bAcknowledgeAllErrors := G_bAcknowledgeAllErrors,
    
    (* --- Data & Frame Inputs --- *)
    IO_stPickPlaceProductData_Pick := stPickPlaceProductData_Pick,
    IO_stPickPlaceProductData_Place := stPickPlaceProductData_Place,
    Frame_FeedIn := Frame_FeedIn,
    Frame_FeedOut := Frame_FeedOut,
    rDetectedProducts := rDetectedProducts,
    
    (* --- Gripper Offset Parameters --- *)
    stGripper1_Offset := Gripper1_Offset,
    stGripper2_Offset := Gripper2_Offset
        
    (* --- FB Outputs (Read-only) --- *)
    // bSM_isIdle => 
    // bPlaceCycleComplete => 
    // bActivateGripper1 => 
    // bActivateGripper2 => 
    // PickPlace_Status => PickPlace_Status 
    // PickPlace_Error => PickPlace_Error 
    // bInSync => bInSync 
    // bTestGroupBlendCmd => bTestGroupBlendCmd 
    // GroupNumber => GroupNumber 
    // ConveyorNumber => ConveyorNumber 
);

FB_ConveyorController1(
    enable          := StartPickPlace_Delta AND G_bAutoCycleRunning,
    in_sync         := DATA_Machine.Status.InSyncPick_Delta,
    distance        := MonitorStatusData[0].DistanceFromOrigin[1] - DATA_Machine.Setting.OffsetCamera,

    (* Parametri – idealmente da struttura dati macchina *)
    v_nominal       := HMI_Data.Axis.FeedIn.Setting.CommandVelocity, //DATA_Machine.ConveyorNominalSpeed,
    v_min           := 50.0, //DATA_Machine.ConveyorMinSpeed,
    tracking_start  := vFeedIn_FrameOffset[1] + 300.0, //DATA_Machine.TrackingStart,
    tracking_end    := vFeedIn_FrameOffset[1] + 450.0, //DATA_Machine.TrackingEnd,
    max_error       := max_error, //DATA_Machine.TrackingMaxError,
    end_zone_margin := end_zone_margin, //DATA_Machine.EndZoneMargin,
    dec_min         := 100.0, //DATA_Machine.DecMin,
    dec_max         := HMI_Data.Axis.FeedIn.Setting.CommandDeceleration, //DATA_Machine.DecMax,
    acc_min         := 100.0, //DATA_Machine.AccMin,
    acc_max         := HMI_Data.Axis.FeedIn.Setting.CommandAcceleration, //DATA_Machine.AccMax
    speed_setpoint  => FeedIn_SmoothSpeed,
    acceleration    => FeedIn_SmoothAcceleration,
    deceleration    => FeedIn_SmoothDeceleration,
    tracking_active =>,
    end_zone_active =>
);

// 6. Map FB Outputs to Physical Hardware
IF FB_PickPlace_Sequencer1.eStepResult = E_StepStatus#ERROR THEN
    MainValveGripper := FALSE;
    SecondaryValveGripper := FALSE; 
ELSE
    MainValveGripper := FB_PickPlace_Sequencer1.bActivateGripper1;
    SecondaryValveGripper := FB_PickPlace_Sequencer1.bActivateGripper2; 
END_IF
