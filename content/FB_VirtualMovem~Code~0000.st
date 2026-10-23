(* --- FB_OscillatingAxis Implementation --- *)

// Rising edge detection for control signals
r_EnableOscillation(CLK := EnableOscillation);
r_Reset(CLK := Reset);

// Update output state for external monitoring
CurrentState := eInternalState;

// Default outputs
IsOscillating := FALSE;

(* --- Reset Logic --- *)
IF r_Reset.Q OR (eInternalState = E_OscillationState#ERROR) THEN // Reset on rising edge of Reset or if in ERROR state
    eInternalState := E_OscillationState#INIT;
    Error := FALSE;
    ErrorID := 0;
    IsOscillating := FALSE;

    // Reset internal FB executes
    MoveForward.Execute := FALSE;
    MoveBackward.Execute := FALSE;
END_IF;

(* --- State Machine Logic --- *)
CASE eInternalState OF
    E_OscillationState#INIT:
        // Initial state: ensures all FBs are de-triggered and sets default values.
        MoveForward.Execute := FALSE;
        MoveBackward.Execute := FALSE;
        Error := FALSE;
        ErrorID := 0;
        IF NOT(Axis.Status.Alarm) THEN // Only proceed if the axis itself is not in an alarm state
            eInternalState := E_OscillationState#IDLE;
        ELSE
            eInternalState := E_OscillationState#ERROR; // Axis is in error, go to FB error state
            Error := TRUE;
            ErrorID := 0; // Custom error ID for axis error // TODO
        END_IF;

    E_OscillationState#IDLE:
        // Waiting for the 'EnableOscillation' command.
        IF r_EnableOscillation.Q THEN
            // When enabled, prepare to trigger the forward movement.
            // Parameters for forward move (StartPosition to EndPosition)
            MoveForward.Position := EndPosition;
            MoveForward.Velocity := Velocity;
            MoveForward.Acceleration := Acceleration;
            MoveForward.Deceleration := Deceleration;
            MoveForward.Direction := MC_Direction#Positive_Direction;
            MoveForward.BufferMode := MC_BufferMode#BlendingPrevious; // MC_BufferMode#BlendingPrevious;
            MoveForward.Execute := TRUE; // Trigger the move
            eInternalState := E_OscillationState#MOVING_FORWARD;
            IF MoveForward.Error THEN
                // An error occurred during forward movement.
                Error := TRUE;
                ErrorID := MoveForward.ErrorID;
                eInternalState := E_OscillationState#ERROR;
            END_IF;
        END_IF;

    E_OscillationState#MOVING_FORWARD:
        // This state triggers and monitors the MoveForward.
        IsOscillating := TRUE;

        IF MoveForward.Active OR MoveForward.Done THEN
            MoveForward.Execute := FALSE; // De-trigger MoveForward
            
            // Forward movement completed successfully. Now move backward.
            MoveBackward.Position := StartPosition;
            MoveBackward.Velocity := Velocity;
            MoveBackward.Acceleration := Acceleration;
            MoveBackward.Deceleration := Deceleration;
            MoveBackward.Direction := MC_Direction#Negative_Direction;
            MoveBackward.BufferMode := MC_BufferMode#BlendingPrevious; // MC_BufferMode#BlendingPrevious;
            MoveBackward.Execute := TRUE; // Trigger the move
            eInternalState := E_OscillationState#MOVING_BACKWARD;
        ELSIF MoveForward.Error THEN
            // An error occurred during forward movement.
            Error := TRUE;
            ErrorID := MoveBackward.ErrorID;
            eInternalState := E_OscillationState#ERROR;
        ELSIF NOT(MoveForward.Active) AND NOT(EnableOscillation) THEN
             // If oscillation is disabled while waiting for forward move, stop and return to IDLE.
             // This assumes external control should halt the current operation.
             MoveForward.Execute := FALSE; (* Ensure no pending moves *)
             eInternalState := E_OscillationState#IDLE;
        END_IF;

    E_OscillationState#MOVING_BACKWARD:
        // This state triggers and monitors the MoveBackward
        IsOscillating := TRUE;

        IF MoveBackward.Active OR MoveBackward.Done THEN
            MoveBackward.Execute := FALSE; // De-trigger MoveBackward
            
            // Backward movement completed successfully. Restart the forward movement.
            MoveForward.Position := EndPosition;
            MoveForward.Velocity := Velocity;
            MoveForward.Acceleration := Acceleration;
            MoveForward.Deceleration := Deceleration;
            MoveForward.Direction := MC_Direction#Negative_Direction;
            MoveForward.BufferMode := MC_BufferMode#BlendingPrevious; // MC_BufferMode#BlendingPrevious;
            MoveForward.Execute := TRUE; // Trigger the next move
            eInternalState := E_OscillationState#MOVING_FORWARD;
        ELSIF MoveBackward.Error THEN
            // An error occurred during backward movement.
            Error := TRUE;
            ErrorID := MoveBackward.ErrorID;
            eInternalState := E_OscillationState#ERROR;
        ELSIF NOT(MoveBackward.Active) AND NOT(EnableOscillation) THEN
             // If oscillation is disabled while waiting for forward move, stop and return to IDLE.
             // This assumes external control should halt the current operation.
             MoveBackward.Execute := FALSE; (* Ensure no pending moves *)
             eInternalState := E_OscillationState#IDLE;
        END_IF;

    E_OscillationState#ERROR:
        // Error state: The FB remains here until a reset command is given.
        // All motion commands are stopped.
        Error := TRUE;
        IsOscillating := FALSE;
        MoveForward.Execute := FALSE; 
        MoveBackward.Execute := FALSE; 
        ; // Wait for ResetFB to be TRUE

END_CASE