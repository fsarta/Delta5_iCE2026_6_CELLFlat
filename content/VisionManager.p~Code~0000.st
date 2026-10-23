xEnableEncoderTrigger   := TRUE;
xEnableCyclicMode       := FALSE;
rDistanceSetpoint       := 140.0;

// ============================================================================
// SYNC TRIGGER FISICO + LATCH SERVO (MC_TouchProbe)
// ============================================================================
// Configuration 
xUsePhysTrigger   := TRUE;    // TRUE  = physical trigger via SLIO output + servo latch (recommended)
                              // FALSE = original mode (trigger via EIP + software sampling)
tPhysTriggerPulse := T#10MS;  // Pulse width on the DO SLIO: >= the minimum required by the camera
                              // (see the chamber manual; typically 0.1 to 10 ms)

// Initial scan: touch probe configuration (MC_TRIGGER_REF) for the tape axis
IF NOT xSyncInit THEN
    xSyncInit := TRUE;
    DATA_FeedInAxis.Setting.TouchProbeTriggerInput.Bit := UINT#1; // latch signal bit
    DATA_FeedInAxis.Setting.TouchProbeTriggerInput.ID  := UINT#0; // Unique trigger ID
    DATA_FeedInAxis.Command.TouchProbe := FALSE;              // probe control off
END_IF;

// Cattura la posizione AGGANCIATA sul fronte di TouchProbeDone
// (va fatto PRIMA della call a fbVisionApp: il valore deve essere fresco
//  quando il FB vede il fronte del latch)
rtTouchProbeDone(CLK := DATA_FeedInAxis.Status.TouchProbeDone);
IF rtTouchProbeDone.Q THEN
    rLatchedBeltPos := DATA_FeedInAxis.Feedback.TouchProbeRecPos;
END_IF;

// --- 1. Call the Vision Application ---
// This one function call runs the entire vision system.
fbVisionApp(
    // --- Link Commands ---
    xEnable                 := xVision_StartCycle,
    xOneShot                := FALSE,
    xResetError             := G_bResetAllErrors,
    
    // --- Link Trigger Configuration (Time-based) ---
    xEnableCyclicTrigger    := xEnableCyclicMode,
    tCyclicTriggerTime      := tMyCyclicTime,
    
    // --- Link Trigger Configuration (Distance-based) ---
    // Questi sono i parametri per l'algoritmo in millimetri che abbiamo creato all'inizio!
    xEnableDistanceTrigger  := xEnableEncoderTrigger, // Es. abilitato da HMI o da una fotocellula
    rConveyorCurrentPos     := DATA_FeedInAxis.Feedback.ActualPosition,    // La lettura attuale in mm dal tuo asse/encoder
    rDistanceSetpoint       := rDistanceSetpoint,                  // Distance Trigger 
    
     // --- Link Sync Hardware (attuatore fisico SLIO + servo con blocco tramite MC_TouchProbe) ---
    xUsePhysTrigger   := xUsePhysTrigger,
    tPhysTriggerPulse := tPhysTriggerPulse,
    rLatchedPosition  := rLatchedBeltPos,                        // Belt position: LATCHED
    xTouchProbeDone   := DATA_FeedInAxis.Status.TouchProbeDone,  // latch held
    xTouchProbeError  := DATA_FeedInAxis.Error.TouchProbe_Err,   // touch probe error

    // --- Link Global I/O Variables ---
    VisorEIP_Receive        := VisorEIP_Receive,
    i_stConnectionStatus    := VisorSensoPart_1_ConnectionState,
    
    // 
    VisorEIP_Transmit       => VisorEIP_Transmit,
    
    rTriggeredPosition      => rTriggeredPos,
    xDone                   => xVisionCycleDone    
);

// ============================================================================
// SYNC: arm/disarm probe + physical pulse (after the call: use the FB outputs)
// ============================================================================
// Arm/disarm di MC_TouchProbe (MC_TouchProbe_1 in fbAxisController_CIAxis,
// (FeedIn axis): a rising edge on Command.TouchProbe arms the probe for a latch
DATA_FeedInAxis.Command.TouchProbe := fbVisionApp.xArmTouchProbe;

// Physical trigger pulse: in iCE, this global variable must be mapped to the DO output
// of the SLIO module (the same output is also wired to the servo’s latch input)
xPhysTriggerCamera := fbVisionApp.xPhysTrigger;

rTrigVisionDone(CLK := xVisionCycleDone);

// 2. Controllo se la Visione ha finito un ciclo di acquisizione      
IF rTrigVisionDone.Q THEN
    bNewVisionDataReady := TRUE;    
    FOR i := 0 TO 3 DO
        aBuffer_X[i]  := fbVisionApp.stCurrentResult.Pos_X[i];
        aBuffer_Y[i]  := fbVisionApp.stCurrentResult.Pos_Y[i];
        aBuffer_Rz[i] := fbVisionApp.stCurrentResult.Angle_Rz[i];
    END_FOR
END_IF;

// The data buffer has 4 slots per coordinate: this limits Part_Count to 4
iPartCount := fbVisionApp.stCurrentResult.Part_Count;
//IF iPartCount > 4 THEN
//    fbErrorHandler.LogEvent(0, 'VisionManager', 'Part_Count > 4: only first 4 products used', E_ErrorSeverity#Warning);
//    iPartCount := 4;
//END_IF;

// KPI: contatori ciclo visione (usati da FB_KPI, vedi KPI/GUIDA_KPI.md)
IF rTrigVisionDone.Q THEN
    G_udiVisionCycles := G_udiVisionCycles + 1;
    IF iPartCount = 0 THEN
        G_udiVisionEmptyPhotos := G_udiVisionEmptyPhotos + 1;
    END_IF;
    G_udiProductsDetected := G_udiProductsDetected + TO_UDINT(iPartCount);
END_IF;

// KPI: tempo di elaborazione visione (dal fronte del trigger fisico al done)
rtTrigPhys(CLK := fbVisionApp.xPhysTrigger);
tonVisionProc(IN := bVisionProcMeas, PT := T#10S);
IF rtTrigPhys.Q THEN
    bVisionProcMeas := TRUE;
ELSIF rTrigVisionDone.Q THEN
    IF bVisionProcMeas THEN
        G_tVisionLastProcTime := tonVisionProc.ET;
    END_IF;
    bVisionProcMeas := FALSE;
ELSIF tonVisionProc.Q THEN
    bVisionProcMeas := FALSE;
END_IF;


fbFormatProductData(
    Execute          := bNewVisionDataReady AND NOT fbFormatProductData.Busy,
    DetectedProducts := TO_REAL(TO_INT(fbVisionApp.stCurrentResult.Part_Count)), 
    ProductX := aBuffer_X, 
    ProductY := aBuffer_Y, 
    // ProductZ := Yt_RealArray50, 
    // ProductRx := Yt_RealArray50, 
    // ProductRy := Yt_RealArray50, 
    ProductRz := aBuffer_Rz, 
    // ProductType := Yt_RealArray50, 
    // ProductUserData := Yt_RealArray50, 
    Done => bFormatDone, 
    Busy => bFormatBusy, 
    Error => bFormatError, 
    ErrorID => uiFormatErrorID, 
    FormattedProductData := InputProductData
);

IF bFormatBusy OR bFormatDone THEN
    bNewVisionDataReady := FALSE;
END_IF

// formatting/distribution errors -> MajorError alerts
//bFormatErrorOld := fbErrorHandler.CheckAndEnqueue(
//    2,
//    bFormatError,
//    bFormatErrorOld,
//    uiFormatErrorID,
//    'VisionManager - MyFormatProductData',
//    'Product data formatting error',
//    E_ErrorSeverity#MajorError
//);

//bDistributionErrorOld := fbErrorHandler.CheckAndEnqueue(
//    2,
//    bDistributionError,
//    bDistributionErrorOld,
//    uiDistributionErrorID,
//    'VisionManager - fbSequenceDistribution',
//    'Product distribution error',
//    E_ErrorSeverity#MajorError
//);

rTrigFormatDone(CLK := bFormatDone);

PartOptions.DuplicateDetect := TRUE;
PartOptions.DuplicateMinDifference := 250.0;
PartOptions.Sort := TRUE;
PartOptions.SortBy := Yt_TCPCoordinate#X;
PartOptions.SortOrder := Yt_SortOrder#Ascending;
DistributionConfig[0].ConveyorBelt := FeedIn_Axis;
DistributionConfig[0].SequenceDistribution.SequenceLength := 1;
DistributionConfig[0].SequenceDistribution.SequencePattern[0] := 0;
MultiGrpProductData[0].BufferSize := INT#150;

fbSequenceDistribution(
    Execute := rTrigFormatDone.Q, 
    TriggerConveyorPosition := fbVisionApp.rTriggeredPosition, 
    ProductOptions := PartOptions, 
    Done => bDistributionDone, 
    Busy => bDistributionBusy, 
    Error => bDistributionError, 
    ErrorID => uiDistributionErrorID, 
    ConveyorBelt := FeedIn_Axis, 
    InputProductData := InputProductData, 
    MultiGroupProductData := MultiGrpProductData, 
    DistributionConfig := DistributionConfig
);

// vision error -> MajorError alarm (the machine automatically enters STOPPING mode; see FB_MachineController)
//bVisionErrorOld := fbErrorHandler.CheckAndEnqueue(
//    2,
//    fbVisionApp.xError,
//    bVisionErrorOld,
//    0,
//    'VisionManager - FB_VisionApplication',
//    'Vision application error',
//    E_ErrorSeverity#MajorError
//);

IF fbVisionApp.xError THEN
    // TODO: Add logic here
    // e.g., SetMachineAlarm( 'Vision System Error' );
END_IF;

fbMultiGrpProductMonitor(
    Enable := PartsInBuffer, 
    Valid => MonitorValid, 
    // Error => BOOL, 
    // ErrorID => UINT, 
    MultiGroupProductData := MultiGrpProductData, 
    MonitorThreshholdData := MonitorThresholdData, 
    MonitorStatusData := MonitorStatusData
);