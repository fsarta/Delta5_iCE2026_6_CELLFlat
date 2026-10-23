r[1] := mA[1]*mB[1] + mA[2]*mB[4] + mA[3]*mB[7];
r[2] := mA[1]*mB[2] + mA[2]*mB[5] + mA[3]*mB[8];
r[3] := mA[1]*mB[3] + mA[2]*mB[6] + mA[3]*mB[9];

r[4] := mA[4]*mB[1] + mA[5]*mB[4] + mA[6]*mB[7];
r[5] := mA[4]*mB[2] + mA[5]*mB[5] + mA[6]*mB[8];
r[6] := mA[4]*mB[3] + mA[5]*mB[6] + mA[6]*mB[9];

r[7] := mA[7]*mB[1] + mA[8]*mB[4] + mA[9]*mB[7];
r[8] := mA[7]*mB[2] + mA[8]*mB[5] + mA[9]*mB[8];
r[9] := mA[7]*mB[3] + mA[8]*mB[6] + mA[9]*mB[9];

M_MatMul := r;