// Implementation of the method (same as the global function before)
GetErrorMessage := 'Unknown Error ID. Please refer to documentation.'; // Default message if not found

FOR i := 1 TO C_MAX_ERROR_LOOKUP_ENTRIES DO
    IF G_ErrorLookupTable[i].ErrorCode = udiErrorID THEN
        GetErrorMessage := G_ErrorLookupTable[i].Message;
        EXIT; // Found the message, exit the loop
    END_IF
END_FOR