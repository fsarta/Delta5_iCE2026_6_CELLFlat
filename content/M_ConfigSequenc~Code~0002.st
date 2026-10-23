(* ===== METHOD M_ConfigSequence_AbortToParking ===== *)
// METHOD: M_ConfigSequence_AbortToParking
// DESCRIPTION: Soft abort sequence for ‘Stop Cycle’ midway through the cycle (with no workpiece in the gripper):
// Move back to the transit height above the last pick position, then move to a safe parking position.

iTotalSteps := 0; // Clear list

THIS.AddStep(E_PickPlace_State#AscendAfterPick);
THIS.AddStep(E_PickPlace_State#MoveToParking_SafePosition);
THIS.AddStep(E_PickPlace_State#FinalParkingCompletition);

bPlacePhaseActive := FALSE;