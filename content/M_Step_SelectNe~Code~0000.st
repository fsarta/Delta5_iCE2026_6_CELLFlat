// METHOD: M_Step_SelectNextProduct_Pick
// DESCRIPTION: Logic to update product pointers.

// 1. Entry Action
IF NOT bStepInitialized THEN
    // Logica di selezione puntatori...
    IF MultiGrpProductData[0].UsePointer <> MultiGrpProductData[0].StorePointer THEN 
        iGroupNumber_Pick := GroupNumber;
        xiSelectNextProduct_Pick := TRUE;
    ELSE 
        // Nessun altro prodotto nel gruppo
        stPickPlaceProductData_Pick[GroupNumber].UsePointer := 0;
        bGoToNextPhase := TRUE; // Flag locale per dire "abbiamo finito il pick"
    END_IF;  
    bStepInitialized := TRUE;
END_IF;

// 2. Cyclic Logic
IF xiSelectNextProduct_Pick THEN
    // Aspettiamo la risposta dalla visione/gestore code
    IF xoSelectNextProductDone_Pick THEN
        xiSelectNextProduct_Pick := FALSE;
        // La selezione è finita, ora decidiamo DOVE andare.
        
        // --- LOGICA DI BRANCHING ---
        IF bDoubleModeForThisCycle AND (iGripperForThisCycle = 0) THEN
            // Siamo in Double Mode e abbiamo appena fatto il primo Pick.
            // DOBBIAMO TORNARE INDIETRO A PRENDERNE UN ALTRO!
            eRequestedJumpState := E_PickPlace_State#Initialize; // Torna all'inizio (o a CheckPickLimits)
        ELSE
            // Single Mode oppure secondo Pick completato.
            // Lasciamo eRequestedJumpState a _Unknown, così il motore andrà avanti (verso Place)
            ; 
        END_IF
        
        M_Step_SelectNextProduct_Pick := E_StepStatus#DONE;

    ELSIF xoSelectNextProductError_Pick THEN
        M_Step_SelectNextProduct_Pick := E_StepStatus#ERROR;
    ELSE
        M_Step_SelectNextProduct_Pick := E_StepStatus#BUSY;
    END_IF

ELSE
    // Caso in cui non serviva selezionare (bGoToNextPhase = TRUE)
    // Proseguiamo normalmente verso il Place
    M_Step_SelectNextProduct_Pick := E_StepStatus#DONE;
END_IF;