(*
METHOD: State handler for TEACH_FRAME state
DESCRIPTION: 
    Manages the 3-Point Frame calibration procedure.
    Allows operations with Servos ON (Jogging) or Servos OFF (Manual Dragging).
    Executes external mathematical calculation upon sequence completion.
*)

// ===========================================================================
// 0. INPUT UPDATE 
// ===========================================================================

// R_TRIG for confirm button
rtConfirmPoint(CLK := HmiFramesData.ConfirmPoint);

// ===========================================================================
// 1. POWER STATUS CHECK
// ===========================================================================

bServosAreActive := (S_Axis.Status.ServoOn AND L_Axis.Status.ServoOn AND U_Axis.Status.ServoOn AND 
                   T_Axis.Status.ServoOn AND (*B_Axis.Status.ServoOn AND*) FeedIn_Axis.Status.ServoOn AND FeedOut_Axis.Status.ServoOn);
                   
bServoOFF_TeachFrame := NOT bServosAreActive;
bServoON_TeachFrame  := bServosAreActive;

IF bServoOFF_TeachFrame THEN
    //fbErrorHandler.LogEvent(0, 'FB_MachineControl - TeachFrameState', 'Teaching in Free-Drag Mode (Servos OFF)', E_ErrorSeverity#Info);
    ;
ELSIF bServoON_TeachFrame THEN
    //fbErrorHandler.LogEvent(0, 'FB_MachineControl - TeachFrameState', 'Teaching in Jog Mode (Servos ON)', E_ErrorSeverity#Info);
    ;
ELSE
    NextState := E_MachineState#ERROR;
    bTransition := TRUE;
    //fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - TeachFrameState', 'Teach frame failed', E_ErrorSeverity#MajorError); 
    RETURN;   
END_IF;

// ===========================================================================
// 2. EXIT LOGIC 
// ===========================================================================

// If the HMI removes the "StartTeach" signal, exit the mode.
IF NOT(HmiFramesData.StartTeach) THEN
    
    // Reset FB Transform
    fbFrameTransform(
        Execute := FALSE, 
        FrameCoordinates := stRawVector
    );
    
    // Determine Destination based on Power Status
    IF bServoON_TeachFrame THEN
        NextState := E_MachineState#OPERATIONAL_MANUAL;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - TeachFrameState', 'Aborted. Servos ON -> Going to MANUAL.', E_ErrorSeverity#Info);
    ELSE
        NextState := E_MachineState#IDLE;
        fbErrorHandler.LogEvent(0, 'FB_MachineControl - TeachFrameState', 'Aborted. Servos OFF -> Going to IDLE.', E_ErrorSeverity#Info);
    END_IF;
    
    bTransition := TRUE;
    RETURN;
END_IF;

// ===========================================================================
// 3. TEACH POINT EXECUTION
// ===========================================================================

// Frame Selection 
iTargetFrame := HmiFramesData.SelectedFrame;

// Ensure a valid target is selected (Infeed or Outfeed)
IF (iTargetFrame < 1) OR (iTargetFrame > 2) THEN
    //fbErrorHandler.AddUpdateError(TRUE, 0, 'FB_MachineControl - TeachFrameState', 'No frame selected correctly (Infeed/Outfeed).', E_ErrorSeverity#Warning);
    RETURN; 
END_IF;

// Get actual MCS position and convert in cartesian coordinates
fbVectorToCart(
    Vector := DATA_Delta.Feedback.ActualPos_Group.MCS, 
    CartesianRef => stActualPosition
);

// FeedIn frame
IF iTargetFrame = 1 THEN
    fbTeachFrame(
        FramesData  := HmiFramesData,
        Execute     := rtConfirmPoint.Q,
        FrameIndex  := iTargetFrame, 
        CurrentPos  := stActualPosition,
        PointSelect := HmiFramesData.SelectedPoint
    );
// FeedOut frame    
ELSIF iTargetFrame = 2 THEN
    fbTeachFrame(
        FramesData  := HmiFramesData,
        Execute     := rtConfirmPoint.Q,
        FrameIndex  := iTargetFrame,
        PointSelect := HmiFramesData.SelectedPoint,
        CurrentPos  := stActualPosition
    );
END_IF;

// ===========================================================================
// 4. TRIGGER CALCULATION
// ===========================================================================

// If the operator has just confirmed a point, we activate the recalculation request.
IF rtConfirmPoint.Q THEN
    bCalcReq := TRUE;
    
    // Immediate handshake: We tell the HMI "Received"
    HmiFramesData.ConfirmPoint := FALSE;
END_IF;

// ===========================================================================
// 5. EXECUTE CALCULATION
// ===========================================================================

IF bCalcReq THEN
    
    // ---------------------------------------------------------
    // STEP A: Base Frame Calculation (3 Points)
    // ---------------------------------------------------------
    
    IF NOT bApplyOffsetReq THEN
    
        // Input of fbFrameTransform
        fbFrameTransform.OO := HmiFramesData.aFrameResult[iTargetFrame].OO;
        fbFrameTransform.XX := HmiFramesData.aFrameResult[iTargetFrame].XX;
        fbFrameTransform.XY := HmiFramesData.aFrameResult[iTargetFrame].XY;
    
        fbFrameTransform.Execute := TRUE;  
        
        fbFrameTransform(FrameCoordinates := stRawVector);
            
        IF fbFrameTransform.Done THEN
            fbFrameTransform.Execute := FALSE; 
            bApplyOffsetReq := TRUE;   
                    
        ELSIF fbFrameTransform.Error THEN
            fbFrameTransform.Execute := FALSE;
            bCalcReq := FALSE; 
            //fbErrorHandler.AddUpdateError(TRUE, fbFrameTransform.ErrorID, 'FB_MachineControl - TeachFrameState', 'Frame Calculation Failed (Check Points)', E_ErrorSeverity#MajorError);
        END_IF
        
    END_IF;
    
    // ---------------------------------------------------------
    // STEP B: Offset 
    // ---------------------------------------------------------
    
    IF bApplyOffsetReq THEN
        
        // 1. Frame Offset selection (Infeed o Outfeed)
        IF iTargetFrame = 1 THEN
            vOffsetToApply := vConfig_Offset_FeedIn; // Offset specifico per Infeed
        ELSIF iTargetFrame = 2 THEN
            vOffsetToApply := vConfig_Offset_FeedOut; // Offset specifico per Outfeed
        END_IF;
        
        // 2. Y_MA_CalcFrameOffset
        
        fbCalcOffset(
            Enable      := TRUE, 
            InputFrame  := stRawVector,  
            Offset      := vOffsetToApply, 
            OutputFrame := vResultFrame    
        );
        
        // 3. Result
        IF fbCalcOffset.Valid THEN
        
            // A. Convert Vector -> Cartesian
            fbVectorToCart(
                Vector       := vResultFrame, 
                CartesianRef => stFinalFrameRef
            );
            
            // B. Save the frame to the correct variable
            IF iTargetFrame = 1 THEN
                FeedIn_FrameOffset := stFinalFrameRef;
                vFeedIn_FrameOffset := vResultFrame;
                fbErrorHandler.LogEvent(0, 'FB_MachineControl - TeachFrameState', 'FeedIn Frame Updated.', E_ErrorSeverity#Info);
            ELSIF iTargetFrame = 2 THEN
                FeedOut_FrameOffset := stFinalFrameRef;
                vFeedOut_FrameOffset := vResultFrame;
                fbErrorHandler.LogEvent(0, 'FB_MachineControl - TeachFrameState', 'FeedOut Frame Updated.', E_ErrorSeverity#Info);
            END_IF;
        
            // C. Reset cycle
            fbCalcOffset.Enable := FALSE;
            bApplyOffsetReq  := FALSE;
            //bCalcReq         := FALSE; 
            HmiFramesData.StartTeach := FALSE;
        
            IF bServoON_TeachFrame THEN
                NextState := E_MachineState#OPERATIONAL_MANUAL;
            ELSE
                NextState := E_MachineState#IDLE;
            END_IF;
            bTransition := TRUE;

        
        ELSIF fbCalcOffset.Error THEN
        
            fbCalcOffset.Enable := FALSE;
            bApplyOffsetReq := FALSE;
            bCalcReq        := FALSE;
        
            // Force transition to Error state, or allow retry within Teach state
            // NextState := E_MachineState#ERROR;
            // bTransition := TRUE;
            //fbErrorHandler.AddUpdateError(TRUE, fbCalcOffset.ErrorID, 'FB_MachineControl - TeachFrameState', 'Offset Calculation Failed (Check Points)', E_ErrorSeverity#MajorError);
        END_IF;
    END_IF;

ELSE
    fbFrameTransform(Execute := FALSE, FrameCoordinates := stRawVector);
    fbCalcOffset.Enable := FALSE;
    bApplyOffsetReq := FALSE;
END_IF;