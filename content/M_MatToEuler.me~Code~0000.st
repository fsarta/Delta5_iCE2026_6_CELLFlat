// Ry ricavata da m31 = -sin(Ry)
res.fRy := ASIN(-mR[7]) * c_R2D;
fCosY   := COS(res.fRy * c_D2R);

IF ABS(fCosY) > c_EPS THEN
    // Caso normale
    res.fRx        := ATAN2(mR[8], mR[9], 0) * c_R2D;
    res.fRz        := ATAN2(mR[4], mR[1], 0) * c_R2D;
    res.bGimbalLock := FALSE;
ELSE
    // Gimbal lock: |Ry| ≈ 90° → poniamo Rz=0 e risolviamo Rx
    res.fRz        := 0.0;
    res.bGimbalLock := TRUE;
    IF mR[7] < 0.0 THEN   // Ry ≈ +90°
        res.fRy := 90.0;
        res.fRx := ATAN2( mR[2],  mR[5], 0) * c_R2D;
    ELSE                    // Ry ≈ -90°
        res.fRy := -90.0;
        res.fRx := ATAN2(-mR[2], -mR[5], 0) * c_R2D;
    END_IF
END_IF

M_MatToEuler := res;