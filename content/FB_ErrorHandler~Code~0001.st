//=================================================================================
// Yaskawa Italia Srl
//(c)Copyright Yaskawa Italia Srl All Rights Reserved
//---------------------------------------------------------------------------------
// 
// Tested with: iC9226M-FSoE
// Engineering: iCube Engineer 2025.6 (Build 7.2.38936.0)
// Requirements: iC9226M-EC / iC9226M-FSoE
// Functionality: This Function Block provides a centralized, high-performance system for 
//                managing and logging errors and events from various parts of the application.
//---------------------------------------------------------------------------------
// Change log table:
// Version   Date         Expert in charge                     Changes applied
// 0.00.01   10-07-2025   Fsarta(Francesco.sarta@yaskawa.eu)   New Version Released
// 0.01.01   10-11-2025   Fsarta(Francesco.sarta@yaskawa.eu)   
//      - Major performance optimization: Removed full buffer rescan from the main Update loop.
//      - G_stOverallErrorStatus is now updated incrementally inside AddUpdateError on state change.
//      - Added new lightweight METHOD LogEvent for stateless "Info" messages (must be called with R_TRIG).
//      - Refactored internal logic using private helper methods (ResetBufferAndCounters, RecalculateHighestSeverity) 
//        to improve maintainability.
//=================================================================================

