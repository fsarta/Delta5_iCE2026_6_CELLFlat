(*
-------------------------------------------------------------------------
    FUNCTION_BLOCK FB_VisorDriver (The Driver - Level 2)
    
    Manages byte-level (de)serialization and command handshakes.
    Includes connection status checks.
-------------------------------------------------------------------------
*)

// --- INIT: First scan ---
IF NOT xInitialized THEN
    eTriggerState       := E_VisorControlState#IDLE;
    eChangeJobState     := E_VisorControlState#IDLE;
    eSwitchToRunState   := E_VisorControlState#IDLE;
    stOutput.Control_Bits.Trigger      := FALSE;
    stOutput.Control_Bits.ChangeJob    := FALSE;
    stOutput.Control_Bits.SwitchToRun  := FALSE;
    stOutput.Control_Bits.ResetError   := FALSE;
    stOutput.JobNumberOut              := 0;
    xInitialized := TRUE;
    THIS.MapOutputs();
    RETURN; // Salta tutta la logica al primo scan
END_IF;

// --- 0. Check Connection Status ---
// EIP_STATUS_REF.ConnectionState = 4 means 'Running'
xConnected := (i_stConnectionStatus.ConnectionState = 4);

// --- 1. Map Inputs: Converts raw received bytes into stInput ---
THIS.MapInputs(); 

// --- 2. MAIN LOGIC ---

// --- 2.1. Map simple outputs (Status) ---
xReady          := stInput.Status_Bits.Ready;
iErrorCode      := 0;// TODO (stInput.Status_Byte5 AND BYTE#16#0F); // Mask the first 4 bits
xInRunMode      := (stInput.Status_Byte5 AND BYTE#16#40) <> 0; // Check Bit 6
xTriggerAck     := stInput.Status_Bits.TriggerAck;
xError          := iErrorCode <> 0;
iActiveJob      := stInput.JobNumber;
o_stResultData  := stInput.ResultData; 

// --- 2.2. Handle Edge-Triggered Commands ---
rtResetError(CLK := xResetError);
rtTrigger(CLK := xTrigger AND stInput.Status_Bits.Ready);
rtChangeJob(CLK := xChangeJob);
rtSwitchToRun(CLK := xSwitchToRun AND NOT xInRunMode); 

// *** State machine Reset ***
IF rtResetError.Q THEN
    eTriggerState      := E_VisorControlState#IDLE;
    eChangeJobState    := E_VisorControlState#IDLE;
    eSwitchToRunState  := E_VisorControlState#IDLE;
    stOutput.Control_Bits.Trigger      := FALSE;
    stOutput.Control_Bits.ChangeJob    := FALSE;
    stOutput.Control_Bits.SwitchToRun  := FALSE;
END_IF;

// --- 2.3. Reset Error Logic ---
stOutput.Control_Bits.ResetError := rtResetError.Q;

// --- 2.4. Trigger State Machine ---
xTriggerBusy := (eTriggerState <> E_VisorControlState#IDLE);

CASE eTriggerState OF
    E_VisorControlState#IDLE:
        IF rtTrigger.Q THEN
            stOutput.Control_Bits.Trigger := TRUE; // Write to internal buffer
            eTriggerState := E_VisorControlState#WAIT_FOR_ACK;
        END_IF;

    E_VisorControlState#WAIT_FOR_ACK:
        IF stInput.Status_Bits.TriggerAck THEN 
            stOutput.Control_Bits.Trigger := FALSE; // Clear request once acknowledged
            eTriggerState := E_VisorControlState#WAIT_FOR_NO_ACK;
        ELSIF xError AND (iErrorCode = 1) THEN 
            stOutput.Control_Bits.Trigger := FALSE;
            eTriggerState := E_VisorControlState#IDLE;
        END_IF;

    E_VisorControlState#WAIT_FOR_NO_ACK:
        IF NOT stInput.Status_Bits.TriggerAck THEN
            eTriggerState := E_VisorControlState#IDLE;
        END_IF;
END_CASE;

// --- 2.5. Change Job State Machine ---
xChangeJobBusy := (eChangeJobState <> E_VisorControlState#IDLE);

CASE eChangeJobState OF
    E_VisorControlState#IDLE:
        stOutput.JobNumberOut := 0;
        IF rtChangeJob.Q AND iJobToChange > 0 THEN
            stOutput.JobNumberOut := iJobToChange; 
            stOutput.Control_Bits.ChangeJob := TRUE;
            eChangeJobState := E_VisorControlState#WAIT_FOR_ACK;
        END_IF;

    E_VisorControlState#WAIT_FOR_ACK:
        IF stInput.Status_Bits.ChangeJobAck THEN 
            stOutput.Control_Bits.ChangeJob := FALSE;
            eChangeJobState := E_VisorControlState#WAIT_FOR_NO_ACK;
        ELSIF xError AND (iErrorCode = 2) THEN 
             stOutput.Control_Bits.ChangeJob := FALSE;
             eChangeJobState := E_VisorControlState#IDLE;
        END_IF;

    E_VisorControlState#WAIT_FOR_NO_ACK:
        IF NOT stInput.Status_Bits.ChangeJobAck THEN
            eChangeJobState := E_VisorControlState#IDLE;
        END_IF;
END_CASE;

// --- 2.6. Switch to Run State Machine ---
xSwitchToRunBusy := (eSwitchToRunState <> E_VisorControlState#IDLE);

CASE eSwitchToRunState OF
    E_VisorControlState#IDLE:
        IF rtSwitchToRun.Q THEN
            stOutput.Control_Bits.SwitchToRun := TRUE; 
            eSwitchToRunState := E_VisorControlState#WAIT_FOR_ACK;
        END_IF;

    E_VisorControlState#WAIT_FOR_ACK:
        IF stInput.Status_Bits.SwitchToRunAck THEN 
            stOutput.Control_Bits.SwitchToRun := FALSE;
            eSwitchToRunState := E_VisorControlState#WAIT_FOR_NO_ACK;
        ELSIF xError AND (iErrorCode = 3) THEN 
            stOutput.Control_Bits.SwitchToRun := FALSE;
            eSwitchToRunState := E_VisorControlState#IDLE;
        END_IF;

    E_VisorControlState#WAIT_FOR_NO_ACK:
        IF NOT stInput.Status_Bits.SwitchToRunAck THEN
            eSwitchToRunState := E_VisorControlState#IDLE;
        END_IF;
END_CASE;

// --- 3. Map Outputs: Converts stOutput into raw transmit bytes ---
THIS.MapOutputs();