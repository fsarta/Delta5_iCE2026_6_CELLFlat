cx := COS(fRxDeg * c_D2R);   sx := SIN(fRxDeg * c_D2R);
cy := COS(fRyDeg * c_D2R);   sy := SIN(fRyDeg * c_D2R);
cz := COS(fRzDeg * c_D2R);   sz := SIN(fRzDeg * c_D2R);

// R = Rz * Ry * Rx
m[1] :=  cy*cz;
m[2] := sx*sy*cz - cx*sz;
m[3] := cx*sy*cz + sx*sz;

m[4] :=  cy*sz;               
m[5] := sx*sy*sz + cx*cz;    
m[6] := cx*sy*sz - sx*cz;

m[7] := -sy;                 
m[8] := sx*cy;                
m[9] := cx*cy;

M_BuildRotMatrix := m;