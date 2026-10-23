Y_YA_RealTimeClock1(
    Enable := TRUE, 
    //Valid => BOOL, 
    //Error => BOOL, 
    //ErrorID => UINT, 
    Clock => SysTimestamp
    //RTCString => STRING
    );
    
// 1. Determina il messaggio finale dell'errore (solo se bErrorDetected è TRUE per una nuova aggiunta)
IF bErrorDetected THEN
    IF LEN(sErrorMessage) > 0 THEN
        sFinalErrorMessage := sErrorMessage;
    ELSE
        sFinalErrorMessage := THIS.GetErrorMessage(udiErrorID);
    END_IF;
END_IF;

// 2. Cerca l'errore nel buffer: vogliamo sapere se c'è già una versione ATTIVA o INATTIVA
FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
    IF G_ErrorBuffer[i].ErrorCode = udiErrorID AND
       G_ErrorBuffer[i].ErrorSource = sErrorSource THEN
        IF G_ErrorBuffer[i].IsActive THEN
            udiActiveMatchIndex := i; // Trovata una voce attiva
            EXIT; // Trovata una corrispondenza attiva, non cercare oltre per l'attivazione
        //ELSIF udiInactiveMatchIndex = 0 THEN // Memorizza solo il primo inattivo trovato
        //    udiInactiveMatchIndex := i;
        END_IF;
    END_IF;
    IF G_ErrorBuffer[i].ErrorSource = sErrorSource AND
       G_ErrorBuffer[i].IsActive AND NOT(bErrorDetected) THEN
        udiInactiveMatchIndex := i;
        EXIT; // Trovata la corrispondenza attiva, non cercare oltre per la disattivazione
    END_IF;
END_FOR;

// 3. Logica basata sullo stato di bErrorDetected
IF bErrorDetected THEN // La condizione di errore è attualmente TRUE
    IF udiActiveMatchIndex = 0 THEN
        // Caso 1: L'errore NON è attualmente attivo nel buffer.
        // Questo significa che è un NUOVO errore O un errore che è passato da FALSE a TRUE.
        // Aggiungiamo sempre una nuova voce al buffer circolare.
        G_ErrorBuffer[G_udiErrorHead].ErrorCode := udiErrorID;
        G_ErrorBuffer[G_udiErrorHead].ErrorSource := sErrorSource;
        G_ErrorBuffer[G_udiErrorHead].ErrorMessage := sFinalErrorMessage;
        G_ErrorBuffer[G_udiErrorHead].Severity := eErrorSeverity;
        G_ErrorBuffer[G_udiErrorHead].IsActive := TRUE;
        G_ErrorBuffer[G_udiErrorHead].Timestamp := SysTimestamp;
        G_ErrorBuffer[G_udiErrorHead].Acknowledged := FALSE;

        G_udiErrorHead := G_udiErrorHead + 1;
        IF G_udiErrorHead > C_ERROR_BUFFER_SIZE THEN
            G_udiErrorHead := 1;
        END_IF;

        IF G_udiErrorHead = G_udiErrorTail THEN
            G_bBufferFull := TRUE;
            G_udiErrorTail := G_udiErrorTail + 1; // Sovrascrivi l'elemento più vecchio
            IF G_udiErrorTail > C_ERROR_BUFFER_SIZE THEN
                G_udiErrorTail := 1;
            END_IF;
        END_IF;
        bActionPerformed := TRUE;
    ELSE
        // Caso 2: L'errore è GIÀ ATTIVO nel buffer (udiActiveMatchIndex <> 0).
        // La condizione è TRUE, l'errore è già registrato come attivo.
        // Non fare nulla per aggiungere un nuovo errore.
        // Se fosse stato ACKed, la logica di ACKing globale gestirà bAcknowledged := FALSE.
        // Aggiorna solo il timestamp se non è acknowledged, per mostrare che è ancora "fresco".
        IF G_ErrorBuffer[udiActiveMatchIndex].Acknowledged THEN
             G_ErrorBuffer[udiActiveMatchIndex].Acknowledged := FALSE; // Rimuovi ACK se l'errore persiste/riappare
             G_ErrorBuffer[udiActiveMatchIndex].Timestamp := SysTimestamp; // Aggiorna timestamp
        END_IF;
        G_ErrorBuffer[udiActiveMatchIndex].Severity := eErrorSeverity; // Aggiorna severità in caso di cambio
        bActionPerformed := TRUE; // L'errore è stato "gestito" rimanendo attivo
    END_IF;
ELSE // bErrorDetected è FALSE. La condizione di errore non è più TRUE.
    IF udiInactiveMatchIndex <> 0 THEN
        // Caso 3: L'errore era ATTIVO e ora la condizione è FALSE.
        // Disattiva questa specifica istanza attiva nel buffer.
        G_ErrorBuffer[udiInactiveMatchIndex].IsActive := FALSE;
        // G_ErrorBuffer[udiInactiveMatchIndex].Acknowledged := FALSE; // Resetta ACK per la prossima occorrenza
        // TODO OPTIONAL: Pulisci altri campi per un "nuovo inizio" per l'entry
        // G_ErrorBuffer[udiInactiveMatchIndex].ErrorCode := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].ErrorSource := '';
        // G_ErrorBuffer[udiInactiveMatchIndex].ErrorMessage := '';
        // G_ErrorBuffer[udiInactiveMatchIndex].Severity := E_ErrorSeverity#None;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.Year := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.Month := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.Day := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.Hour := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.Minute := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.Second := 0;
        // G_ErrorBuffer[udiInactiveMatchIndex].Timestamp.mSec := 0;
        bActionPerformed := TRUE;
    ELSE
        // Caso 4: L'errore non è attivo nel buffer E la condizione è FALSE.
        // Nulla da fare. L'errore non c'era o era già stato disattivato.
        bActionPerformed := FALSE;
    END_IF;
END_IF;

AddUpdateError := bActionPerformed;