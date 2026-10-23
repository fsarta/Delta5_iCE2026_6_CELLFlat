(*********************************************************************************************************************************************)
(*****************************************************           Events Section         ******************************************************)
(*********************************************************************************************************************************************)
R_TRIG_Exe(CLK:=Execute);


(*  This line causes the function block to exit if the execute, and all outputs are off.  (For efficiency.)  *)
(*  IMPORTANT, be sure to include CommandAborted in the interlock logic if a motion block will be used.      *)
IF NOT(Execute) AND NOT(iActive) AND NOT(Busy) AND NOT(Done) AND NOT(Error) THEN RETURN; END_IF;



iActive:= Execute OR (iActive AND NOT(Done) AND NOT(Error));



(*********************************************************************************************************************************************)
(**************************************************          Initialization Section         **************************************************)
(*********************************************************************************************************************************************)
IF R_TRIG_Exe.Q THEN   				(*  Things to do when the function starts up for the first time  *)

	DetectedProductsINT := REAL_TO_INT(DetectedProducts);

	(* Size of each input array (X Y Z Rx Ry Rz) in number of elements. Assumed to be array of REAL *)
	MaxInputProducts:=UDINT_TO_INT(SIZEOF(ProductX)/UDINT#4);

	(* Error if detected products above maximum amount *)
	MaxProductsError := (DetectedProductsINT > MaxInputProducts) OR (DetectedProductsINT < INT#0);

	(* byte count size of the real array to copy into FormattedProductData *)
	BufferByteCount := INT_TO_DINT(DetectedProductsINT*INT#4);

	(* Initialize FormattedProductData *)
	FOR j := INT#0 TO MaxInputProducts*INT#8 BY INT#1 DO
		FormattedProductData[j] := REAL#0.0;
	END_FOR;

END_IF;



(*********************************************************************************************************************************************)
(**************************************************          Error Handling Section         **************************************************)
(*********************************************************************************************************************************************)
Error:=(Execute OR iActive) AND 
		(FormatXError OR FormatYError OR FormatZError 
			OR FormatRxError OR FormatRyError OR FormatRzError 
			OR FormatProductTypeError OR FormatUserDataError OR MaxProductsError);
IF Error THEN
	IF FormatXError THEN ErrorID:=INT_TO_UINT(FormatXStatus); END_IF;
	IF FormatYError THEN ErrorID:=INT_TO_UINT(FormatYStatus); END_IF;	
	IF FormatZError THEN ErrorID:=INT_TO_UINT(FormatZStatus); END_IF;
	IF FormatRxError THEN ErrorID:=INT_TO_UINT(FormatRxStatus); END_IF;
	IF FormatRyError THEN ErrorID:=INT_TO_UINT(FormatRyStatus); END_IF;	
	IF FormatRzError THEN ErrorID:=INT_TO_UINT(FormatRzStatus); END_IF;
	IF FormatProductTypeError THEN ErrorID:=INT_TO_UINT(FormatProductTypeStatus); END_IF;	
	IF FormatUserDataError THEN ErrorID:=INT_TO_UINT(FormatUserDataStatus); END_IF;
	IF MaxProductsError THEN ErrorID:=UINT#10649; END_IF;

ELSE
	ErrorID:=UINT#0; 
END_IF;



(*********************************************************************************************************************************************)
(**************************************************          Main Operation Section         **************************************************)
(*********************************************************************************************************************************************)
IF Execute AND NOT(Error) THEN
	Start := TRUE;
	(* First element is the detect products *)
	FormattedProductData[0] := DetectedProducts;
ELSE
	Start := FALSE;
END_IF;



(*********************************************************************************************************************************************)
(***********************************          Main Operation Section                                          ********************************)
(*********************************************************************************************************************************************)

REAL_TO_BUF_1(
	REQ:=iActive AND (Start OR (FormatXStatus <> 0) OR FormatXError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#4,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductX,
	BUFFER:=FormattedProductData
);
FormatXDone:=REAL_TO_BUF_1.DONE;
FormatXError:=REAL_TO_BUF_1.ERROR;
FormatXStatus:=REAL_TO_BUF_1.STATUS;

REAL_TO_BUF_2(
	REQ:=iActive AND (Start OR (FormatYStatus <> 0) OR FormatYError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#204,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductY,
	BUFFER:=FormattedProductData
);
FormatYDone:=REAL_TO_BUF_2.DONE;
FormatYError:=REAL_TO_BUF_2.ERROR;
FormatYStatus:=REAL_TO_BUF_2.STATUS;

REAL_TO_BUF_3(
	REQ:=iActive AND (Start OR (FormatZStatus <> 0) OR FormatZError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#404,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductZ,
	BUFFER:=FormattedProductData
);
FormatZDone:=REAL_TO_BUF_3.DONE;
FormatZError:=REAL_TO_BUF_3.ERROR;
FormatZStatus:=REAL_TO_BUF_3.STATUS;

REAL_TO_BUF_4(
	REQ:=iActive AND (Start OR (FormatRxStatus <> 0) OR FormatRxError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#604,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductRx,
	BUFFER:=FormattedProductData
);
FormatRxDone:=REAL_TO_BUF_4.DONE;
FormatRxError:=REAL_TO_BUF_4.ERROR;
FormatRxStatus:=REAL_TO_BUF_4.STATUS;

REAL_TO_BUF_5(
	REQ:=iActive AND (Start OR (FormatRyStatus <> 0) OR FormatRyError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#804,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductRy,
	BUFFER:=FormattedProductData
);
FormatRyDone:=REAL_TO_BUF_5.DONE;
FormatRyError:=REAL_TO_BUF_5.ERROR;
FormatRyStatus:=REAL_TO_BUF_5.STATUS;

REAL_TO_BUF_6(
	REQ:=iActive AND (Start OR (FormatRzStatus <> 0) OR FormatRzError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#1004,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductRz,
	BUFFER:=FormattedProductData
);
FormatRzDone:=REAL_TO_BUF_6.DONE;
FormatRzError:=REAL_TO_BUF_6.ERROR;
FormatRzStatus:=REAL_TO_BUF_6.STATUS;

REAL_TO_BUF_7(
	REQ:=iActive AND (Start OR (FormatProductTypeStatus <> 0) OR FormatProductTypeError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#1204,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductType,
	BUFFER:=FormattedProductData
);
FormatProductTypeDone:=REAL_TO_BUF_7.DONE;
FormatProductTypeError:=REAL_TO_BUF_7.ERROR;
FormatProductTypeStatus:=REAL_TO_BUF_7.STATUS;

REAL_TO_BUF_8(
	REQ:=iActive AND (Start OR (FormatUserDataStatus <> 0) OR FormatUserDataError),
	BUF_FORMAT:=FALSE,
	BUF_OFFS:=DINT#1404,
	BUF_CNT:=BufferByteCount,
	SRC:=ProductUserData,
	BUFFER:=FormattedProductData
);
FormatUserDataDone:=REAL_TO_BUF_8.DONE;
FormatUserDataError:=REAL_TO_BUF_8.ERROR;
FormatUserDataStatus:=REAL_TO_BUF_8.STATUS;

Complete:=FormatXDone AND FormatYDone AND FormatZDone 
			AND FormatRxDone AND FormatRyDone AND FormatRzDone 
			AND FormatProductTypeDone AND FormatUserDataDone;



(*********************************************************************************************************************************************)
(*****************************************************          Set Busy Output         ******************************************************)
(*********************************************************************************************************************************************)
Busy:= (FALSE) AND NOT(Error);



(*********************************************************************************************************************************************)
(*****************************************************          Set Done Output         ******************************************************)
(*********************************************************************************************************************************************)
Done:=Complete OR (Execute AND Done);