(*
====================================================================================================
 PRIVATE METHOD RecalculateHighestSeverity (NEW HELPER)
====================================================================================================
 Scans the entire buffer *only* for the highest severity level
 among active errors.
 This is called only when an error is resolved, as the removed error
 *might* have been the one with the highest severity.
====================================================================================================
*)

FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
    IF G_ErrorBuffer[i].IsActive THEN
        IF G_ErrorBuffer[i].Severity > eHighestSeverityLocal THEN
            eHighestSeverityLocal := G_ErrorBuffer[i].Severity;
        END_IF
    END_IF
END_FOR;

G_stOverallErrorStatus.eHighestSeverity := eHighestSeverityLocal;