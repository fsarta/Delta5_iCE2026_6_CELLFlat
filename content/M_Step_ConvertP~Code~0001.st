// METHOD: M_Step_ConvertPlaceToCartesian_Tracking

VECTOR_TO_CARTESIANREF2(Vector := FrameTypeTransform_FeedOut.FrameCoordinates, CartesianRef => FeedOut_FrameOffset);

// 1. Seleziona l'offset della pinza attiva (come fatto nel Pick)
IF iGripperForThisCycle = 0 THEN
    lrOffX := stGripper1_Offset[0];
    lrOffY := stGripper1_Offset[1];
ELSE
    lrOffX := stGripper2_Offset[0];
    lrOffY := stGripper2_Offset[1];
END_IF;

lrPlaceAngleRad := DEG_TO_RAD(ActProdRZ_Place); 
lrSinPlace      := SIN(lrPlaceAngleRad);
lrCosPlace      := COS(lrPlaceAngleRad);

ActProdX_Place := TargetPlaceX_Raw - (lrOffX * lrCosPlace - lrOffY * lrSinPlace);
ActProdY_Place := (TargetPlaceY_Raw - (lrOffX * lrSinPlace + lrOffY * lrCosPlace)) - (TO_LREAL(counterY) * 40.0);
ActProdRZ_Place := TargetPlaceRz_Raw;

// Logica da eseguire alla fine del singolo ciclo di piazzamento:
counterY := counterY + 1;
IF counterY > 2 THEN
    counterY := 0;
END_IF;

M_Step_ConvertPlaceToCartesian_Tracking := E_StepStatus#DONE;