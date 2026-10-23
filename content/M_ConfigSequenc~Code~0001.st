// METHOD: M_ConfigSequence_Parking
// DESCRIPTION: Builds the Parking list.

iTotalSteps := 0; // Clear list

THIS.AddStep(E_PickPlace_State#InitializeFinalParking);
THIS.AddStep(E_PickPlace_State#MoveToParking_SafePosition);
THIS.AddStep(E_PickPlace_State#FinalParkingCompletition);

bPlacePhaseActive := FALSE;
