(*
-------------------------------------------------------------------------
    FUNCTION_BLOCK FB_DistanceTrigger
    
    Fires a single-cycle trigger every 'x' millimeters of movement.
    Prevents long-term drift by subtracting the interval instead of resetting.
-------------------------------------------------------------------------
*)

// --- 1. Reset Handling ---
IF bReset THEN
    rAccumulatedDistance := 0.0;
    bInitialized := FALSE;
    bTrigger := FALSE;
    RETURN;
END_IF

// --- 2. First Cycle Initialization ---
IF NOT bInitialized THEN
    rLastPosition := rCurrentPosition;
    bInitialized := TRUE;
END_IF

// --- 3. Disable Handling ---
IF NOT bEnable THEN
    bTrigger := FALSE;
    rLastPosition := rCurrentPosition; // Keep tracking to avoid jumps upon re-enabling
    RETURN;
END_IF

// --- 4. Delta Calculation (Absolute movement) ---
rDelta := rCurrentPosition - rLastPosition;
rLastPosition := rCurrentPosition;

// Abs() allows it to work forward and backward. Remove ABS() if only forward motion matters.
rAccumulatedDistance := rAccumulatedDistance + ABS(rDelta);

// --- 5. Trigger Generation ---
IF (rAccumulatedDistance >= rTriggerInterval) AND (rTriggerInterval > 0.0) THEN
    bTrigger := TRUE;
    // ANTI-DRIFT TRICK: Subtract the interval instead of setting to 0.0
    rAccumulatedDistance := rAccumulatedDistance - rTriggerInterval;
ELSE
    bTrigger := FALSE;
END_IF