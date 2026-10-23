(*
-------------------------------------------------------------------------
    METHOD FB_VisorDriver.MapOutputs 
    Packs the internal stOutput structure back into the raw byte array
    for transmission over Ethernet/IP.
-------------------------------------------------------------------------
*)

// --- Assemble Control Bits into Byte 0 ---
IF stOutput.Control_Bits.ResetError THEN
    bTemp := bTemp OR BYTE#1;   // Bit 0
END_IF;

IF stOutput.Control_Bits.TriggerDisable THEN
    bTemp := bTemp OR BYTE#2;   // Bit 1
END_IF;

IF stOutput.Control_Bits.Trigger THEN
    bTemp := bTemp OR BYTE#4;   // Bit 2
END_IF;

IF stOutput.Control_Bits.ChangeJob THEN
    bTemp := bTemp OR BYTE#8;   // Bit 3
END_IF;

IF stOutput.Control_Bits.SwitchToRun THEN
    bTemp := bTemp OR BYTE#16;  // Bit 4
END_IF;

IF stOutput.Control_Bits.RepeatEnable THEN
    bTemp := bTemp OR BYTE#32;  // Bit 5
END_IF;
// Bits 6-7 reserved 

Visor_Transmit[0] := bTemp;

// --- Byte 1: Spare ---
Visor_Transmit[1] := stOutput.Spare_Byte1; 

// --- Byte 2: JobNumberOut ---
Visor_Transmit[2] := TO_BYTE(stOutput.JobNumberOut); // USINT to BYTE