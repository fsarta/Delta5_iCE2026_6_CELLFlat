//================================================================================
// Yaskawa Italia srl
//(c)Copyright Yaskawa Italia srl All Rights Reserved
//--------------------------------------------------------------------------------
// Library: libParamSDO
// DataType: dtlibParamSDO
// Tested with: iC9226M-FSoE
// Engineering: iCube Engineer 2024.9  (Build 6.0.15981.0)
// Requirements: iC9226M-EC / iC9226M-FSoE
// Functionality: manage reading/writing SDO parameter to servopacks
//--------------------------------------------------------------------------------
// Change log table:
// Version Date           Expert in charge                    Changes applied
// 1.0     30-03-2025     FZa(Francesco.Zanette@yaskawa.eu)   New Version Released
//================================================================================

(*
Objects 2000h to 26FFh are mapped to SERVOPACK parameters (Pn).
Object index 2h corresponds to Pn in the SERVOPACK parameters (e.g., object
2100h is the same as Pn100).
*)

CASE step OF
    
    
    0:  // Jump
        IF execute THEN
            step := 1;
        END_IF;
    
    1:  // Init
        FOR i:=1 TO TO_INT(size) DO
            ArrayParams[i].Status.Done := FALSE;
            ArrayParams[i].Status.Error := FALSE;
            ArrayParams[i].Status.ErrorID := 0;
            ArrayParams[i].Status.ReadValue := 0;
        END_FOR;
        i := 1;
        step := 2;
        
    2:  // Check valid param
        IF ArrayParams[i].Setup.Param <> 0 THEN
            // read or write
            IF ArrayParams[i].Setup.ReadWrite = 0 THEN
                step := 10;
            ELSIF ArrayParams[i].Setup.ReadWrite = 1 THEN
                step := 20;
            END_IF;
        // End
        ELSE
            step := 99;
        END_IF;  
        
    10: // Read
        Y_EC_COE_SdoRead1.Index := TO_WORD(TO_UINT(ArrayParams[i].Setup.Param));  // + 16#2000);
        Y_EC_COE_SdoRead1.Subindex := ArrayParams[i].Setup.SubIndex;
        Y_EC_COE_SdoRead1.Execute := TRUE;
        IF Y_EC_COE_SdoRead1.Done THEN
            ArrayParams[i].Status.Done := TRUE;
           
            // Format (Integer, UnsignedInt, DoubleInt, UnsignedDInt)
            IF ArrayParams[i].Setup.Format = 0 THEN
                tmpDWORD.%B0 := record[0];
                tmpDWORD.%B1 := record[1];
                ArrayParams[i].Status.ReadValue := TO_INT(tmpDWORD);               
            ELSIF ArrayParams[i].Setup.Format = 1 THEN
                tmpDWORD.%B0 := record[0];
                tmpDWORD.%B1 := record[1];
                ArrayParams[i].Status.ReadValue := TO_UINT(tmpDWORD);
            ELSIF ArrayParams[i].Setup.Format = 2 THEN
                tmpDWORD.%B0 := record[0];
                tmpDWORD.%B1 := record[1];
                tmpDWORD.%B2 := record[2];
                tmpDWORD.%B3 := record[3];
                ArrayParams[i].Status.ReadValue := TO_DINT(tmpDWORD);
            ELSIF ArrayParams[i].Setup.Format = 3 THEN
                tmpDWORD.%B0 := record[0];
                tmpDWORD.%B1 := record[1];
                tmpDWORD.%B2 := record[2];
                tmpDWORD.%B3 := record[3];
                ArrayParams[i].Status.ReadValue := TO_DINT(tmpDWORD);                            
            END_IF;
           Y_EC_COE_SdoRead1.Execute := FALSE;
           step := 30;
        ELSIF Y_EC_COE_SdoRead1.Error THEN
            error := TRUE;
            ArrayParams[i].Status.Error := TRUE;
            ArrayParams[i].Status.ErrorID := Y_EC_COE_SdoRead1.ErrorID;
            Y_EC_COE_SdoRead1.Execute := FALSE;
            step := 30;
        END_IF;
            
    20: // Write
        Y_EC_COE_SdoWrite1.Index := TO_WORD(TO_UINT(ArrayParams[i].Setup.Param));
        Y_EC_COE_SdoWrite1.Subindex := ArrayParams[i].Setup.SubIndex;
        tmpDWORD := DINT_TO_DWORD(ArrayParams[i].Setup.Value);
        
        // Format (Integer, UnsignedInt, DoubleInt, UnsignedDInt)
        IF ArrayParams[i].Setup.Format = 0 
            OR ArrayParams[i].Setup.Format = 1
        THEN
            Y_EC_COE_SdoWrite1.Length := 2;
            record[0] := tmpDWORD.%B0;
            record[1] := tmpDWORD.%B1;            
        ELSIF ArrayParams[i].Setup.Format = 2 
            OR ArrayParams[i].Setup.Format = 3
        THEN
            Y_EC_COE_SdoWrite1.Length := 4;
            record[0] := tmpDWORD.%B0;
            record[1] := tmpDWORD.%B1;
            record[2] := tmpDWORD.%B2;
            record[3] := tmpDWORD.%B3;              
        END_IF;
        
        Y_EC_COE_SdoWrite1.Execute := TRUE;
        IF Y_EC_COE_SdoWrite1.Done THEN
           ArrayParams[i].Status.Done := TRUE;
           Y_EC_COE_SdoWrite1.Execute := FALSE;
           step := 30;
        ELSIF Y_EC_COE_SdoWrite1.Error THEN
            error := TRUE;
            ArrayParams[i].Status.Error := TRUE;
            ArrayParams[i].Status.ErrorID := Y_EC_COE_SdoWrite1.ErrorID;
            Y_EC_COE_SdoWrite1.Execute := FALSE;
            step := 30;
        END_IF;             
    
    30: // next i-parameter
        IF i < size THEN
            i := i + 1;
            step := 2;
            
        // End
        ELSE
            step := 99;
        END_IF; 

    99 : // End
        done := TRUE;
        IF NOT execute THEN
            done := FALSE;
            error := FALSE;
            step := 0;
        END_IF;    
        
    ELSE 
        
END_CASE        


// Call Function
size := UPPER_BOUND(ArrayParams, 1);

Y_EC_COE_SdoWrite1(
    Record := record, 
    // Execute := BOOL, 
    NetworkID := WORD#01,           // Network ID of the EtherCAT master
    StationAddress := TO_WORD(stationAddr) //,// EtherCAT station address of the slave/master. The EtherCAT Master has StationAddress 0.
    // Index := WORD,               // Index of the object that is to be written
    // Subindex := BYTE,            // Subindex of the object that is to be written
    // Length := UDINT,             // If a value of 0 is passed, then the full size of teh Record data type is used by default.
    // Timeout := UINT,             // Timeout value in ms. A value of 0 is not allowed and will be treated as the default (5000)
    // CompleteAccess := BOOL,
    // Done => BOOL,  
    // Busy => BOOL, 
    // Error => BOOL, 
    // ErrorID => UINT, 
    );
    
Y_EC_COE_SdoRead1(
    Record := record, 
    // Execute := BOOL, 
    NetworkID := WORD#01,           // Network ID of the EtherCAT master
    StationAddress := TO_WORD(stationAddr) //,// EtherCAT station address of the slave/master. The EtherCAT Master has StationAddress 0.
    // Index := WORD,               // Index of the object that is to be written
    // Subindex := BYTE,            // Subindex of the object that is to be written
    // MaxLength := UDINT, 
    // Timeout := UINT,             // Timeout value in ms. A value of 0 is not allowed and will be treated as the default (5000)
    // CompleteAccess := BOOL, 
    // Done => BOOL, 
    // Busy => BOOL, 
    // Error => BOOL, 
    // ErrorID => UINT, 
    // Length => UDINT
);