// Converts two bytes (Little-Endian) to an INT (16-bit)

iResult := TO_INT(SHL(bLow, 8) OR bHigh);
FC_BytesToInt := iResult;