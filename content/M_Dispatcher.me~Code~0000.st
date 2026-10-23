// METHOD: M_Dispatcher (Links ID to Method)

CASE StateID OF
    E_PickPlace_State#Unknown:                          M_Dispatcher := E_StepStatus#ERROR;
    
    E_PickPlace_State#Idle:                             ;
    E_PickPlace_State#Initialize:                       M_Dispatcher := THIS.M_Step_Initialize();
    E_PickPlace_State#CheckPickLimits:                  M_Dispatcher := THIS.M_Step_CheckPickLimits();
    E_PickPlace_State#CalculatePickGripperOffset:       M_Dispatcher := THIS.M_Step_CalcPickOffset();
    E_PickPlace_State#SetPickFrame_Tracking:            M_Dispatcher := THIS.M_Step_SetPickFrame_Tracking();
    E_PickPlace_State#ConvertPickToCartesian_Tracking:  M_Dispatcher := THIS.M_Step_ConvertPickToCartesian_Tracking();
    E_PickPlace_State#SetPickOffsetAndPCS_Tracking:     M_Dispatcher := THIS.M_Step_SetPickOffsetAndPCS_Tracking();
    E_PickPlace_State#EnablePickTracking:               M_Dispatcher := THIS.M_Step_EnablePickTracking();
    E_PickPlace_State#StartMovePath:                    M_Dispatcher := THIS.M_Step_StartMovePath();
    E_PickPlace_State#ApproachPick_Tracking:            M_Dispatcher := THIS.M_Step_ApproachPick_Tracking();
    E_PickPlace_State#WaitForPickSync:                  M_Dispatcher := THIS.M_Step_WaitForPickSync();
    E_PickPlace_State#DescendAndPick:                   M_Dispatcher := THIS.M_Step_DescendAndPick();
    E_PickPlace_State#WaitAfterPick_Tracking:           M_Dispatcher := THIS.M_Step_WaitAfterPick_Tracking();
    E_PickPlace_State#AscendAfterPick:                  M_Dispatcher := THIS.M_Step_AscendAfterPick();
    E_PickPlace_State#MoveToParking_AfterPick:          M_Dispatcher := THIS.M_Step_MoveToParking_AfterPick();
    E_PickPlace_State#SelectNextProduct_Pick:           M_Dispatcher := THIS.M_Step_SelectNextProduct_Pick();
    
    E_PickPlace_State#InitializePlace:                  M_Dispatcher := THIS.M_Step_InitializePlace();
    E_PickPlace_State#CheckPlaceLimits:                 M_Dispatcher := THIS.M_Step_CheckPlaceLimits();
    E_PickPlace_State#SetPlaceFrame_Tracking:           M_Dispatcher := THIS.M_Step_SetPlaceFrame_Tracking();
    E_PickPlace_State#ConvertPlaceToCartesian_Tracking: M_Dispatcher := THIS.M_Step_ConvertPlaceToCartesian_Tracking();
    E_PickPlace_State#SetPlaceOffsetAndPCS_Tracking:    M_Dispatcher := THIS.M_Step_SetPlaceOffsetAndPCS_Tracking();
    E_PickPlace_State#EnablePlaceTracking:              M_Dispatcher := THIS.M_Step_EnablePlaceTracking();
    E_PickPlace_State#ApproachPlace_Tracking:           M_Dispatcher := THIS.M_Step_ApproachPlace_Tracking();
    E_PickPlace_State#WaitForPlaceSync:                 M_Dispatcher := THIS.M_Step_WaitForPlaceSync();
    E_PickPlace_State#DescendAndPlace:                  M_Dispatcher := THIS.M_Step_DescendAndPlace();
    E_PickPlace_State#WaitAfterPlace_Tracking:          M_Dispatcher := THIS.M_Step_WaitAfterPlace_Tracking();
    E_PickPlace_State#AscendAfterPlace:                 M_Dispatcher := THIS.M_Step_AscendAfterPlace();
    E_PickPlace_State#MoveToParking_AfterPlace:         M_Dispatcher := THIS.M_Step_MoveToParking_AfterPlace();
    E_PickPlace_State#CycleCompletitionAndChangeMode:   M_Dispatcher := THIS.M_Step_CycleCompletitionAndChangeMode();
    
    E_PickPlace_State#InitializeFinalParking:           M_Dispatcher := THIS.M_Step_InitParking();
    E_PickPlace_State#MoveToParking_SafePosition:       M_Dispatcher := THIS.M_Step_MoveToParking_SafePosition();
    E_PickPlace_State#FinalParkingCompletition:         M_Dispatcher := THIS.M_Step_FinalParkingCompletition();
    
    E_PickPlace_State#Error:                            M_Dispatcher := THIS.M_Step_Error();
ELSE
    // safe fallback
    M_Dispatcher := E_StepStatus#ERROR;
END_CASE