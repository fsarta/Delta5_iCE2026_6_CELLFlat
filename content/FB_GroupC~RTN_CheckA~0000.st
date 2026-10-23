MC_ReadParameter_1(
	Axis := Axis_Par,
	Enable := CMD_ReadParam,
	ParameterNumber := VAR_ParamNum
	);
	STS_ReadParamValid := MC_ReadParameter_1.Valid;
	STS_ReadParamBusy := MC_ReadParameter_1.Busy;
	STS_ReadParamError := MC_ReadParameter_1.Error;
	VAR_ReadParamErrorID := MC_ReadParameter_1.ErrorID;
	VAR_ParamValueRead := MC_ReadParameter_1.Value;

MC_WriteParameter_1(
	Axis := Axis_Par,
	Execute := CMD_WriteParam,
	ParameterNumber := VAR_ParamNum,
	Value := VAR_ParamValueWrite
	);
	STS_WriteParamDone := MC_WriteParameter_1.Done;
	STS_WriteParamBusy := MC_WriteParameter_1.Busy;
	STS_WriteParamError := MC_WriteParameter_1.Error;
	VAR_WiteParamErrorID := MC_WriteParameter_1.ErrorID;

// -----------------------------
// Main logic
// -----------------------------
IF checkAbsEncOffset AND NOT isBusyCheckAbsEncOffset THEN
    // Start process if not busy
    IF numAxesGroup > 0 THEN
        SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#READ_PARAM;
        currentAxisIndex := 1;
        isBusyCheckAbsEncOffset := TRUE;
    END_IF;
    
ELSIF isBusyCheckAbsEncOffset THEN
    CASE SM_currStateCheckAbsEncoder OF
        // -----------------------------
        // READ_PARAM: Configure axis and start read
        // -----------------------------
        E_checkAbsEncOffset#READ_PARAM:
            Axis_Par := arrCheckAbsEncoder[currentAxisIndex].axisRef;
            VAR_ParamNum := UINT#1838;  // Fixed parameter number
            CMD_ReadParam := TRUE;
            SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#VERIFY_READ;
        
        // -----------------------------
        // VERIFY_READ: Check read validity
        // -----------------------------
        E_checkAbsEncOffset#VERIFY_READ:
            IF STS_ReadParamValid THEN
                CMD_ReadParam := FALSE;
                
                IF VAR_ParamValueRead <> arrCheckAbsEncoder[currentAxisIndex].targetValue THEN
                    // Values differ - prepare write
                    VAR_ParamValueWrite := arrCheckAbsEncoder[currentAxisIndex].targetValue;
                    CMD_WriteParam := TRUE;
                    SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#WRITE_PARAM;
                ELSE
                    // Values match - move to next axis
                    CMD_ReadParam := FALSE;
                    currentAxisIndex := currentAxisIndex + 1;
                    
                    IF currentAxisIndex <= numAxesGroup THEN
                        SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#READ_PARAM;
                    ELSE
                        SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#COMPLETE;
                    END_IF;
                END_IF;
            END_IF;
        
        // -----------------------------
        // WRITE_PARAM: Handle parameter write
        // -----------------------------
        E_checkAbsEncOffset#WRITE_PARAM:
            IF STS_WriteParamDone THEN
                CMD_WriteParam := FALSE;
                CMD_ReadParam := FALSE;
                currentAxisIndex := currentAxisIndex + 1;
                
                IF currentAxisIndex <= numAxesGroup THEN
                    SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#READ_PARAM;
                ELSE
                    SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#COMPLETE;
                END_IF;
            END_IF;
        
        // -----------------------------
        // COMPLETE: Finalize process
        // -----------------------------
        E_checkAbsEncOffset#COMPLETE:
            isBusyCheckAbsEncOffset := FALSE;
            checkAbsEncOffset := FALSE;
            SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#IDLE;
    END_CASE;
    
ELSE
    // Reset commands when inactive
    CMD_ReadParam := FALSE;
    CMD_WriteParam := FALSE;
    SM_currStateCheckAbsEncoder := E_checkAbsEncOffset#IDLE;
END_IF;
