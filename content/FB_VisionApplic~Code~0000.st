(*
-------------------------------------------------------------------------
    FUNCTION_BLOCK FB_VisionApplication 
    
    Use ImageId as the synchronisation key instead of FIFO
-------------------------------------------------------------------------
*)

// --- 0. Call the Distance Trigger ---
fbDistanceTrigger(
    rCurrentPosition := rConveyorCurrentPos,
    rTriggerInterval := rDistanceSetpoint,
    bEnable          := xEnableDistanceTrigger AND xEnable,
    bReset           := xResetError
);

// --- 1. Call the Driver FB ---
fbVisor(
    xTrigger             := xInternalTrigger,
    xResetError          := xInternalReset,
    xChangeJob           := FALSE, 
    iJobToChange         := 0,
    xSwitchToRun         := FALSE,
    Visor_Receive        := VisorEIP_Receive,
    i_stConnectionStatus := i_stConnectionStatus,
    Visor_Transmit       => VisorEIP_Transmit, 
    xConnected           => xVisorConnected, 
    xReady               => xVisorReady      
);

// --- 2. Edge Triggers ---
rtStartSequence(CLK := xOneShot);
rtResetError(CLK := xResetError);
rtTouchProbeDone(CLK := xTouchProbeDone);

tonCyclicTimer.IN := xEnableCyclicTrigger
                     AND xEnable
                     AND (eInternalState = E_VisionMgr_State#IDLE)
                     AND fbVisor.xReady;
tonCyclicTimer.PT := tCyclicTriggerTime;

// --- 2b. Timer sync hardware ---
IF tPhysTriggerPulse <= T#0MS THEN
    tPhysTriggerPulseEff := T#10MS;  // default: safe pulse width
ELSE
    tPhysTriggerPulseEff := tPhysTriggerPulse;
END_IF;
// Physical pulse: lasts for tPhysTriggerPulse from the rising edge of bPulseActive
tonPhysTrigger(IN := bPulseActive, PT := tPhysTriggerPulseEff);
// Latch wait timeout: 500 ms in TRIGGER_ACKNOWLEDGE (physical mode)
tonLatchTimeout(IN := xUsePhysTrigger AND (eInternalState = E_VisionMgr_State#TRIGGER_ACKNOWLEDGE),
                PT := T#500MS);
// Delay before reset following an unexpected latch (see IDLE state)
tonRearmDelay(IN := bRearmPending, PT := T#50MS);

// --- 3. Default Outputs ---
xActive          := FALSE;
xDone            := FALSE;
xInternalTrigger := FALSE;
xInternalReset   := FALSE;
tonTimeout.IN    := FALSE;
// Physical pulse: high only whilst bPulseActive (width = tPhysTriggerPulse)
IF tonPhysTrigger.Q THEN
    bPulseActive := FALSE;  // pulse completed
END_IF;
xPhysTrigger := bPulseActive;
// NOTE: xArmTouchProbe is NOT reset here: it is a LEVEL managed by the
//       states (TRUE = probe armed and awaiting the trigger, FALSE = disarmed).


ftEnable(CLK := xEnable);
IF ftEnable.Q THEN  // Falling edge di xEnable
    xInternalReset   := TRUE;
    eInternalState   := E_VisionMgr_State#IDLE;
    tonTimeout.IN    := FALSE;
    xError           := FALSE;
    xArmTouchProbe   := FALSE;  // disarms the probe when the system is switched off
    bProbeArmed      := FALSE;
    bPulseActive     := FALSE;
    bRearmPending    := FALSE;
    fbVisor.MapOutputs(); // assicura che i byte vengano azzerati subito
    RETURN;
END_IF;

// --- 4. SIMPLIFIED STATE MACHINE ---
IF NOT xEnable THEN
    RETURN;
END_IF;

CASE eInternalState OF
    
    E_VisionMgr_State#IDLE:
        xError := FALSE;
        tonTimeout.IN := FALSE; 
        
        // (Re)arm the touch probe for the next trigger (physical mode only).
        // It is a level: it remains TRUE until the latch is acquired.
        IF xUsePhysTrigger AND NOT bProbeArmed AND NOT bRearmPending THEN
            xArmTouchProbe := TRUE;
            bProbeArmed    := TRUE;
        ELSIF NOT xUsePhysTrigger THEN
            xArmTouchProbe := FALSE;
            bProbeArmed    := FALSE;
        END_IF;

        // Unexpected latch (e.g. manual pulse on the SLIO output): disarms, performs diagnostics
        // and prevents rearm for 50 ms (time to detect the falling edge)
        IF rtTouchProbeDone.Q THEN
            xArmTouchProbe  := FALSE;
            bProbeArmed     := FALSE;
            bRearmPending   := TRUE;
            udiStrayLatches := udiStrayLatches + 1;
            G_udiStrayLatches := G_udiStrayLatches + 1; // KPI
        END_IF;
        // Unlock the reset after the delay
        IF bRearmPending AND tonRearmDelay.Q THEN
            bRearmPending := FALSE;
        END_IF;

        
        IF rtResetError.Q THEN
            xInternalReset := TRUE;
            // Reset lookup table
            FOR i := 0 TO 255 DO
                aImageIdToPosition[i] := 0.0;
                aImageIdValid[i] := FALSE;
            END_FOR;
        END_IF;
        
        // Check for start signal
        xStartSignal := rtStartSequence.Q OR tonCyclicTimer.Q OR fbDistanceTrigger.bTrigger;

        
        // ⚠️ SAFETY CHECK: Only proceed if camera is ready
        IF xStartSignal THEN
            IF fbVisor.xReady THEN
                eInternalState := E_VisionMgr_State#TRIGGER_CAMERA;
            ELSE
                // Camera not ready - wait a bit
                tonTimeout.IN := TRUE;
                tonTimeout.PT := T#200MS;
                eInternalState := E_VisionMgr_State#WAIT_FOR_READY;
            END_IF;
        END_IF;

    E_VisionMgr_State#WAIT_FOR_READY:
        xActive := TRUE;
        tonTimeout.IN := TRUE;
        
        IF fbVisor.xReady THEN
            tonTimeout.IN := FALSE;
            eInternalState := E_VisionMgr_State#TRIGGER_CAMERA;
        ELSIF tonTimeout.Q THEN
            tonTimeout.IN := FALSE;
            eInternalState := E_VisionMgr_State#ERROR; 
        END_IF;

    E_VisionMgr_State#TRIGGER_CAMERA:
        xActive := TRUE;
        
        // Read the ImageId BEFORE the trigger
        // That way we know which ImageId will be incremented
        iImageIdBeforeTrigger := stInput.ImageId;
        iExpectedNewImageId := (iImageIdBeforeTrigger + 1) MOD 256; // Wraps at 255
        
        IF xUsePhysTrigger THEN
            // *** PHYSICAL TRIGGER (SLIO output + servo latch) ***
            // The pulse on xPhysTrigger goes to chamber E (the same output wired
            // to the latch input of the tape servo) causing the MC_TouchProbe to latch the tape position EXACTLY at the leading edge.
            // The probe is already armed (xArmTouchProbe = TRUE, armed in IDLE mode).
            bPulseActive     := TRUE;    // triggers the physical impulse (duration = tPhysTriggerPulse)
            xInternalTrigger := FALSE;   // NO software triggers via EIP in physical mode
            eInternalState   := E_VisionMgr_State#TRIGGER_ACKNOWLEDGE;
        ELSE
            // *** SOFTWARE TRIGGER via EIP ***
        
            // Send trigger
            xInternalTrigger := TRUE; 
            
            // Setup timeout
            tonTimeout.IN := TRUE; 
            tonTimeout.PT := T#500MS; 
            
            eInternalState := E_VisionMgr_State#TRIGGER_ACKNOWLEDGE;
        END_IF;
        
    E_VisionMgr_State#TRIGGER_ACKNOWLEDGE:
        xActive := TRUE;
        
        IF xUsePhysTrigger THEN
            // *** PHYSICAL MODE: waiting for the hardware LATCH ***
            // (the physical pulse continues until tonPhysTrigger expires)
            IF rtTouchProbeDone.Q THEN
                // Latch captured: saves the LATCHED POSITION (hardware).
                // rLatchedPosition = DATA_FeedInAxis.Feedback.TouchProbeRecPos,
                // read by VisionManager on the rising edge of TouchProbeDone.
                rLatchedPos := rLatchedPosition;
                aImageIdToPosition[iExpectedNewImageId] := rLatchedPos;
                aImageIdValid[iExpectedNewImageId]    := TRUE;

                // Disarm the probe (it will be rearmed at the next IDLE cycle)
                xArmTouchProbe := FALSE;
                bProbeArmed    := FALSE;
                // Timeout whilst waiting for results (as in software mode)
                tonTimeout.IN := FALSE;
                tonTimeout.PT := T#2S;
                eInternalState := E_VisionMgr_State#WAIT_FOR_RESULTS;

            ELSIF xTouchProbeError OR tonLatchTimeout.Q THEN
                // Touch probe error or latch not detected within 500 ms:
                // the physical trigger was not detected by the servo (or probe error)
                G_udiLatchTimeouts := G_udiLatchTimeouts + 1; //KPI
                aImageIdValid[iExpectedNewImageId] := FALSE;
                xArmTouchProbe := FALSE;
                bProbeArmed    := FALSE;
                bPulseActive   := FALSE;
                eInternalState := E_VisionMgr_State#ERROR;
            END_IF;

        ELSE
            // *** SOFTWARE MODE via EIP ***
            // Keep the trigger high until I receive the ACK!
            xInternalTrigger := TRUE;
            tonTimeout.IN    := TRUE;

            // Exit condition: the chamber has confirmed receipt of the trigger
            IF fbVisor.xTriggerAck THEN
                // ⚠️ SAVE: ImageId -> Tape position (sampled via SOFTWARE)
                aImageIdToPosition[iExpectedNewImageId] := rConveyorCurrentPos;
                aImageIdValid[iExpectedNewImageId] := TRUE;

                // Reset the time-out timer for the next stage
                tonTimeout.IN := FALSE;
                tonTimeout.PT := T#2S;
                eInternalState := E_VisionMgr_State#WAIT_FOR_RESULTS;

            ELSIF tonTimeout.Q THEN
                // Timeout: the camera did not confirm the trigger within the specified time
                tonTimeout.IN := FALSE;
                aImageIdValid[iExpectedNewImageId] := FALSE;
                eInternalState := E_VisionMgr_State#ERROR;
            END_IF;
        END_IF;
        
    E_VisionMgr_State#WAIT_FOR_RESULTS:
        xActive := TRUE;
        tonTimeout.IN := TRUE; 
        
        // ⚠️ WAIT FOR: New Data_ImageId (byte 6) - identifies the data in bytes 8-56
        IF (NOT fbVisor.xTriggerBusy) AND (stInput.Data_ImageId <> iImageIdBeforeTrigger) THEN
            tonTimeout.IN := FALSE;
            eInternalState := E_VisionMgr_State#PROCESS_RESULTS;
            
        ELSIF tonTimeout.Q THEN
            tonTimeout.IN := FALSE;
            // Timeout - mark this ImageId as invalid
            aImageIdValid[iExpectedNewImageId] := FALSE;
            eInternalState := E_VisionMgr_State#ERROR; 
        END_IF;

    E_VisionMgr_State#PROCESS_RESULTS:
        xActive := TRUE;
        
        IF fbVisor.xError THEN
            // Driver error - mark ImageId as invalid
            aImageIdValid[stInput.Data_ImageId] := FALSE;
            eInternalState := E_VisionMgr_State#ERROR; 
        ELSE
                        
            // ⚠️ RETRIEVE: Position from ImageId
            iReceivedDataImageId := stInput.Data_ImageId;
            
            IF aImageIdValid[iReceivedDataImageId] THEN
                rTriggeredPosition := aImageIdToPosition[iReceivedDataImageId];
            ELSE
                // Invalid ImageId – location unknown!
                // Fallback: use current location (not ideal)
                rTriggeredPosition := rConveyorCurrentPos;
            END_IF;
            
            // Copy results
            stCurrentResult := fbVisor.o_stResultData;
            
            // Save last good result (for HMI)
            IF stCurrentResult.Part_Count > 0 THEN
                stLastGoodResult := stCurrentResult;
            END_IF;

            // Done
            xDone := TRUE; 
            eInternalState := E_VisionMgr_State#IDLE; 
        END_IF;
        
    E_VisionMgr_State#ERROR:
        xError := TRUE;
        xActive := FALSE;
        bPulseActive := FALSE;
        IF rtResetError.Q THEN
            xInternalReset := TRUE;
            eInternalState := E_VisionMgr_State#IDLE;
        END_IF;
        
END_CASE;

eState := eInternalState;