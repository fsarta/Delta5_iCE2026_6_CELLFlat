//=================================================================================
// Yaskawa Italia Srl
//(c)Copyright Yaskawa Italia Srl All Rights Reserved
//---------------------------------------------------------------------------------
// 
// Tested with: iC9226M-FSoE
// Engineering: iCube Engineer 2025.6 (Build 7.2.38936.0)
// Requirements: iC9226M-EC / iC9226M-FSoE
// Functionality: 
//     Implements a state machine to manage the lifecycle of a Delta robot system
//     and axes including power management, homing, commissioning, driver activation,
//     and error handling. Integrates with an error handler for diagnostics.
//
//     State machine implementation following these principles:
//         1. State Initialization: Single initialization sequence
//         2. Output Reset: All outputs cleared at start of cycle
//         3. State Execution: Current state method called
//         4. Transition Handling: Automatic state update if transition requested
//         5. Error Logging: Integrated through fbErrorHandler
//     
//     Execution Flow:
//         1. INIT → IDLE (one-time initialization)
//         2. State-specific logic executed
//         3. Transition checked and applied
//         4. Outputs updated for next cycle
//     
//---------------------------------------------------------------------------------
// Change log table:
// Version   Date         Expert in charge                     Changes applied
// 0.00.01   07-11-2025   Fsarta(Francesco.sarta@yaskawa.eu)   New Version Released
//=================================================================================

fbAxisController_CIAxis(
    AXI := FeedIn_Axis, 
    DATA_AXI := DATA_FeedInAxis
    );
fbAxisController_COAxis(
    AXI := FeedOut_Axis, 
    DATA_AXI := DATA_FeedOutAxis
    );
fbAxisController_VirtAxis(
    AXI := VIRTUAL_AXIS, 
    DATA_AXI := DATA_VirtAxis
    );    

fbGroupController_Delta(
    AxesGroupRef := DELTA, 
    DATA_GROUP := DATA_Delta,
    numAxesGroup := 5
    );
    
DATA_Delta.Command.GroupControl.AlarmClear := G_bResetAllErrors;
DATA_FeedInAxis.Command.ResetFault := G_bResetAllErrors;
DATA_FeedOutAxis.Command.ResetFault := G_bResetAllErrors;

(*
fbErrorHandler(
    bResetErrors := G_bResetAllErrors, 
    bAcknowledgeErrors := G_bAcknowledgeAllErrors
    );
*)



(*

(G_bResetAllErrors)
+---------------------------------------------------------------------------------------+
|                                                                                       |
|                                                                                       v
|    +----------+              +---------------+             +---------------+         +-------+
|    |   INIT   | -----------> |     IDLE      | --(Avvio)-->|  POWERING_UP  | ------> | ERROR |
|    +----------+              +---------------+             +---------------+ <-----+ +-------+
|          ^                         |   ^                        |      | (Fail)        ^
|          | (Shutdown OK)           |   | (Stop)                 | (OK) |               |
|          |                         |   |                        |      |               |
|    +----------+              +----------+                       |      +---------------+
|    | SHUTDOWN | <----------- |UNPOWERING|                       |                      |
|    +----------+ (Turn OFF    +----------+                       v                      |
|                     OK)            ^                   +----------+                    |
|                                    | (Stop OK)         |  HOMING  |                    |
|                                    |                   +----------+                    |
+--------------------------------[ STOPPING ] <----------|-------------------------------+
                                     ^                | (E-Stop / PwrDown)     (Every Servo / Fault)
                                     |                |                        
                                     |                +----------------------+
                                     |                | (Auto)               | (Man)
                                     |                v                      v
           (E-Stop / Safety Off)     |  +---------------------+            +---------------------+
           +-------------------------+  | OPERATIONAL_AUTO    | <(Switch)> | OPERATIONAL_MANUAL  |
           |                            +---------------------+            +---------------------+
           |                                     ^                                ^
           | (if Commissioning=TRUE)             | (Done + Auto)                  | (Done + Manual)
           | (go HOMING)                         |                                |
           |                                +------------------------+            |
           +------------------------------->| WAIT_FOR_COMMISSIONING |------------+
                                            +------------------------+


                                +-----------+
                                |   INIT    |
                                +-----------+
                                      |
                                      | inizialization
                                      v
                                +-----------+
                                |   IDLE    |
                                +-----------+
                 (PowerUp valid) /     \  (PowerDown OR safety lost & assi ON)
                                /       \
                               v         v
                       +---------------+  +---------+
                       | POWERING_UP   |  | STOPPING|  <----------------+
                       +---------------+  +---------+                   |
                          |    |               |                        |
     (enabled OK) -------/     |               | En_EmergencyGroupStop  |
                                |               v                       |
                                |           +-----------+               |
                                |           | UNPOWERING|               |
                                |           +-----------+               |
                                |               |                       |
                                |               v                       |
                                |           +-----------+               |
                                |           | SHUTDOWN  |---------------+
                                |           +-----------+
                                |               |
                                |               v
                                |           +-----------+
                                |           |   INIT    |
                                |           +-----------+
                                |
                                v
                             +-------+
                             | HOMING |
                             +-------+
                                 |
     (Homing OK) ---------------/|\-------------------------
        |                           |                     |
        |(Commissioning)            |(bAutoModeSelected)  |(else)
        |                           |                     |
        v                           v                     v
+---------------------+   +---------------------------+  +----------------------+
| WAIT_FOR_COMMISSION |   | OPERATIONAL_AUTOMATIC     |  | OPERATIONAL_MANUAL   |
| (GroupSetPos.Done)  |   +---------------------------+  +----------------------+
+---------------------+           |    ^    ^                    |
     |      ^                     |    |    |                    |
     |(Error)|                    |    |    |(bAutoModeSelected) |
     v      |                     |    |    |                    v
  +-------+ |                     |    |    |            (safety button)
  | ERROR |<+---------------------+    |    +--------------------> (to AUTOMATIC)
  +-------+   (varie condizioni)       |                         |
     | ^                               |                         |
     | |(G_bResetAllErrors)            |(E_Stop OR PowerDown)    |
     | +-------------------------------+-------------------------+
     |                    (many states -> ERROR on missing servos)
     v
  +------------------------------------+
  |  (da più stati) -> ERROR           |
  +------------------------------------+


*)