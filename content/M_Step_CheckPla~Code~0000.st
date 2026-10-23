// METHOD: M_Step_CheckPlaceLimits
// DESCRIPTION: Verifies if the Place destination is within robot limits.

UsePointer_Place := stPickPlaceProductData_Place[GroupNumber].UsePointer;
StorePointer_Place := stPickPlaceProductData_Place[GroupNumber].StorePointer;
ActProdX_Place := stPickPlaceProductData_Place[GroupNumber].ProductDetails[UsePointer_Place].ProductPosition[1];
ActProdY_Place := stPickPlaceProductData_Place[GroupNumber].ProductDetails[UsePointer_Place].ProductPosition[2];

IF (ActProdX_Place > DATA_Machine.Setting.LimitPos[0].X_Limits[GroupNumber].PosMin) AND
   (ActProdX_Place < DATA_Machine.Setting.LimitPos[0].X_Limits[GroupNumber].PosMax) AND
   (ActProdY_Place > DATA_Machine.Setting.LimitPos[0].Y_Limits.PosMin) AND
   (ActProdY_Place < DATA_Machine.Setting.LimitPos[0].Y_Limits.PosMax) AND
   UsePointer_Place <= StorePointer_Place THEN
    
    M_Step_CheckPlaceLimits := E_StepStatus#DONE;
ELSE
    M_Step_CheckPlaceLimits := E_StepStatus#ERROR;
END_IF;