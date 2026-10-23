// Converts four bytes (Little-Endian) to a REAL (32-bit)

temp0 := TO_WORD(b0);
temp1 := TO_WORD(b1);
temp2 := TO_WORD(b2);
temp3 := TO_WORD(b3);

diTemp := SHL(temp0, 24) OR
          SHL(temp1, 16) OR
          SHL(temp2, 8) OR
          temp3;
          
udiResult := TO_DINT(diTemp); 
rResult := TO_REAL(udiResult); 

FC_BytesToReal := rResult;