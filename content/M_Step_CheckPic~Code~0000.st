// Logic executes immediately, no need to wait
UsePointer_Pick := stPickPlaceProductData_Pick[GroupNumber].UsePointer;
StorePointer_Pick := stPickPlaceProductData_Pick[GroupNumber].StorePointer;
            
// Store raw coordinates from vision
ActProdX_Raw := stPickPlaceProductData_Pick[GroupNumber].ProductDetails[UsePointer_Pick].ProductPosition[1];
ActProdY_Raw := stPickPlaceProductData_Pick[GroupNumber].ProductDetails[UsePointer_Pick].ProductPosition[2];
ActProdRZ_Raw := stPickPlaceProductData_Pick[GroupNumber].ProductDetails[UsePointer_Pick].ProductPosition[6];
            
//IF (ActProdX_Raw >= DATA_Machine.Setting.LimitPos[0].X_Limits[GroupNumber].PosMin) AND
//                (ActProdX_Raw <= DATA_Machine.Setting.LimitPos[0].X_Limits[GroupNumber].PosMax) AND
//                (ActProdY_Raw >= DATA_Machine.Setting.LimitPos[0].Y_Limits.PosMin) AND
//                (ActProdY_Raw <= DATA_Machine.Setting.LimitPos[0].Y_Limits.PosMax) AND
//                UsePointer_Pick <= StorePointer_Pick THEN
//    
//    M_Step_CheckPickLimits := E_StepStatus#DONE;
//ELSE
//    M_Step_CheckPickLimits := E_StepStatus#ERROR;
//END_IF


IF (MultiGrpProductData[0].UsePointer <> MultiGrpProductData[0].StorePointer) THEN
    M_Step_CheckPickLimits := E_StepStatus#DONE;
ELSE
    M_Step_CheckPickLimits := E_StepStatus#BUSY;
END_IF