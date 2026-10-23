// METHOD: M_ConfigSequence_Run
// DESCRIPTION: Builds the standard Pick & Place list.

iTotalSteps := 0; // Clear list
bPlacePhaseActive := FALSE;   // AUTOCYCLE: the cycle begins again in the pick phase
bStopAbortActive := FALSE;    // AUTOCYCLE: new cycle -> abortion available again

// --- PICK PHASE ---
(*  0 *) THIS.AddStep(E_PickPlace_State#Initialize);
(*  1 *) THIS.AddStep(E_PickPlace_State#CheckPickLimits);
(*  2 *) THIS.AddStep(E_PickPlace_State#CalculatePickGripperOffset);
(*  3 *) THIS.AddStep(E_PickPlace_State#SetPickFrame_Tracking);
(*  4 *) THIS.AddStep(E_PickPlace_State#ConvertPickToCartesian_Tracking);
(*  5 *) THIS.AddStep(E_PickPlace_State#SetPickOffsetAndPCS_Tracking);
(*  6 *) THIS.AddStep(E_PickPlace_State#EnablePickTracking);
//(*  *) THIS.AddStep(E_PickPlace_State#StartMovePath);
(*  7 *) THIS.AddStep(E_PickPlace_State#ApproachPick_Tracking);
(*  8 *) THIS.AddStep(E_PickPlace_State#WaitForPickSync);
(*  9 *) THIS.AddStep(E_PickPlace_State#DescendAndPick);
//(*  *) THIS.AddStep(E_PickPlace_State#WaitAfterPick_Tracking);
(* 10 *) THIS.AddStep(E_PickPlace_State#AscendAfterPick);
(* 11 *) THIS.AddStep(E_PickPlace_State#MoveToParking_AfterPick);
(* 12*) THIS.AddStep(E_PickPlace_State#SelectNextProduct_Pick);


// --- PLACE PHASE ---
(* 13 *) THIS.AddStep(E_PickPlace_State#InitializePlace);
//(*  *) THIS.AddStep(E_PickPlace_State#CheckPlaceLimits);
(* 14 *) THIS.AddStep(E_PickPlace_State#SetPlaceFrame_Tracking);
(* 15 *) THIS.AddStep(E_PickPlace_State#ConvertPlaceToCartesian_Tracking);
//(*  *) THIS.AddStep(E_PickPlace_State#SetPlaceOffsetAndPCS_Tracking);
(* 16 *) THIS.AddStep(E_PickPlace_State#EnablePlaceTracking);
(* 17 *) THIS.AddStep(E_PickPlace_State#ApproachPlace_Tracking);
(* 18 *) THIS.AddStep(E_PickPlace_State#WaitForPlaceSync);
(* 19 *) THIS.AddStep(E_PickPlace_State#DescendAndPlace);
(* 20 *) THIS.AddStep(E_PickPlace_State#WaitAfterPlace_Tracking);
(* 21 *) THIS.AddStep(E_PickPlace_State#AscendAfterPlace);
(* 22 *) THIS.AddStep(E_PickPlace_State#MoveToParking_AfterPlace);
(* 23 *) THIS.AddStep(E_PickPlace_State#CycleCompletitionAndChangeMode);

bM_ConfigSequence_RunOldState := fbErrorHandler.CheckAndEnqueueEvent(
    1,                                              
    TRUE,                                           
    bM_ConfigSequence_RunOldState,                     
    0,                                              
    'FB_PickPlace_Sequencer - M_ConfigSequence_Run',             
    'Builds the standard Pick & Place list',  
    E_ErrorSeverity#Info                            
);



