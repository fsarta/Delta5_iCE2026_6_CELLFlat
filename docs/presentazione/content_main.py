"""content_main.py — sezioni 00-17 della presentazione di training."""


def add(d):
    B, T, C, S, TW = d.bullets, d.table, d.code, d.statement, d.two

    # ---------------------------------------------------------------- 00
    d.section("00", "Premessa e percorso",
              "Come è strutturata questa formazione e come usare le slide",
              topics=["Obiettivo e pubblico", "Organizzazione del deck",
                      "Convenzioni sul codice"],
              notes="Due giornate consigliate. Il codice è la fonte di verità: le "
                    "slide dicono dove guardare e perché.")

    B("Obiettivo della formazione", [
        (0, "Cosa impariamo:"),
        (1, "come è fatta la cella Delta + due nastri, dall'alto verso il basso"),
        (1, "come è organizzato il software PLCnext (IEC 61131-3 Structured Text)"),
        (1, "perché ogni blocco è fatto così: specifiche, scelte, compromessi"),
        (1, "come si diagnostica: cosa guardare e in che ordine"),
        (0, "Cosa NON è:"),
        (1, "non è un manuale di iCube né di PLCnext"),
        (1, "non è un documento di collaudo o di sicurezza macchina"),
        (0, "Risultato atteso:"),
        (1, "saper toccare una parte senza rompere il resto"),
    ], size=17,
       notes="Pubblico: manutentori, sistemisti, chi eredita il progetto.")

    T("Indice delle sezioni", ["#", "Sezione", "Contenuto"], [
        ["01-04", "Sistema, runtime, hardware, organizzazione", "contesto e mappa del repository"],
        ["05", "Dati e tipi", "DT_HMI, DT_Machine, DT_Group, DataList/OPC"],
        ["06", "Macchina a stati", "FB_MachineController e 11 handler"],
        ["07", "Assi e gruppo", "FB_AxisController, FB_GroupController, blend"],
        ["08", "Sequencer", "playlist, dispatcher, driver, 24 step"],
        ["09", "Tracking e nastri", "la legge del nastro in 4 zone"],
        ["10-13", "Visione, errori, KPI, HMI", "i servizi trasversali"],
        ["14-17", "Sicurezza, casi di studio, procedure, debito", "il mestiere"],
        ["A-D", "Appendici", "schede POU, schede step, esercizi, riferimento"],
    ], size=12, col_widths=[1.4, 5.0, 5.0],
       notes="In due giornate le sezioni 06-09 occupano da sole mezza giornata.")

    B("Convenzioni sul codice", [
        (0, "Naming:"),
        (1, "FB_ = Function Block (con stato), FC_ = Function, M_ = metodo"),
        (1, "DATA_ / HMI_Data / G_ = strutture globali o dati condivisi"),
        (0, "Prefissi nelle strutture:"),
        (1, "r/lr = LREAL, i/udi/ui = interi, b/x = BOOL, st = STRUCT, e = ENUM"),
        (0, "Dove sta la verità:"),
        (1, "tipi nei .dt, codice nei .st, variabili nei .var"),
        (1, "il DataList (CFG_DAD2D28) decide cosa è pubblicato su OPC UA"),
        (0, "Nota:"),
        (1, "i nomi dei file esportati sono troncati (~0000): il riferimento certo è structure.xml"),
    ], size=16,
       notes="Le convenzioni permettono di capire da un nome se una variabile è "
             "persistente, un contatore o un comando.")

    # ---------------------------------------------------------------- 01
    d.section("01", "Il sistema",
              "Che macchina è, cosa deve fare, chi sono gli attori",
              topics=["Layout e flusso del prodotto", "Requisiti e vincoli",
                      "Attori e periferiche"],
              notes="Prima di leggere il codice: capire il processo fisico.")

    B("La macchina in una slide", [
        (0, "Cella robotizzata di pick & place su nastro in movimento (tracking)"),
        (0, "Robot Delta a 5 assi: S L U T B (B = rotazione del polso)"),
        (1, "gruppo cinematico locale DELTA, non EtherCAT"),
        (0, "Due nastri, entrambi assi servo:"),
        (1, "FeedIn (CI): porta i pezzi sotto la telecamera e verso il robot"),
        (1, "FeedOut (CO): porta via i pezzi depositati"),
        (0, "Visione: telecamera SensoPart VISOR sopra il FeedIn"),
        (1, "trigger fisico su distanza + latch di posizione sul servo (touch probe)"),
        (0, "Pinza: due gripper pneumatici (MainValveGripper / SecondaryValveGripper)"),
    ], size=16,
       notes="I nastri sono assi servo, non inverter: è questo che abilita il "
             "conveyor tracking di libreria (MC_TrackConveyorBelt).")

    TW("Flusso fisico del prodotto", "Ingresso", [
        (0, "Pezzi in fila sul FeedIn, spaziatura variabile"),
        (0, "La telecamera scatta ogni 140 mm di corsa"),
        (0, "Ogni foto produce 0-4 pezzi con X, Y, Rz"),
        (0, "Ogni pezzo è accodato con la posizione nastro allo scatto"),
        (0, "Coda circolare da 150 posizioni"),
    ], "Lavorazione e uscita", [
        (0, "Il sequencer prende il primo pezzo della coda"),
        (0, "Abilita il tracking: il robot si aggancia al nastro"),
        (0, "Scende in Z, chiude la pinza, risale (in inseguimento)"),
        (0, "Deposita sul FeedOut (in tracking) o in posizione fissa"),
        (0, "Torna in parking e ricomincia"),
    ], size=13,
       notes="Ciclo continuo: il nastro non si ferma mai per il prelievo. Il vincolo "
             "è che il pezzo non esca dalla finestra di tracking prima della presa.")

    B("Requisiti e vincoli di progetto", [
        (0, "Funzionali:"),
        (1, "prelievo in movimento senza fermare il nastro"),
        (1, "modalità singolo e doppio pezzo (due gripper)"),
        (1, "automatico e manuale (jog, posizionamento, teach frame)"),
        (0, "Sicurezza:"),
        (1, "E-stop di cella, porte con guard lock, STO su servo (CH0/CH1)"),
        (0, "Vincoli che hanno guidato le scelte:"),
        (1, "nastro e robot sincronizzati entro pochi mm"),
        (1, "il pezzo non deve uscire dalla finestra di tracking (EndDistance)"),
        (1, "lo stop ciclo deve essere sicuro: nessuna presa a metà"),
        (1, "l'HMI deve leggere tutto senza accedere a variabili non esposte"),
    ], size=16,
       notes="Questi tre vincoli spiegano finestra di tracking, rampa del nastro e "
             "abort-to-parking.")

    T("Attori e periferiche", ["Attore", "Interfaccia", "Ruolo"], [
        ["SensoPart VISOR", "Ethernet/IP (RX 72 B, TX 3 B)", "risultati visione"],
        ["7 servopack SGDXS", "EtherCAT", "5 assi Delta + FeedIn + FeedOut"],
        ["SliceBus safety I/O", "PROFINET / SliceBus", "E-stop, porte, STO, uscite sicure"],
        ["HMI", "OPC UA (variabili con flag OPC)", "comandi e diagnostica"],
        ["FMK / SDO", "servizi Arp", "parametri drive"],
        ["PC engineering", "iCube Engineer", "build, deploy, watch, debug"],
    ], size=12, col_widths=[2.6, 3.6, 5.0],
       notes="La telecamera non manda una coordinata: manda un telegramma con fino "
             "a 4 pezzi per foto.")

    S("Il nastro non si ferma mai: il robot deve inseguirlo.",
      "Da questa frase derivano conveyor tracking, finestra di tracking, rampa di "
      "velocità e abort-to-parking.",
      notes="Slide perno: tutto il resto ruota attorno a questo vincolo cinematico.")

    # ---------------------------------------------------------------- 02
    d.section("02", "Architettura di runtime",
              "Dove gira il codice: controller, risorse, task, programmi",
              topics=["Controller e risorsa", "I 6 task e le priorità",
                      "Programmi", "Watchdog", "Un ciclo da 2 ms"],
              notes="Ordine di esecuzione e tempi: la base per capire i problemi di "
                    "sincronizzazione.")

    T("Controller e risorse", ["Elemento", "Valore", "Significato"], [
        ["Controller", "iC9226M-FSoE", "PLCnext Control con FSoE"],
        ["Engineering", "iCube Engineer 2025.6", "build 7.2.38936.0"],
        ["Max program size", "12.582.912 B", "limite del programma"],
        ["Max data size", "67.108.856 B", "limite area dati"],
        ["Endianness", "LittleEndian", "rilevante per lo scambio byte EIP"],
    ], size=12, col_widths=[2.6, 3.4, 5.2],
       notes="HMI_Data è RETAIN: la parte ritentiva ha limiti propri, non conviene "
             "metterci array enormi.")

    T("I 6 task: priorità e tempi", ["Task", "Ciclo", "Prio", "Watchdog", "Cosa ci gira"], [
        ["FastTask", "2 ms", "0", "4 ms", "IO, PickPlaceManager"],
        ["MediumTask", "2 ms", "3", "8 ms", "Main (FB_MachineController), VisionManager"],
        ["RnR_Task", "16 ms", "5", "16 ms", "RebootAndReset"],
        ["SlowTask", "32 ms", "7", "32 ms", "HMI"],
        ["ErrorManagerTask", "64 ms", "0", "128 ms", "ErrorManager"],
        ["Warm/ColdStart", "0 ms", "0", "100 ms", "Init (una volta)"],
    ], size=12, col_widths=[2.2, 1.5, 1.2, 1.5, 4.8],
       notes="Priorità 0 = più alta. Il motion sta a 2 ms, l'HMI a 32 ms: nessun "
             "calcolo HMI può rallentare il motion.")

    C("Programmi e assegnazione ai task", """PROGRAM IO1              WITH FastTask         : IO
PROGRAM PickPlaceManager WITH FastTask         : PickPlaceManager
PROGRAM Main1            WITH MediumTask       : Main
PROGRAM VisionManager    WITH MediumTask       : VisionManager
PROGRAM HMI1             WITH SlowTask         : HMI
PROGRAM InitWarmStart1   WITH WarmStartTask    : Init
PROGRAM InitColdStart1   WITH ColdStartTask    : Init
PROGRAM RebootAndReset   WITH RnR_Task         : RebootAndReset
PROGRAM ErrorManager     WITH ErrorManagerTask : ErrorManager""",
      caption="Conta la priorità del task, non l'ordine di dichiarazione.",
      notes="Due istanze di Init (warm e cold start) sullo stesso programma: la "
            "differenza è il task che le invoca.")

    B("Perché questa ripartizione", [
        (0, "FastTask (2 ms): tutto ciò che tocca il movimento"),
        (1, "un jitter qui diventa errore di inseguimento sul pezzo"),
        (0, "MediumTask (2 ms): supervisione (macchina a stati, visione)"),
        (0, "SlowTask (32 ms): solo copia dati verso HMI_Data"),
        (1, "se l'HMI è lenta, il motion non se ne accorge"),
        (0, "Task dedicati per errori e riavvio:"),
        (1, "l'error handler non deve dipendere dal ciclo di macchina"),
        (0, "Regola di progetto:"),
        (1, "ogni variabile ha UN solo scrittore: nessun lock necessario"),
    ], size=16,
       notes="Il multi-task senza lock è sicuro solo grazie alla regola dello "
             "scrittore unico: vale la pena ripeterlo in ogni modifica.")

    B("Watchdog: perché i tempi sono stretti", [
        (0, "FastTask: 4 ms su ciclo 2 ms (fattore 2)"),
        (0, "MediumTask: 8 ms su ciclo 2 ms (fattore 4)"),
        (0, "SlowTask: 32 ms su ciclo 32 ms — nessun margine"),
        (0, "Conseguenze pratiche:"),
        (1, "mai cicli FOR lunghi o attese in HMI.pou"),
        (1, "mai chiamate di comunicazione bloccanti nei task veloci"),
        (1, "il mirror della coda HMI è limitato a 8 righe per questo"),
        (0, "Se il watchdog scatta la macchina va in errore: non 'rallenta'"),
    ], size=16,
       notes="Prima domanda da farsi quando si aggiunge codice: in quale task gira "
             "e quanto può durare.")

    S("Regola: ogni variabile ha un solo scrittore.",
      "Se serve un secondo scrittore, si passa da una struttura di comando con un "
      "unico punto di applicazione.",
      notes="È la convenzione che rende sicuro il multi-task senza lock.")

    # ---------------------------------------------------------------- 03
    d.section("03", "Hardware e fieldbus",
              "Come il software vede la macchina",
              topics=["EtherCAT", "Ethernet/IP", "SliceBus safety",
                      "Assi e gruppi", "File di configurazione"],
              notes="Da dove arrivano i dati e dove finiscono i comandi.")

    T("Nodi EtherCAT", ["Nodo", "Asse / funzione"], [
        ["SGDXS_Servopack 1-4", "S, L, U, T (Delta)"],
        ["SGDXS_Servopack 5", "B (rotazione polso, opzionale)"],
        ["SGDXS_Servopack 6", "FeedIn (CI)"],
        ["SGDXS_Servopack 7", "FeedOut (CO)"],
        ["Virtual Axis", "VIRTUAL_AXIS (test / master)"],
    ], size=12.5, col_widths=[4.0, 8.0],
       notes="Il codice tratta gli assi come AXIS_REF: aggiungere un asse non "
             "richiede di riscrivere la logica.")

    TW("Le due reti principali", "EtherCAT (motion)", [
        (0, "7 servopack Yaskawa SGDXS"),
        (0, "ciclo sincrono, riferimento per il motion"),
        (0, "sopra EtherCAT gira anche FSoE (safety)"),
        (0, "parametri drive via SDO (libParamSDO)"),
        (0, "diagnostica: DriveAlarmID, warning, STO"),
    ], "Ethernet/IP (visione)", [
        (0, "adattatore verso VISOR: RX 72 byte, TX 3 byte"),
        (0, "stato connessione in EIP_STATUS_REF"),
        (0, "parsing byte-per-byte con FC_BytesToReal"),
        (0, "non deterministico: da qui la necessità del latch"),
    ], size=14,
       notes="Due reti con filosofie diverse: una deterministica per il motion, "
             "una non deterministica per i dati di visione.")

    C("Il telegramma della telecamera (Main.pou)", """stInput.ResultData.Pos_X[0]    := FC_BytesToReal(RX[8],  RX[9],  RX[10], RX[11]) / 1000.0;
stInput.ResultData.Pos_Y[0]    := FC_BytesToReal(RX[24], RX[25], RX[26], RX[27]) / 1000.0;
stInput.ResultData.Angle_Rz[0] := FC_BytesToReal(RX[40], RX[41], RX[42], RX[43]) / 1000.0;
// ... fino a indice [3]
stInput.ResultData.Part_Count  := RX[56];""",
      caption="4 pezzi per foto: X[0..3], Y[24..39], Rz[40..55]. Unità = valore/1000 (mm e gradi).",
      notes="FC_BytesToReal è l'unico punto di conversione: attenzione "
            "all'endianness (LittleEndian sul controller).")

    B("SliceBus e sicurezza", [
        (0, "Moduli:"),
        (1, "DI_8xDC24V, DO_8xDC24V (ingressi/uscite standard)"),
        (1, "DI_4xDC24V Safety x2 (CH0/CH1), DO_4xDC24V Safety x2"),
        (0, "Segnali nel codice:"),
        (1, "safeEmergency_CH0/CH1, safeDeltaDoor_CH0/CH1, safeCameraDoor_CH0/CH1"),
        (1, "safePilzSTO_SL/_UB/_TInv/_Spare (STO per gruppi di assi)"),
        (1, "safeOutDeltaDoor / safeOutCameraDoor (guard lock)"),
        (0, "Filosofia:"),
        (1, "la safety è FSoE/hardware: il software standard legge solo l'esito"),
        (1, "il PLC standard non può escludere una catena di sicurezza"),
    ], size=16,
       notes="E_Stop nel PLC è un'informazione, non il dispositivo di protezione.")

    T("Assi e gruppi nel codice", ["Nome", "Tipo", "Uso"], [
        ["DELTA", "AXES_GROUP_REF", "gruppo cinematico 5 assi"],
        ["S/L/U/T/B_Axis", "AXIS_REF", "assi singoli del gruppo"],
        ["FeedIn_Axis / FeedOut_Axis", "AXIS_REF", "nastri (CI / CO)"],
        ["VIRTUAL_AXIS", "AXIS_REF", "asse virtuale per test"],
        ["DATA_Delta", "DT_Group", "comandi e stato del gruppo"],
        ["DATA_FeedInAxis / FeedOutAxis", "ST_AxisData", "comandi e stato nastri"],
    ], size=12.5, col_widths=[3.0, 3.0, 6.2],
       notes="Due famiglie di strutture: DT_Group per il gruppo, ST_AxisData per i "
             "singoli assi. Non sono intercambiabili.")

    T("File di configurazione", ["File", "Contenuto"], [
        ["structure.xml", "albero logico del progetto (POU e metodi)"],
        ["CFG_DAD2D28.dl", "DataList: variabili globali, flag OPC/RETAIN"],
        ["RES_...set", "task, programmi, watchdog"],
        ["ETHERCAT_Master.station", "configurazione master EtherCAT"],
        ["EIP_Master.station", "adattatore Ethernet/IP (telecamera)"],
        ["*.dt / *.var", "tipi e dichiarazioni variabili"],
    ], size=12.5, col_widths=[3.4, 8.6],
       notes="Per orientarsi: prima structure.xml, poi il .st specifico, poi il "
             ".var per i tipi.")

    # ---------------------------------------------------------------- 04
    d.section("04", "Organizzazione del software",
              "Come è suddiviso il progetto e perché",
              topics=["Alberatura", "Macro-aree", "PROGRAM sottili",
                      "Recycle Bin"],
              notes="Mappa mentale del repository.")

    C("Alberatura (Logical Elements)", """Logical Elements/
├── CHANGELOG.pou              storia e convenzioni di versione
├── Cyclic/                    programmi eseguiti ciclicamente
│   ├── Main.pou               entry point MediumTask
│   ├── PickPlaceManager.pou   core del ciclo (FastTask)
│   ├── VisionManager.pou      acquisizione e distribuzione pezzi
│   ├── HMI.pou                mappatura verso/da pannello
│   ├── IO.pou                 ingressi/uscite
│   ├── ErrorManager.pou       orchestratore errori
│   └── RebootAndReset.pou     riavvio e reset
├── Initialize/                Init, InitColdStart, InitWarmStart
├── Machine/                   FB_MachineController, FB_KPI, Axis/, Group/,
│                              Vision/, Error/, FB_PickPlace_Sequencer1
└── Utils/                     FB_ConveyorController, FC_BytesToReal, DEG_TO_RAD...""",
      size=10.5,
      notes="Cyclic = programmi, Machine = function block con stato, Utils = "
            "mattoni senza dipendenze dalla macchina.")

    T("Le quattro macro-aree", ["Area", "Natura", "Regola"], [
        ["Cyclic/", "PROGRAM", "orchestrano: leggono comandi, chiamano FB, scrivono uscite"],
        ["Machine/", "FUNCTION_BLOCK", "incapsulano stato; niente accesso diretto a IO"],
        ["Initialize/", "PROGRAM di startup", "un solo punto di scrittura dei default"],
        ["Utils/", "FB/FC generici", "riusabili, nessuna dipendenza dalla macchina"],
    ], size=13, col_widths=[2.2, 2.8, 7.0],
       notes="Se una modifica porta logica di macchina nei Utils, sta nascendo debito "
             "tecnico.")

    B("Perché i PROGRAM sono sottili", [
        (0, "Un PROGRAM contiene solo:"),
        (1, "mappatura dei comandi, chiamata dei FB, mappatura delle uscite"),
        (0, "Vantaggi:"),
        (1, "la logica sta nei FB, che sono testabili e riusabili"),
        (1, "si vede subito il flusso dati di un ciclo"),
        (1, "il debug si concentra su un blocco, non su 800 righe"),
        (0, "Eccezione dichiarata:"),
        (1, "HMI.pou è lungo e piatto: è tutta mappatura, un solo scrittore"),
    ], size=16,
       notes="PickPlaceManager ha ~165 righe: orchestrazione + rampa delegata a "
             "FB_ConveyorController.")

    B("Residui e Recycle Bin: cosa NON è codice attivo", [
        (0, "Nel Recycle Bin del progetto:"),
        (1, "FB_ErrorHandler_OLD, F_EnqueueError/F_EnqueueEvent, Auto_AXES"),
        (1, "una copia di Locally_Hosted_Group e un Generic_Adapter"),
        (0, "Perché conta:"),
        (1, "sono file che sembrano codice e non lo sono (non compilano)"),
        (1, "sono utili come storia dell'evoluzione"),
        (0, "Regola pratica:"),
        (1, "prima di modificare: verificare che il file sia in Logical Elements"),
    ], size=16,
       notes="structure.xml è l'albero reale; RecycleBin non partecipa al build.")

    # ---------------------------------------------------------------- 05
    d.section("05", "Dati, tipi e interfaccia OPC UA",
              "Le strutture che tengono insieme tutto",
              topics=["File dei tipi", "ST_HMI_Interface", "DT_Machine",
                      "DataList e flag OPC", "RETAIN", "Enumerativi"],
              notes="Qui si capisce perché alcune variabili si vedono dall'HMI e "
                    "altre no.")

    T("Dove sono definiti i tipi", ["File", "Contenuto"], [
        ["~DT_HMI~0000.dt", "ST_HMI_Interface e tutte le strutture HMI"],
        ["~DT_Machine~0000.dt", "DT_Machine + E_MachineState"],
        ["~DT_Group~0000.dt", "DT_Group: comandi e stato del gruppo Delta"],
        ["~DT_Axi~0000.dt", "ST_AxisData (Command/Setting/Status/Feedback/Error)"],
        ["~DataTypes~0000.dt", "E_PickPlace_State, E_PickPlaceMode, E_StepStatus"],
        ["~DT_KPI_Dat~0000.dt", "ST_KPI_Data"],
        ["~DT_Yaskawa~0000.dt", "tipi e codici della libreria"],
    ], size=12.5, col_widths=[3.4, 8.6],
       notes="13 file .dt nel progetto, gli altri sono di libreria.")

    C("ST_HMI_Interface — la radice dell'interfaccia", """ST_HMI_Interface : STRUCT
    Dashboard  : ST_HMI_Dashboard;   // comandi, status, versioni, IO
    Robot      : ST_Robot;           // command / setting / status / feedback
    Axis       : ST_Axes;            // FeedIn / FeedOut / Virtual
    TeachFrame : ST_HMI_Frames;      // dati di teach
    Process    : ST_HMI_Process;     // setting + status di processo
    Vision     : ST_HMI_Vision;      // command / status / ultimo prodotto
    Tracking   : ST_HMI_Tracking;    // mirror coda pezzi
END_STRUCT""",
      caption="Tutto ciò che il pannello legge o scrive passa da qui: un solo albero, un solo nodo OPC.",
      notes="Vantaggio: sottoalberi coerenti. Svantaggio: essendo RETAIN, ogni "
            "campo pesa sulla memoria ritentiva.")

    TW("Comando vs Stato", "Command (HMI → PLC)", [
        (0, "scritti dal pannello, validati dal PLC:"),
        (1, "PowerUp, StartCycle, StopCycle, AutomaticMode"),
        (1, "JogJoint/JogLinear, MoveAbsolute/Relative, ResetErrors"),
        (0, "Il PLC li valida:"),
        (1, "posizionamento solo in MANUAL"),
        (1, "jog solo con Safety_Button premuto"),
    ], "Status / Feedback (PLC → HMI)", [
        (0, "scritti dal PLC, sola lettura per il pannello:"),
        (1, "IsRunning, IsAutoMode, AllMotorsServoOn"),
        (1, "CurrentSpeed, CycleTime, ProductsPerMin"),
        (1, "state, error, ErrorID di assi e gruppo"),
        (0, "Regola:"),
        (1, "il pannello non scrive mai un Feedback"),
    ], size=13,
       notes="Evita l'ambiguità 'chi ha scritto per ultimo': i Command sono "
             "ingressi, i Feedback uscite.")

    B("Setting vs Command", [
        (0, "Setting = parametri, non azioni:"),
        (1, "CommandVelocity/Acceleration/Deceleration, CommandPosition, HomingPosition"),
        (1, "copiati ad ogni ciclo nelle strutture dei drive"),
        (0, "Command = eventi:"),
        (1, "MoveAbsolute, MoveRelative, StartCycle, JogFWD (hanno un fronte)"),
        (0, "Perché è importante:"),
        (1, "un Setting può cambiare in qualsiasi momento senza effetti collaterali"),
        (1, "un Command scritto a livello alto resta attivo finché non lo si resetta"),
        (0, "Trappola nota:"),
        (1, "un comando HMI che resta TRUE viene riapplicato ad ogni ciclo"),
    ], size=16,
       notes="Esempio: EmergencyStop è un livello, MoveRelative è un fronte.")

    C("DT_Machine — parametri di macchina", """_Setting : STRUCT
    MinVelocity_Delta : LREAL;      // 1500  velocita' minima assi
    MinRamp_Delta     : LREAL;      // 10000 rampa minima
    ZPickPlaceSpeed   : LREAL;
    Delta_Z_Pick      : LREAL;      // 55 mm
    Delta_Z_Place     : LREAL;      // 35 mm
    OffsetCamera      : LREAL;      // 750 mm  camera -> punto di presa
    LimitPos          : Array_XY_range;
    TrackingWindowStart : LREAL;    // 300 mm (inizio fascia di prelievo)
    TrackingWindowEnd   : LREAL;    // 450 mm (nastro fermo)
END_STRUCT""",
      caption="Qui vivono i numeri del processo. Il tipo dichiara, Init.pou assegna.",
      notes="Se un parametro non è in Init, il suo valore è 'quello che capita'.")

    T("Flag del DataList", ["Variabile", "OPC", "RETAIN", "Note"], [
        ["HMI_Data", "**Sì**", "**Sì**", "canale unico pannello"],
        ["KPI_Data", "**Sì**", "**Sì**", "metriche di turno"],
        ["G_xCycleActive / G_bAutoCycleRunning", "**Sì**", "No", "stato di ciclo"],
        ["G_xKPI_ResetShift", "**Sì**", "No", "reset turno"],
        ["MultiGrpProductData", "No", "No", "coda pezzi (150 posti)"],
        ["MonitorStatusData", "No", "No", "distanze dei prodotti in coda"],
        ["DATA_* (drive e gruppo)", "No", "No", "accesso diretto non necessario"],
    ], size=12, col_widths=[4.2, 1.2, 1.4, 5.2],
       notes="Questa tabella spiega perché è servito HMI_Data.Tracking: la coda non "
             "è leggibile dall'HMI se non la si copia.")

    B("RETAIN: cosa significa in pratica", [
        (0, "HMI_Data è RETAIN nel DataList:"),
        (1, "sopravvive a warm start e power cycle"),
        (1, "serve per non perdere impostazioni e contatori"),
        (0, "Conseguenze:"),
        (1, "ogni campo aggiunto consuma memoria ritentiva: tenerla piccola"),
        (1, "i valori 'vivi' vanno riscritti ogni ciclo, altrimenti restano vecchi"),
        (1, "un campo RETAIN mai scritto mostra il valore del ciclo precedente"),
        (0, "Esempio:"),
        (1, "la coda HMI è limitata a 8 righe proprio per non gonfiare l'area ritentiva"),
    ], size=16,
       notes="Domanda tipica: 'perché a macchina spenta vedo ancora i pezzi in "
             "coda?'. Risposta: RETAIN; si azzera in Init o con un comando.")

    T("Enumerativi principali", ["Tipo", "Valori", "Uso"], [
        ["E_MachineState", "INIT, IDLE, TEACH_FRAME, POWERING_UP, HOMING, WAIT_FOR_COMMISSIONING, OPERATIONAL_AUTOMATIC, OPERATIONAL_MANUAL, STOPPING, UNPOWERING, SHUTDOWN, ERROR", "stato macchina"],
        ["E_PickPlace_State", "Initialize, CheckPickLimits, ... CycleCompletition (=100..3200)", "step del sequencer"],
        ["E_StepStatus", "BUSY, DONE, ERROR, ACTIVE", "esito di uno step"],
        ["E_ErrorSeverity", "None, Info, Warning, MinorError, MajorError", "gravità errori"],
        ["E_PickPlace_OperationalMode", "Normal, FixedPick, FixedPlace, TrackingBoth", "modo operativo"],
    ], size=11, col_widths=[3.0, 6.6, 2.6],
       notes="Gli stati del sequencer vanno di 50 in 50 per poter inserire nuovi "
             "step senza rinumerare.")

    S("I numeri distanziati negli enum sono spazio per crescere, non pigrizia.",
      "E_PickPlace_State avanza di 50 in 50 proprio per inserire step intermedi "
      "senza toccare quelli esistenti.",
      notes="Piccolo esempio di manutenibilità nascosta nel codice.")

    # ---------------------------------------------------------------- 06
    d.section("06", "La macchina a stati",
              "FB_MachineController: il supervisore di tutto",
              topics=["Pattern NextState + bTransition", "Diagramma degli stati",
                      "Gli 11 handler", "Priorità delle transizioni"],
              notes="Chi tocca qui tocca la sicurezza funzionale della logica.")

    B("Il pattern fondamentale", [
        (0, "State_MachineController è lo stato corrente (E_MachineState)"),
        (0, "Ogni handler fa due cose:"),
        (1, "esegue le azioni dello stato"),
        (1, "se deve cambiare stato assegna NextState e mette bTransition := TRUE"),
        (0, "In fondo a STATE_MACHINE.st:"),
        (1, "IF bTransition THEN State := NextState; bTransition := FALSE; END_IF"),
        (0, "Perché è un buon pattern:"),
        (1, "le azioni dello stato finiscono prima della transizione"),
        (1, "nessun handler può saltare uno stato scrivendolo direttamente"),
        (1, "la precedenza delle transizioni si legge nell'IF/ELSIF"),
    ], size=16,
       notes="Domanda tipica: 'perché non cambio direttamente lo stato?'. Perché si "
             "perde l'ordine e si rompono i RETURN degli handler.")

    C("L'ossatura del FB (STATE_MACHINE.st)", """IF State_MachineController = E_MachineState#INIT THEN
    State_MachineController := E_MachineState#IDLE;
    DATA_Delta.Command.GroupControl.Enable := FALSE;  ...
END_IF

IF HmiFramesData.StartTeach AND (State = IDLE OR State = OPERATIONAL_MANUAL) THEN
    State_MachineController := E_MachineState#TEACH_FRAME;
END_IF

// AUTOCYCLE: fuori dall'automatico il latch del ciclo e' azzerato
IF State_MachineController <> E_MachineState#OPERATIONAL_AUTOMATIC THEN
    G_bAutoCycleRunning := FALSE;
END_IF

CASE State_MachineController OF
    E_MachineState#IDLE:        THIS.HandleIdleState();
    E_MachineState#POWERING_UP: THIS.HandlePowerUpState();
    ...
END_CASE

IF bTransition THEN
    State_MachineController := NextState;
    bTransition := FALSE;
END_IF""", size=10.5,
      notes="Due eccezioni al pattern: uscita da INIT e ingresso in TEACH_FRAME "
            "usano assegnazione diretta (sono transizioni di inizializzazione).")

    T("Gli stati e i loro handler", ["Stato", "Handler", "Scopo"], [
        ["INIT", "(inline)", "ripristino uscite e passaggio a IDLE"],
        ["IDLE", "HandleIdleState", "attesa comandi, lampade spente, gripper chiusi"],
        ["TEACH_FRAME", "HandleTeachFrameState", "calibrazione 3 punti dei frame"],
        ["POWERING_UP", "HandlePowerUpState", "enable di assi e gruppo, reset allarmi"],
        ["HOMING", "HandleHomingState", "homing e verifica servo"],
        ["WAIT_FOR_COMMISSIONING", "HandleCommissioningState", "posizionamento manuale iniziale"],
        ["OPERATIONAL_AUTOMATIC", "HandleAutomaticState", "ciclo, visione, nastri"],
        ["OPERATIONAL_MANUAL", "HandleManualState", "jog e posizionamento da pannello"],
        ["STOPPING", "HandleStoppingState", "arresto controllato (group stop)"],
        ["UNPOWERING", "HandleUnpoweringState", "toglie alimentazione con timeout"],
        ["SHUTDOWN", "HandleShutdownState", "stato finale, rientro a INIT"],
        ["ERROR", "HandleErrorState", "diagnosi, reset, stop sicuro"],
    ], size=11, col_widths=[3.0, 3.6, 5.4],
       notes="Il diagramma in ASCII completo è nel commento di FB_Instances.st.")

    C("Diagramma degli stati", """                    +--------+   PowerUp   +--------------+
                    |  IDLE  |------------>| POWERING_UP  |
                    +--------+             +--------------+
                       |  ^                     |      |
              (Stop)   |  | (Shutdown)          |      | (Fail)
                       v  |                     v      v
                 +-----------+             +--------+  |
                 | UNPOWERING|             | HOMING |<-+
                 +-----------+             +--------+
                       ^                       |
                  +---------+    +-------------+------------+
                  |STOPPING |<---|  AUTOMATIC  |  MANUAL    | COMMISSIONING
                  +---------+    +-------------+------------+""", size=10,
      notes="Ridisegnato per la slide: l'originale in ASCII è nel codice. Da "
            "qualsiasi stato con servo in errore si va in ERROR.")

    B("HandleIdleState — pronta ma ferma", [
        (0, "Azioni:"),
        (1, "spegne LampIn/LampOut e chiude entrambe le valvole gripper"),
        (0, "Transizioni:"),
        (1, "PowerUp AND (auto OR (Safety_Button + manuale)) AND NOT E_Stop → POWERING_UP"),
        (1, "StartTeach → TEACH_FRAME"),
        (0, "Dettagli:"),
        (1, "PowerUp viene consumato (:= FALSE) per non ri-attivarlo al ciclo dopo"),
        (1, "E_Stop impedisce la transizione: non si alimenta con emergenza attiva"),
        (1, "LogEvent Info 'Ready to POWER UP' per tracciabilità"),
    ], size=16,
       notes="Il latch G_bAutoCycleRunning è forzato a FALSE: si entra in "
             "automatico sempre a ciclo fermo.")

    B("HandlePowerUpState — dare potenza in sicurezza", [
        (0, "Azioni:"),
        (1, "Enable/En_Group/En_Power sul gruppo, Enable su FeedIn, FeedOut, Virtual"),
        (1, "fbPowerUpTimer 5 s come watchdog di sequenza"),
        (0, "Verifica:"),
        (1, "bServosNotReady = almeno un servo non in SVON"),
        (1, "se non pronti: AlarmClear e ResetFault su gruppo e nastri"),
        (0, "Transizioni:"),
        (1, "servo pronti + GroupStatus + PowerStatus → HOMING o operativo"),
        (1, "timeout 5 s → ERROR"),
        (0, "Nota:"),
        (1, "il reset allarmi al power-up non è un bypass: se il guasto persiste torna"),
    ], size=16,
       notes="Il timeout evita che la macchina resti in uno stato indefinito se un "
             "servo non si abilita.")

    B("HandleHomingState — referenziare gli assi", [
        (0, "Azioni:"),
        (1, "mantiene PowerStatus ed Enable su tutti gli assi"),
        (1, "verifica continua dello stato servo (bServoError_Homing)"),
        (0, "Transizioni:"),
        (1, "servo in errore → ERROR con RETURN immediato"),
        (1, "homing concluso → AUTOMATIC o MANUAL secondo bAutoModeSelected"),
        (0, "Osservazioni:"),
        (1, "l'homing vero è delegato ai FB di asse (MC_Home) via FB_AxisController"),
        (1, "qui c'è la supervisione, non la sequenza di motion"),
        (1, "molti controlli per-asse sono commentati: vale la verifica aggregata"),
    ], size=16,
       notes="La verifica aggregata è più corta ma dà un errore meno specifico "
             "('un servo non è ON').")

    B("HandleCommissioningState — messa in posizione", [
        (0, "Quando:"),
        (1, "dopo l'homing, se Commissioning = TRUE (prima messa in servizio)"),
        (0, "Cosa fa:"),
        (1, "GroupIsHomed := FALSE (posizione non ancora valida)"),
        (1, "verifica servo come gli altri handler"),
        (1, "attende l'impostazione della posizione (GroupSetPosition)"),
        (0, "Transizioni:"),
        (1, "posizione confermata → AUTO o MANUAL"),
        (0, "Perché è separato da HOMING:"),
        (1, "rifare il riferimento senza rifare l'homing completo dei drive"),
    ], size=16,
       notes="Homing = encoder del drive; commissioning = riferimento meccanico del "
             "gruppo nella cella.")

    B("HandleAutomaticState — il cuore produttivo", [
        (0, "Start/Stop ciclo sui fronti:"),
        (1, "rtStartCycleBtn → G_bAutoCycleRunning := TRUE"),
        (1, "rtStopCycleBtn → G_bAutoCycleRunning := FALSE"),
        (0, "Azioni cicliche:"),
        (1, "DATA_FeedInAxis.Command.JogPos := G_bAutoCycleRunning (i nastri girano col ciclo)"),
        (1, "LampIn/LampOut TRUE, xVision_StartCycle := G_bAutoCycleRunning"),
        (1, "StartPickPlace_Delta := TRUE (non si resetta a metà ciclo)"),
        (0, "Sicurezza:"),
        (1, "servo non ON → ERROR; E_Stop o PowerDown → STOPPING"),
        (1, "errore sequencer o MajorError → STOPPING"),
        (1, "nessun modo selezionato → STOPPING"),
    ], size=15,
       notes="Qui si vede che i nastri in automatico sono comandati in JOG: è il "
             "motivo per cui si fermano con JogDec (sezione 15).")

    B("HandleManualState — jog e posizionamento", [
        (0, "Condizioni calcolate una volta:"),
        (1, "xMotionAxesEnableCondition = NOT StartCycle AND bManualModeSelected"),
        (1, "xJogJoint/xJogLinearEnableCondition, MovementAllowed := Safety_Button"),
        (0, "Assi:"),
        (1, "jog avanti/indietro mutuamente esclusivi (IF/ELSIF esplicito)"),
        (1, "posizionamento assoluto o incrementale solo in manuale"),
        (0, "Robot:"),
        (1, "jog giunti, jog lineare, move assoluto in ACS o MCS"),
        (0, "Uscite:"),
        (1, "Safety_Button rilasciato o PowerDown → STOPPING con azzeramento comandi"),
    ], size=15,
       notes="Il pattern 'se non abilitato, forza a FALSE la condizione' è ripetuto: "
             "i FB di motion leggono i consensi, non solo il comando.")

    B("HandleStoppingState — arresto controllato", [
        (0, "Azioni:"),
        (1, "verifica servo: errore → ERROR"),
        (1, "DATA_Delta.Command.En_EmergencyGroupStop := TRUE"),
        (1, "toglie jog e posizionamento sugli assi"),
        (0, "Perché non si taglia la potenza:"),
        (1, "un taglio secco su un robot in movimento è pericoloso e violento"),
        (1, "il group stop usa la rampa di decelerazione configurata"),
        (0, "Transizioni:"),
        (1, "arresto completato → UNPOWERING"),
        (0, "Differenza con ERROR:"),
        (1, "ERROR = guasti; STOPPING = richieste di fermata"),
    ], size=16,
       notes="STOPPING è la rampa, UNPOWERING il distacco: separati per distinguere "
             "'fermo' da 'senza coppia'.")

    B("HandleUnpoweringState / HandleShutdownState", [
        (0, "UNPOWERING:"),
        (1, "En_Power := FALSE sul gruppo, Enable := FALSE sui tre assi"),
        (1, "fbUnpowerTimer 10 s, poi SHUTDOWN anche se un drive non rilascia"),
        (0, "SHUTDOWN:"),
        (1, "disabilita gruppo e azzera En_EmergencyGroupStop"),
        (1, "azzera i comandi EmergencyStop dei tre assi"),
        (1, "GroupStatus FALSE → INIT (timeout 5 s come fallback)"),
        (0, "Perché si torna a INIT e non a IDLE:"),
        (1, "INIT rifà il reset di tutte le uscite di default"),
        (0, "Ciclo completo:"),
        (1, "IDLE → POWERING_UP → HOMING → operativo → STOPPING → UNPOWERING → SHUTDOWN → INIT"),
    ], size=15,
       notes="Ogni attesa ha un timeout e un log: nessuno stato può bloccarsi in "
             "silenzio.")

    B("HandleErrorState — diagnosi e recupero", [
        (0, "Azioni immediate:"),
        (1, "StartPickPlace_Delta := FALSE, xVision_StartCycle := FALSE"),
        (1, "io.bSystemReady := FALSE, azzera i comandi di jog/movimento"),
        (0, "Stop sicuro:"),
        (1, "bStopToUnpower = errore servo OR gruppo non in movimento"),
        (1, "se TRUE: toglie En_Power"),
        (1, "se il gruppo si muove e i servo sono OK: STOPPING → UNPOWERING"),
        (0, "Recupero:"),
        (1, "G_bResetAllErrors → rientro verso INIT/IDLE"),
        (0, "Lezione:"),
        (1, "l'errore non spegne mai 'a caldo' un robot in movimento"),
    ], size=15,
       notes="È il punto in cui il progetto è più maturo: la sicurezza meccanica "
             "viene prima della reattività dell'errore.")

    B("HandleTeachFrameState — calibrazione 3 punti", [
        (0, "Procedura:"),
        (1, "l'operatore porta il TCP su OO, XX, XY e conferma ogni punto"),
        (1, "rtConfirmPoint(CLK := ConfirmPoint) cattura il fronte"),
        (1, "a sequenza completa si esegue il calcolo (FrameTypeTransform)"),
        (0, "Due modalità:"),
        (1, "servo ON → teach con jog"),
        (1, "servo OFF → trascinamento manuale (free-drag)"),
        (0, "Perché è importante:"),
        (1, "tutti gli offset FeedIn/FeedOut derivano da questi frame"),
        (1, "un frame sbagliato si manifesta come errore di posizione sistematico"),
    ], size=16,
       notes="Prima cosa da verificare quando 'il robot prende sempre spostato': i "
             "frame, non il tracking.")

    T("Priorità delle transizioni in AUTOMATICO", ["Condizione", "Destinazione", "Perché"], [
        ["E_Stop OR PowerDown", "STOPPING", "sicurezza, massima priorità"],
        ["errore sequencer / MajorError", "STOPPING", "non si prosegue con guasti attivi"],
        ["manuale selezionato + safety", "OPERATIONAL_MANUAL", "cambio modo richiesto"],
        ["nessun modo selezionato", "STOPPING", "arresto di sicurezza"],
        ["servo non ON", "ERROR", "condizione anomala"],
    ], size=12, col_widths=[4.2, 3.2, 4.8],
       notes="L'ordine degli ELSIF è la priorità: se E_Stop ed errore arrivano "
             "insieme, vince E_Stop. È una scelta, non un caso.")

    S("Ogni attesa ha un timeout, ogni transizione un log.",
      "PowerUp 5 s, Unpower 10 s, Shutdown 5 s, visione 10 s, KPI 1 s / 1 min.",
      notes="È la firma stilistica del progetto.")

    # ---------------------------------------------------------------- 07
    d.section("07", "Assi e gruppo cinematico",
              "FB_AxisController, FB_GroupController e la libreria di motion",
              topics=["Mapping dati → FB", "MC_* usati", "Blend a 4 blocchi",
                      "Tracking", "Diagnostica"],
              notes="Come i dati delle strutture diventano chiamate MC_*.")

    C("FB_AxisController: la catena di mapping", """FB_AxisController(AXI := FeedIn_Axis, DATA_AXI := DATA_FeedInAxis)
   ├── MAPPING_In.st     Command/Setting      -> CMD_*, VAR_*
   ├── MOTION.st         MC_Power, MC_Jog, MC_MoveRelative,
   │                     MC_MoveAbsolute, MC_TouchProbe ...
   ├── MAPPING_Out.st    STS_*                 -> Status/Feedback
   ├── READINGS.st       letture diagnostiche
   └── WRITE_Parameters  parametri drive via SDO""",
      caption="Un solo schema per tutti gli assi: FeedIn, FeedOut, Virtual.",
      notes="Aggiungere un asse significa istanziare lo stesso FB, non riscrivere la "
            "logica di motion.")

    T("Mapping in ingresso (MAPPING_In.st)", ["CMD_ / VAR_", "Sorgente"], [
        ["CMD_Enable", "DATA_AXI.Command.Enable"],
        ["CMD_JogFor / CMD_JogRev", "Command.JogPos / JogNeg"],
        ["CMD_AbsPos / CMD_IncPos", "Command.AbsPositioning / IncPositioning"],
        ["CMD_Stop", "Command.EmergencyStop"],
        ["CMD_TouchProbe", "Command.TouchProbe"],
        ["VAR_JogSpeed / JogAcc / JogDec", "Setting.JogSpeed / JogAcc / JogDec"],
        ["VAR_PosSpeed / PosAcc / PosDec", "Setting.PositioningSpeed / Acc / Dec"],
        ["VAR_TriggerInput", "Setting.TouchProbeTriggerInput"],
    ], size=12, col_widths=[4.4, 7.6],
       notes="Mapping 1:1 senza logica: la logica sta nei programmi che scrivono "
             "DATA_AXI. È ciò che rende il driver riusabile.")

    C("MOTION.st — i FB PLCopen chiamati", """Y_MotionAxisDriver1(Axis := AXI, Enable := TRUE)
AxisControl_1(...)                     // power + stato + allarmi
MC_Reset1(Axis := AXI, Execute := CMD_ResetFault)
Jog_1(... Velocity := VAR_JogSpeed, Acceleration := VAR_JogAcc,
         Deceleration := VAR_JogDec, Jerk := 0)
MC_MoveRelative_1(... BufferMode := VAR_IncPosBufferMode)
MC_MoveAbsolute_1(... Direction := VAR_AbsPosDirection)
MC_TouchProbe_1(... RecordedPosition => VAR_TouchProbeRecPos)""",
      caption="Jerk = 0 su tutti i blocchi: il drive non lo supporta.",
      notes="Il touch probe è la base del latch: la posizione del nastro allo "
            "scatto viene catturata dall'hardware del drive.")

    B("Jog vs Posizionamento", [
        (0, "Jog (MC_Jog):"),
        (1, "velocità continua finché il comando è alto"),
        (1, "al rilascio il drive decelera con la Deceleration del blocco"),
        (1, "è il meccanismo con cui girano i nastri in automatico"),
        (0, "Posizionamento (MC_MoveRelative/Absolute):"),
        (1, "raggiunge una quota e si ferma"),
        (1, "usato in manuale per movimenti puntuali"),
        (0, "Conseguenza importantissima:"),
        (1, "in automatico i nastri sono in JOG → velocità = JogSpeed"),
        (1, "la decelerazione di arresto è JogDec, non PositioningDec"),
    ], size=16,
       notes="È la chiave per capire lo stop ciclo: i nastri non stanno "
             "'posizionando'.")

    C("Il comando di velocità del FeedIn (HMI.pou)", """DATA_FeedInAxis.Setting.JogSpeed := MIN(HMI_Data.Axis.FeedIn.Setting.CommandVelocity,
                                   FeedIn_SmoothSpeed);
DATA_FeedInAxis.Setting.JogAcc   := MIN(HMI_Data.Axis.FeedIn.Setting.CommandAcceleration,
                                   FeedIn_SmoothAcceleration);
DATA_FeedInAxis.Setting.JogDec   := HMI_Data.Axis.FeedIn.Setting.CommandDeceleration;""",
      caption="Il MIN permette al controllo di rallentare il nastro senza riscrivere il setting utente (la terza riga NON ha MIN, vedi sezione 15).",
      notes="La storia della terza riga è il caso di studio 1.")

    B("FB_GroupController e il sequencer", [
        (0, "Divisione:"),
        (1, "FB_GroupController = 'muscoli': FB di gruppo e tracking"),
        (1, "FB_PickPlace_Sequencer1 = 'cervello': cosa fare e quando"),
        (0, "Dentro FB_GroupController:"),
        (1, "GroupReadStatus, GroupJogJoint/Linear"),
        (1, "MoveLinearAbsolute (4 istanze Blend) e MoveLinearRelative"),
        (1, "MC_TrackConveyorBelt x2 (FeedIn e FeedOut)"),
        (1, "GroupStop, GroupSetPosition, SetFrameOffset, FrameTypeTransform"),
        (0, "Perché separarli:"),
        (1, "il sequencer non conosce assi né bus, solo 'muoviti qui'"),
    ], size=15,
       notes="Il sequencer entra nel motion solo tramite M_Driver_Motion_Cmd: una "
             "sola porta.")

    B("Blend ring buffer: perché 4 blocchi", [
        (0, "Problema:"),
        (1, "un ciclo è una catena di movimenti; fermarsi fra l'uno e l'altro costa tempo"),
        (1, "BlendingPrevious permette di fondere i tratti"),
        (0, "Soluzione:"),
        (1, "4 istanze Blend1..Blend4 usate a rotazione"),
        (1, "M_Driver_InitPointers parte da Blend4: il primo comando va su Blend1"),
        (1, "M_Driver_Motion_Cmd avanza circolarmente (CASE eCurrentMoveID)"),
        (0, "Perché 4:"),
        (1, "margine per sequenze con più tratti consecutivi senza 'buchi' di comando"),
    ], size=16,
       notes="Metafora: un cambio a 4 marce che passa sempre alla successiva, senza "
             "mai scalare.")

    C("Il ciclo dei blocchi (M_Driver_Motion_Cmd)", """IF bExecute THEN
    IF bIsFirstMove THEN
        eCurrentMoveID := E_MotionChannel#Blend1;
        bIsFirstMove := FALSE;  bHasPreviousMove := FALSE;
    ELSE
        ePreviousMoveID := eCurrentMoveID;  bHasPreviousMove := TRUE;
        CASE eCurrentMoveID OF
            E_MotionChannel#Blend1: eCurrentMoveID := E_MotionChannel#Blend2;
            E_MotionChannel#Blend2: eCurrentMoveID := E_MotionChannel#Blend3;
            E_MotionChannel#Blend3: eCurrentMoveID := E_MotionChannel#Blend4;
            E_MotionChannel#Blend4: eCurrentMoveID := E_MotionChannel#Blend1;
        END_CASE
    END_IF
END_IF""", size=11,
      notes="bIsFirstMove distingue il primo movimento del ciclo, che non deve "
            "essere blended, dai successivi.")

    T("MC_TrackConveyorBelt: i parametri che contano", ["Parametro", "Significato", "Valore"], [
        ["ConveyorBelt", "asse nastro inseguito", "FeedIn_Axis"],
        ["RecordedPosition", "posizione nastro allo scatto", "latch + OffsetCamera"],
        ["ConveyorBeltOrigin", "frame del nastro in MCS", "FeedIn_FrameOffset"],
        ["InitialObjectPosition", "posizione pezzo nel frame nastro", "vision − frame offset"],
        ["StartDistance", "spazio minimo per il sync", "10 mm"],
        ["EndDistance", "fine finestra di tracking", "500 mm (FeedIn), 200 (FeedOut)"],
        ["SyncIn Conveyor/TCP", "corsa durante il sync", "10 / 5 mm"],
        ["SyncOut ConveyorDistance", "corsa in uscita dal sync", "15 mm"],
    ], size=11.5, col_widths=[3.8, 4.2, 4.2],
       notes="La sezione 09 entra nel dettaglio della legge che rispetta questa "
             "finestra.")

    B("Diagnostica di asse: cosa guardare", [
        (0, "Stato:"),
        (1, "Status.Enabled / ServoOn / Homed / StandStill / Moving"),
        (1, "Status.Errors + Feedback.DriveAlarmID"),
        (0, "Movimento:"),
        (1, "ActualPosition / CommandPosition (scostamento = errore di inseguimento)"),
        (1, "ActualSpeed / CommandSpeed, Feedback.FollErr"),
        (0, "Eventi:"),
        (1, "Error.TouchProbe_Err, Status.TouchProbeDone"),
        (0, "Ordine di diagnosi:"),
        (1, "ServoOn → Homed → Error → AlarmID → posizione/velocità"),
    ], size=16,
       notes="Non partire dal codice: parti dallo stato dell'asse. Nove volte su "
             "dieci è 'servo non ON' o 'non homed'.")

    # ---------------------------------------------------------------- 08
    d.section("08", "Il sequencer Pick & Place",
              "FB_PickPlace_Sequencer1: playlist, dispatcher, driver, 43 metodi",
              topics=["Playlist", "Motore", "Dispatcher", "Driver motion",
                      "I 24 step", "Parking, abort e reset"],
              notes="La sezione più lunga: è il motore del ciclo produttivo.")

    S("Il sequencer non è un CASE monolitico: è una playlist eseguita da un dispatcher.",
      "Sequenza = array di stati. Ogni stato = un metodo. Il motore decide solo "
      "quando avanzare.",
      notes="Permette di ricomporre la sequenza (pick&place, parking, abort) senza "
            "toccare la logica degli step.")

    C("M_ConfigSequence_Run — la playlist", """(*  0 *) AddStep(Initialize);
(*  1 *) AddStep(CheckPickLimits);
(*  2 *) AddStep(CalculatePickGripperOffset);
(*  3 *) AddStep(SetPickFrame_Tracking);
(*  4 *) AddStep(ConvertPickToCartesian_Tracking);
(*  5 *) AddStep(SetPickOffsetAndPCS_Tracking);
(*  6 *) AddStep(EnablePickTracking);
(*  7 *) AddStep(ApproachPick_Tracking);
(*  8 *) AddStep(WaitForPickSync);
(*  9 *) AddStep(DescendAndPick);
(* 10 *) AddStep(AscendAfterPick);
(* 11 *) AddStep(MoveToParking_AfterPick);
(* 12 *) AddStep(SelectNextProduct_Pick);
// ---- PLACE ----
(* 13 *) AddStep(InitializePlace);   ...   (* 23 *) AddStep(CycleCompletitionAndChangeMode);""",
      caption="24 step: pick 0-12, place 13-23. StartMovePath è commentato.",
      notes="bPlacePhaseActive e bStopAbortActive vengono azzerati qui a ogni ciclo.")

    B("Perché una playlist e non un CASE", [
        (0, "Vantaggi:"),
        (1, "la sequenza è un dato: si può ricomporre a runtime"),
        (1, "parking e abort sono altre playlist"),
        (1, "ogni step è un metodo isolato, leggibile e testabile da solo"),
        (1, "i salti avvengono per nome stato, non per numero"),
        (0, "Costi:"),
        (1, "un livello di indirezione in più in debug"),
        (1, "lo stato è distribuito fra iCurrentStepIndex e le variabili degli step"),
        (0, "Il patto implicito:"),
        (1, "ogni step torna BUSY/DONE/ERROR/ACTIVE e non fa transizioni da solo"),
    ], size=16,
       notes="Aggiungere uno step richiede: metodo + AddStep in playlist + ramo nel "
             "dispatcher. Tre punti.")

    C("Il motore del sequencer", """IF PickPlace_Status AND NOT PickPlace_Error THEN
    // --- SOFT ABORT su Stop Cycle ---
    IF StopCycleEnabled AND NOT bPlacePhaseActive AND NOT bStopAbortActive
       AND (SequenceList[iCurrentStepIndex] <> Initialize) THEN
        bActivateGripper1 := FALSE; bActivateGripper2 := FALSE;
        TrackConveyorBelt_FeedIn.Execute := FALSE; TrackConveyorBelt_FeedOut.Execute := FALSE;
        THIS.M_ConfigSequence_AbortToParking();
        iCurrentStepIndex := 0; bStepInitialized := FALSE; bStopAbortActive := TRUE;
    END_IF

    IF iCurrentStepIndex < iTotalSteps THEN
        eCurrentStepName := SequenceList[iCurrentStepIndex];
        eStepResult := THIS.M_Dispatcher(eCurrentStepName);
        CASE eStepResult OF
            E_StepStatus#BUSY: ;        // aspetta
            E_StepStatus#DONE:  bStepInitialized := FALSE;
                IF eRequestedJumpState <> Unknown THEN
                    iCurrentStepIndex := THIS.M_Helper_FindStepIndex(eRequestedJumpState);
                    eRequestedJumpState := Unknown;
                ELSE iCurrentStepIndex := iCurrentStepIndex + 1;
                END_IF
            E_StepStatus#ERROR: PickPlace_Error := TRUE;
        END_CASE
    END_IF
END_IF""", size=9.5,
      notes="Il contratto degli step: BUSY non fa nulla, DONE avanza, ERROR ferma. "
            "Il salto è opzionale via eRequestedJumpState.")

    B("Il motore: stati e flag", [
        (0, "PickPlace_Status:"),
        (1, "TRUE = sequencer in esecuzione"),
        (0, "PickPlace_Error:"),
        (1, "uno step ha risposto ERROR: blocca fino al reset"),
        (0, "iCurrentStepIndex / iTotalSteps:"),
        (1, "posizione e lunghezza della playlist corrente"),
        (0, "bStepInitialized:"),
        (1, "false = entry action non ancora eseguita; il motore lo azzera ad ogni DONE"),
        (0, "eRequestedJumpState:"),
        (1, "permette a uno step di chiedere un salto (double pick)"),
        (0, "bPlacePhaseActive / bStopAbortActive:"),
        (1, "soft abort solo in fase pick e una volta per ciclo"),
    ], size=15,
       notes="Questi cinque flag spiegano il 90% dei comportamenti 'strani' in debug.")

    C("M_Dispatcher — il ponte fra playlist e metodi", """CASE eState OF
    E_PickPlace_State#Initialize:                 res := THIS.M_Step_Initialize();
    E_PickPlace_State#CheckPickLimits:            res := THIS.M_Step_CheckPickLimits();
    E_PickPlace_State#CalculatePickGripperOffset: res := THIS.M_Step_CalcPickOffset();
    E_PickPlace_State#SetPickFrame_Tracking:      res := THIS.M_Step_SetPickFrame_Tracking();
    E_PickPlace_State#EnablePickTracking:         res := THIS.M_Step_EnablePickTracking();
    E_PickPlace_State#ApproachPick_Tracking:      res := THIS.M_Step_ApproachPick_Tracking();
    E_PickPlace_State#WaitForPickSync:            res := THIS.M_Step_WaitForPickSync();
    E_PickPlace_State#DescendAndPick:             res := THIS.M_Step_DescendAndPick();
    ...
END_CASE
M_Dispatcher := res;""", size=10.5,
      caption="Un CASE 1:1 con l'enum. Nessuna logica: solo smistamento.",
      notes="Il CASE funziona anche da indice: dice quali step sono implementati.")

    C("M_Driver_Motion_Cmd — l'unica porta verso il motion", """M_Driver_Motion_Cmd(fX, fY, fZ, fRx, fRy, fRz, fVel, fAcc, fDec,
                    eCoordSys, eBufferMode, eTransMode, param, eTransParam,
                    stMoveOption, bExecute);

// dentro: seleziona il canale Blend corrente e scrive
MoveLinearAbsolute_BlendN.Position     := vettore;
MoveLinearAbsolute_BlendN.Velocity     := fVel;
MoveLinearAbsolute_BlendN.Acceleration := fAcc;
MoveLinearAbsolute_BlendN.Deceleration := fDec;
MoveLinearAbsolute_BlendN.Execute      := TRUE;""",
      caption="Tutti gli step usano questa firma: cambiare strategia di motion = cambiare un metodo.",
      notes="eTransMode/eTransParam governano il blending (TMStartVelocity, 100%).")

    C("M_Driver_Motion_Check — come uno step sa di aver finito", """M_Driver_Motion_Check := E_StepStatus#BUSY;
IF MoveLinearAbsolute_BlendN.Error THEN
    M_Driver_Motion_Check := E_StepStatus#ERROR;
ELSIF MoveLinearAbsolute_BlendN.Active AND NOT MoveLinearAbsolute_BlendN.Busy THEN
    M_Driver_Motion_Check := E_StepStatus#ACTIVE;
ELSIF MoveLinearAbsolute_BlendN.Done THEN
    M_Driver_Motion_Check := E_StepStatus#DONE;
END_IF""", size=11,
      caption="Gli step che muovono chiamano questo metodo nel loro cyclic check.",
      notes="ACTIVE = il blocco ha preso il controllo: utile per considerare "
            "concluso un tratto che sta già sfumando nel successivo.")

    B("Il pattern di uno step", [
        (0, "Fase 1 — Entry Action:"),
        (1, "IF NOT bStepInitialized THEN ... bStepInitialized := TRUE; RETURN; END_IF"),
        (1, "configura e lancia il comando UNA sola volta"),
        (0, "Fase 2 — Cyclic Check:"),
        (1, "interroga l'esito (M_Driver_Motion_Check, Done, condizione)"),
        (1, "ritorna BUSY / DONE / ERROR / ACTIVE"),
        (0, "Perché il RETURN dopo l'entry:"),
        (1, "evita di valutare un esito che non può ancora esistere"),
        (1, "garantisce che il comando sia stato visto dal drive per un ciclo"),
        (0, "Eccezione:"),
        (1, "gli step di solo calcolo non hanno entry action"),
    ], size=16,
       notes="Copiare questo pattern quando si scrive un nuovo step: è usato in "
             "tutti i 24 step tranne quelli di computazione.")

    B("Fase PICK: gli step 0-6", [
        (0, "0 Initialize:"),
        (1, "gripper OFF, flag del ciclo, tracking disarmato"),
        (0, "1 CheckPickLimits:"),
        (1, "legge il pezzo dalla coda, DONE se esiste"),
        (0, "2 CalculatePickGripperOffset:"),
        (1, "offset del gripper ruotato di Rz"),
        (0, "3 SetPickFrame_Tracking:"),
        (1, "frame FeedIn dai 3 punti insegnati"),
        (0, "4 ConvertPickToCartesian_Tracking:"),
        (1, "vettore frame → riferimento cartesiano"),
        (0, "5 SetPickOffsetAndPCS_Tracking:"),
        (1, "il robot lavora nel sistema del pezzo"),
        (0, "6 EnablePickTracking:"),
        (1, "arma MC_TrackConveyorBelt sul FeedIn"),
    ], size=15,
       notes="I passi 0-5 preparano la geometria; il 6 è l'unico che cambia la "
             "natura del movimento.")

    B("Step 1-2: coda e offset gripper", [
        (0, "M_Step_CheckPickLimits:"),
        (1, "UsePointer/StorePointer di stPickPlaceProductData_Pick[GroupNumber]"),
        (1, "estrae X, Y, Rz grezzi del pezzo selezionato"),
        (1, "DONE se c'è un pezzo, BUSY se la coda è vuota"),
        (0, "Attenzione:"),
        (1, "i controlli sui limiti fisici sono presenti ma commentati: oggi non bloccano"),
        (0, "M_Step_CalcPickOffset:"),
        (1, "offset per gripper 1 o 2 (stGripper1_Offset / stGripper2_Offset)"),
        (1, "rotazione: X' = X + (ox·cos − oy·sin), Y' = Y + (ox·sin + oy·cos)"),
        (1, "serve perché i due gripper sono montati ruotati di Rz"),
    ], size=16,
       notes="Se la telecamera desse un pezzo fuori area, il ciclo proverebbe "
             "comunque: è un punto da ripristinare (roadmap).")

    B("Step 5-6: PCS e aggancio al nastro", [
        (0, "SetPickOffsetAndPCS_Tracking:"),
        (1, "GroupSetFrameOffset con ExecutionMode Immediately"),
        (1, "RefCoordSystem MCS, SetCoordSystem PCS"),
        (0, "EnablePickTracking:"),
        (1, "ConveyorBeltOrigin ← FeedIn_FrameOffset[1..6]"),
        (1, "InitialObjectPosition ← prodotto − frame offset"),
        (1, "normalizzazione Rz oltre ±90°"),
        (1, "RecordedPosition + OffsetCamera, StartDistance 10, EndDistance 500, SyncIn 10/5, SyncOut 15"),
        (1, "avvia fbRotatePosition per il polso"),
        (0, "Uscita:"),
        (1, "DONE quando TrackConveyorBelt_FeedIn.Active"),
    ], size=14,
       notes="132 righe: lo step più lungo del sequencer. Qui si decide la finestra "
             "di tracking.")

    B("Step 7-10: avvicinamento, presa, risalita", [
        (0, "7 ApproachPick_Tracking:"),
        (1, "movimento a quota 0, velocità MinVelocity_Delta, in PCS"),
        (1, "DONE/ACTIVE al primo riscontro: il successivo è già armato"),
        (0, "8 WaitForPickSync:"),
        (1, "attende InSync; fallback se ActualPosition = 0 (nastro fermo)"),
        (0, "9 DescendAndPick:"),
        (1, "attiva il gripper corretto, scende a Delta_Z_Pick (55 mm)"),
        (1, "salva TempPosConv = posizione nastro"),
        (0, "10 AscendAfterPick:"),
        (1, "risalita a quota 0 con ZPickPlaceSpeed"),
        (0, "Punto delicato:"),
        (1, "la pinza si attiva prima della discesa; nessuna verifica di contatto"),
    ], size=15,
       notes="Il fallback su ActualPosition = 0 è una rete di sicurezza per i test a "
             "nastro fermo.")

    B("Step 11-12: uscita dal pick", [
        (0, "11 MoveToParking_AfterPick:"),
        (1, "X/Y del frame FeedOut, Z = MIN(FeedIn.Z, FeedOut.Z), Rz = −45°"),
        (0, "12 SelectNextProduct_Pick:"),
        (1, "se ci sono altri pezzi in coda e siamo sul primo gripper:"),
        (1, "→ eRequestedJumpState := Initialize (torna a prendere il secondo)"),
        (1, "altrimenti il motore prosegue verso il PLACE"),
        (1, "se la coda è vuota: UsePointer := 0 e bGoToNextPhase := TRUE"),
        (0, "Perché serve un salto:"),
        (1, "in double mode il ciclo ripete la fase pick due volte prima del place"),
    ], size=16,
       notes="È l'unico punto in cui il sequencer torna indietro: il jump esiste per "
             "il double pick.")

    B("Fase PLACE: gli step 13-18", [
        (0, "13 InitializePlace:"),
        (1, "bPlacePhaseActive := TRUE (da qui il soft abort non è più permesso)"),
        (0, "14 SetPlaceFrame_Tracking:"),
        (1, "frame FeedOut da aTeachFrame[2]"),
        (0, "15 ConvertPlaceToCartesian_Tracking:"),
        (1, "conversione del frame di deposito"),
        (0, "16 EnablePlaceTracking:"),
        (1, "arma il tracking sul FeedOut, EndDistance 200"),
        (0, "17 ApproachPlace_Tracking:"),
        (1, "avvicinamento in PCS a quota 0, Rz = −45"),
        (0, "18 WaitForPlaceSync:"),
        (1, "attende InSync del FeedOut (senza fallback)"),
    ], size=15,
       notes="Fase speculare alla pick ma su un nastro diverso, con finestra più "
             "stretta.")

    B("Fase PLACE: gli step 19-23", [
        (0, "19 DescendAndPlace:"),
        (1, "discesa a Delta_Z_Place (35 mm) e rilascio del gripper"),
        (0, "20 WaitAfterPlace_Tracking:"),
        (1, "attesa in sync dopo il rilascio"),
        (0, "21 AscendAfterPlace:"),
        (1, "risalita a quota 0"),
        (0, "22 MoveToParking_AfterPlace:"),
        (1, "rientro verso il parking"),
        (0, "23 CycleCompletitionAndChangeMode:"),
        (1, "bPlaceCycleComplete := TRUE, poi il motore ricarica la playlist"),
        (0, "Nota:"),
        (1, "Z di place (35) < Z di pick (55): il deposito è più basso"),
    ], size=15,
       notes="La chiusura ciclo è anche il punto in cui il KPI conta la piazzatura.")

    B("Playlist di servizio: parking e abort", [
        (0, "M_ConfigSequence_Parking:"),
        (1, "usata quando l'utente preme Stop Cycle a fine ciclo"),
        (0, "M_ConfigSequence_AbortToParking:"),
        (1, "soft abort a metà ciclo: gripper OFF, tracking OFF, rientro sicuro"),
        (0, "Step di servizio:"),
        (1, "InitParking: disarma tracking, gripper OFF, reinizializza i blend"),
        (1, "MoveToParking_SafePosition: posizione fuori ingombro"),
        (1, "FinalParkingCompletition: disarmo di frame transform e set frame offset"),
        (1, "Error: attesa (BUSY) finché non si resetta"),
    ], size=16,
       notes="Le playlist di servizio riusano gli stessi metodi step: nessun codice "
             "duplicato per il parking.")

    B("M_ResetMachine — il reset pulito", [
        (0, "Azioni:"),
        (1, "PickPlace_Status := FALSE, iCurrentStepIndex := 0, bStepInitialized := FALSE"),
        (1, "tracking e tutti e quattro i MoveLinearAbsolute_BlendN.Execute := FALSE"),
        (1, "gripper OFF e reset dei FB interni"),
        (0, "Quando:"),
        (1, "quando StartPickPlace passa a FALSE"),
        (0, "Perché:"),
        (1, "evita che un Execute resti armato e riparta al riavvio del ciclo"),
        (0, "Se dopo un reset 'si muove da solo':"),
        (1, "quasi sempre c'è un Execute rimasto alto, verificare qui"),
    ], size=16,
       notes="È il punto di ripristino prima di ogni nuova sequenza.")

    T("I 43 metodi del sequencer, per famiglia", ["Famiglia", "Metodi", "N."], [
        ["Motore", "M_Dispatcher, M_Helper_FindStepIndex, AddStep", "3"],
        ["Configurazione", "M_ConfigSequence_Run / _Parking / _AbortToParking", "3"],
        ["Driver motion", "M_Driver_Motion_Cmd / _Check / _InitPointers / _ResetMove", "4"],
        ["Pick (prep.)", "Initialize, CheckPickLimits, CalcPickOffset, SetPickFrame, ConvertPickToCartesian, SetPickOffsetAndPCS, EnablePickTracking", "7"],
        ["Pick (azione)", "ApproachPick, WaitForPickSync, DescendAndPick, AscendAfterPick, MoveToParking, SelectNextProduct, WaitAfterPick", "7"],
        ["Place", "13 metodi (frame, tracking, approach, descend, wait, ascend, parking, completition)", "13"],
        ["Parking", "InitParking, MoveToParking_SafePosition, FinalParkingCompletition", "3"],
        ["Altro", "M_ResetMachine, M_Step_Error, M_Step_StartMovePath", "3"],
    ], size=11.5, col_widths=[2.4, 8.6, 0.8],
       notes="La sproporzione pick/place (7 vs 13) è storica: il place ha più "
             "varianti (fisso, tracking, doppio).")

    B("Come aggiungere uno step", [
        (0, "1. Enum: valore in E_PickPlace_State (sfruttando lo spazio 50-50)"),
        (0, "2. Metodo: M_Step_<Nome> con entry action + cyclic check"),
        (0, "3. Dispatcher: nuovo ramo nel CASE di M_Dispatcher"),
        (0, "4. Playlist: AddStep nella posizione corretta (e in Parking se serve)"),
        (0, "5. Verifica:"),
        (1, "lo step non fa transizioni da solo e ritorna sempre un esito"),
        (1, "le risorse usate sono disarmate in M_ResetMachine"),
        (0, "Errore più comune:"),
        (1, "aggiungere il metodo e dimenticare il ramo nel dispatcher"),
    ], size=16,
       notes="Tre punti da toccare, non uno: è la checklist da seguire.")

    T("Errori tipici nel sequencer", ["Sintomo", "Causa probabile", "Dove guardare"], [
        ["Ciclo fermo in uno step", "step ritorna sempre BUSY", "il metodo e lo stato del FB"],
        ["Salto sbagliato", "eRequestedJumpState non azzerato", "M_Helper_FindStepIndex"],
        ["Doppio pick non eseguito", "modo doppio non caricato", "step 0, iGripperToUse"],
        ["Insegue il pezzo sbagliato", "UsePointer/StorePointer incoerenti", "CheckPickLimits"],
        ["Movimento a scatti", "blend non attivo", "M_Driver_Motion_Cmd / BlendN"],
        ["Ciclo riparte da solo", "Execute rimasto alto", "M_ResetMachine"],
        ["Stop cycle non si chiude", "bStopAbortActive già TRUE", "motore, ramo abort"],
    ], size=11.5, col_widths=[3.4, 4.4, 4.4],
       notes="Tabella da tenere a portata di mano durante il debug in campo.")

    # ---------------------------------------------------------------- 09
    d.section("09", "Tracking e controllo nastri",
              "La legge che lega nastro, robot e finestra di tracking",
              topics=["Finestra di tracking", "Le 4 zone", "Perché la zona 2 è costante",
                      "Rampa finale", "Decelerazione unica", "Taratura"],
              notes="Sezione chiave: decide se il robot prende sempre il pezzo.")

    S("Il nastro non deve mai portare il pezzo fuori dalla finestra di tracking.",
      "Tutto il controllo di velocità del FeedIn esiste per garantire questo.",
      notes="EndDistance 500 mm, il nastro si ferma a 450 mm: 50 mm di margine.")

    T("Le soglie del sistema", ["Parametro", "Valore", "Dove"], [
        ["TrackingWindowStart", "300 mm", "DT_Machine.Setting (Init.pou)"],
        ["TrackingWindowEnd", "450 mm", "DT_Machine.Setting (Init.pou)"],
        ["EndDistance (tracking)", "500 mm FeedIn / 200 FeedOut", "M_Step_Enable*Tracking"],
        ["StartDistance", "10 mm", "M_Step_EnablePickTracking"],
        ["SyncIn Conveyor/TCP", "10 / 5 mm", "M_Step_EnablePickTracking"],
        ["SyncOut Conveyor", "15 mm", "M_Step_EnablePickTracking"],
        ["end_zone_margin", "50 mm", "PickPlaceManager (locale)"],
        ["v_min", "50 mm/s", "PickPlaceManager"],
        ["OffsetCamera", "750 mm", "DT_Machine.Setting"],
        ["Distanza trigger camera", "140 mm", "VisionManager"],
    ], size=12, col_widths=[4.6, 3.0, 4.6],
       notes="Tutti i valori in mm, riferiti al frame FeedIn.")

    C("La formula della distanza (unica per la macchina)", """distance = MonitorStatusData[0].DistanceFromOrigin[1]
         - DATA_Machine.Setting.OffsetCamera

dove   DistanceFromOrigin[1] = ActualPosition - RecordedPosition
       RecordedPosition     = posizione nastro latchata allo scatto + OffsetCamera

quindi, per il pezzo in tracking:
       distance = corsa del nastro dal trigger""", size=11,
      caption="La stessa grandezza è replicata in HMI.pou per la pagina Tracking: niente copie divergenti.",
      notes="Se cambia la formula, va cambiata in due punti controllati: logica e "
            "visualizzazione, entrambi leggono lo stesso setting.")

    B("Le quattro zone del controllo nastro", [
        (0, "Zona 1 — distance ≤ 300 mm (o coda vuota):"),
        (1, "velocità nominale, tracking non attivo"),
        (0, "Zona 2 — 300 → 400 mm:"),
        (1, "fascia di prelievo a velocità COSTANTE v_min = 50 mm/s"),
        (0, "Zona 3 — 400 → 450 mm:"),
        (1, "rampa proporzionale da v_min a 0 (end_zone_margin = 50 mm)"),
        (0, "Zona 4 — oltre 450 mm:"),
        (1, "setpoint 0, accelerazione al minimo (acc_min)"),
        (0, "Decelerazione:"),
        (1, "sempre dec_max = CommandDeceleration, in tutte le zone"),
    ], size=16,
       notes="Le zone sono in FB_ConveyorController, con un commento esteso in testa "
             "che spiega il perché di ognuna.")

    C("FB_ConveyorController — la scelta delle zone", """IF (distance <= tracking_start)
   OR (UsePointer = StorePointer) THEN                 // ZONA 1 (+ coda vuota)
    speed_setpoint := v_nominal;  tracking_active := FALSE;
ELSIF distance < (tracking_end - ramp_margin) THEN     // ZONA 2
    speed_setpoint := v_ramp_min;  tracking_active := TRUE;
ELSIF distance < tracking_end THEN                     // ZONA 3
    d_remaining := tracking_end - distance;
    ratio_end   := 1.0 - (d_remaining / ramp_margin);
    ratio_end   := MAX(0.0, MIN(1.0, ratio_end));
    speed_setpoint := v_ramp_min * (1.0 - ratio_end);
    IF d_remaining < 1.0 THEN speed_setpoint := 0.0; END_IF
    tracking_active := TRUE;  end_zone_active := TRUE;
ELSE                                                    // ZONA 4
    speed_setpoint := 0.0;  acceleration := acc_min;
    tracking_active := TRUE;  end_zone_active := TRUE;
END_IF
deceleration := dec_max;""", size=10.5,
      notes="La riga fuori dall'IF è la correzione che ha allineato lo stop dei due "
            "nastri (caso di studio 1).")

    B("Perché la zona 2 è costante", [
        (0, "Se fosse proporzionale per tutta la fascia:"),
        (1, "ogni pezzo della fila farebbe rallentare il nastro"),
        (1, "preso un pezzo, il tracking passa al successivo (più indietro)"),
        (1, "il nastro riaccelera e poi rallenta di nuovo: effetto 'pompa'"),
        (0, "Con velocità costante:"),
        (1, "il cambio di velocità avviene una volta sola all'ingresso in fascia"),
        (1, "resta stabile per tutto il prelievo"),
        (1, "la rampa resta dove serve: gli ultimi 50 mm"),
        (0, "Compromesso accettato:"),
        (1, "throughput minore, in cambio di prelievo stabile e ripetibile"),
    ], size=16,
       notes="Esempio di scelta guidata dalla fisica del processo, non dal codice.")

    B("La rampa finale e il fermo garantito", [
        (0, "Formula:"),
        (1, "speed = v_ramp_min × (1 − ratio_end) = v_ramp_min × d_remaining / ramp_margin"),
        (0, "Comportamento:"),
        (1, "a 450 mm il setpoint è 0 per costruzione"),
        (1, "rampa continua: nessun gradino nel setpoint"),
        (1, "ultimo millimetro: azzeramento secco"),
        (0, "Perché l'azzeramento secco:"),
        (1, "una rampa proporzionale tende a zero asintoticamente: il nastro striscerebbe"),
        (1, "lo scalino residuo è < v_min / ramp_margin ≈ 1 mm/s"),
        (0, "Protezioni:"),
        (1, "zone_length ≥ 2 mm, ramp_margin clampato, v_ramp_min = MIN(v_min, v_nominal)"),
    ], size=16,
       notes="Le protezioni servono perché i parametri arrivano dall'HMI: il blocco "
             "non deve mai dividere per zero o invertire la rampa.")

    S("La decelerazione è una sola per i due nastri: quella impostata in HMI.",
      "Qualsiasi 'ottimizzazione' locale della decelerazione rompe l'allineamento "
      "dello stop ciclo.",
      notes="Nasce da un difetto reale, raccontato nella sezione 15.")

    B("Reti di sicurezza del blocco", [
        (0, "Coda vuota (UsePointer = StorePointer):"),
        (1, "il nastro torna a nominale anche se l'ultimo pezzo è fermo sulla soglia"),
        (1, "senza questa condizione il nastro resterebbe a 0 e la linea si fermerebbe"),
        (0, "enable = FALSE (ciclo fermo, manuale):"),
        (1, "nessuna frenata: nominale, acc_max, dec_max"),
        (1, "il jog resta identico a quello del FeedOut"),
        (0, "Fallback nel sequencer:"),
        (1, "WaitForPickSync considera DONE anche con ActualPosition = 0"),
        (0, "Regola:"),
        (1, "prima di aggiungere uno stop, chiedersi come se ne esce"),
    ], size=16,
       notes="Il pattern 'uscita di sicurezza' è ricorrente in tutto il progetto.")

    B("Come si regola la legge del nastro", [
        (0, "Da HMI:"),
        (1, "CommandVelocity, CommandAcceleration, CommandDeceleration del FeedIn"),
        (0, "Da Init.pou (richiede rebuild):"),
        (1, "TrackingWindowStart/End, OffsetCamera"),
        (0, "In PickPlaceManager:"),
        (1, "v_min = 50, end_zone_margin = 50, acc_min/dec_min = 100"),
        (0, "Procedura di taratura:"),
        (1, "1. verificare 450 < EndDistance (500)"),
        (1, "2. misurare la distanza reale di stop con un pezzo marcato"),
        (1, "3. se supera la soglia: alzare v_min o allargare end_zone_margin"),
        (1, "4. se il ciclo è lento: valutare il throughput della zona 2"),
    ], size=16,
       notes="Regola: non si cambiano legge e parametro insieme. Prima si misura, "
             "poi si regola un solo numero.")

    T("Sintomi e cause sul controllo nastro", ["Sintomo", "Causa", "Rimedio"], [
        ["Nastro che 'pompa'", "rampa proporzionale in zona 2", "ripristinare velocità costante"],
        ["Pezzo oltre la finestra", "tracking_end troppo vicino a EndDistance", "aumentare il margine"],
        ["Nastro che striscia sulla soglia", "manca azzeramento secco", "controllare d_remaining < 1 mm"],
        ["Stop ciclo FeedIn lentissimo", "dec_min usato come JogDec", "JogDec = CommandDeceleration"],
        ["Nastro fermo dopo l'ultimo pezzo", "manca condizione coda vuota", "ripristinare OR UsePointer=StorePointer"],
        ["Pezzo preso corto/lungo", "frame o OffsetCamera errati", "verificare frame e offset"],
    ], size=12, col_widths=[3.4, 4.4, 4.2],
       notes="Derivata dai difetti realmente incontrati nel progetto.")

    # ---------------------------------------------------------------- 10
    d.section("10", "Catena di visione",
              "Dal trigger fisico al pezzo in coda",
              topics=["Trigger fisico + latch", "FB_VisionApplication",
                      "Telegramma VISOR", "Formattazione", "Distribuzione"],
              notes="Visione = trigger + latch + telegramma + formattazione + "
                    "distribuzione.")

    S("La posizione del pezzo non è 'dov'è il nastro adesso', ma 'dov'era quando la telecamera ha scattato'.",
      "Da qui nasce la necessità del latch hardware (MC_TouchProbe).",
      notes="Senza latch, il jitter di Ethernet/IP diventerebbe un errore di "
            "posizione di diversi millimetri.")

    B("Perché trigger fisico e posizione latchata", [
        (0, "Problema:"),
        (1, "il telegramma EIP arriva con latenza variabile"),
        (1, "leggere ActualPosition alla ricezione dà un errore casuale"),
        (0, "Soluzione in due pezzi:"),
        (1, "uscita digitale SLIO → impulso al trigger della telecamera"),
        (1, "lo stesso segnale entra nel latch del servo (touch probe)"),
        (0, "Risultato:"),
        (1, "la posizione è catturata dall'hardware del drive"),
        (1, "precisione indipendente dalla latenza di rete"),
        (0, "Modalità legacy:"),
        (1, "xUsePhysTrigger := FALSE → trigger EIP e campionamento software"),
    ], size=16,
       notes="xUsePhysTrigger = TRUE è la configurazione raccomandata.")

    C("Latch e trigger in VisionManager", """DATA_FeedInAxis.Setting.TouchProbeTriggerInput.Bit := UINT#1;
DATA_FeedInAxis.Setting.TouchProbeTriggerInput.ID  := UINT#0;

rtTouchProbeDone(CLK := DATA_FeedInAxis.Status.TouchProbeDone);
IF rtTouchProbeDone.Q THEN
    rLatchedBeltPos := DATA_FeedInAxis.Feedback.TouchProbeRecPos;
END_IF

fbVisionApp( ... rLatchedPosition := rLatchedBeltPos,
                 xTouchProbeDone  := DATA_FeedInAxis.Status.TouchProbeDone,
                 xTouchProbeError := DATA_FeedInAxis.Error.TouchProbe_Err, ... );

DATA_FeedInAxis.Command.TouchProbe := fbVisionApp.xArmTouchProbe;  // arma il probe
xPhysTriggerCamera := fbVisionApp.xPhysTrigger;                    // impulso al DO""",
      size=10.5,
      caption="Ordine obbligato: il latch si cattura PRIMA della chiamata al FB visione.",
      notes="Il commento nel codice lo dice esplicitamente: 'il valore deve essere "
            "fresco quando il FB vede il fronte del latch'.")

    B("Trigger su distanza", [
        (0, "Parametri:"),
        (1, "xEnableDistanceTrigger := TRUE"),
        (1, "rDistanceSetpoint := 140.0 mm"),
        (1, "rConveyorCurrentPos := DATA_FeedInAxis.Feedback.ActualPosition"),
        (0, "Logica (FB_DistanceTrigger in FB_VisionApplication):"),
        (1, "ogni 140 mm di corsa → impulso di 10 ms (tPhysTriggerPulse)"),
        (0, "Conseguenze:"),
        (1, "spaziatura delle foto fissa in distanza, non in tempo"),
        (1, "a nastro lento si scatta meno spesso: nessuna foto doppia"),
        (0, "Alternativa ciclica:"),
        (1, "xEnableCyclicMode = FALSE, non usata in produzione"),
    ], size=16,
       notes="140 mm di passo con 4 posti per foto: copertura sufficiente per pezzi "
             "fino a ~35 mm di passo.")

    T("Telegramma VISOR: mappa dei byte", ["Byte", "Campo", "Tipo", "Note"], [
        ["0-7", "header / stato", "—", "stato connessione"],
        ["8-23", "Pos_X[0..3]", "REAL × 4", "÷1000 → mm"],
        ["24-39", "Pos_Y[0..3]", "REAL × 4", "÷1000 → mm"],
        ["40-55", "Angle_Rz[0..3]", "REAL × 4", "÷1000 → gradi"],
        ["56", "Part_Count", "BYTE/INT", "0-4 pezzi per foto"],
        ["TX 3 B", "trigger / job", "—", "comandi verso la telecamera"],
    ], size=12, col_widths=[1.8, 3.4, 2.4, 4.4],
       notes="Il buffer ha 4 slot: è questo che limita Part_Count a 4. Il controllo "
             "su Part_Count > 4 è commentato.")

    C("Conversione byte → REAL", """stInput.ResultData.Pos_X[0] := FC_BytesToReal(RX[8], RX[9], RX[10], RX[11]) / 1000.0;

FUNCTION FC_BytesToReal : REAL          // composizione little-endian IEEE754
FUNCTION FC_BytesToInt  : DINT          // contatori interi""", size=11,
      caption="Un solo punto di conversione: se cambia il protocollo, si cambia qui.",
      notes="Endianness del controllore (LittleEndian) e del protocollo EIP: è "
            "l'errore classico che produce valori assurdi.")

    B("Dal risultato grezzo al pezzo in coda", [
        (0, "1. VisionManager copia i risultati in buffer locali:"),
        (1, "aBuffer_X / aBuffer_Y / aBuffer_Rz, solo sul fronte di xVisionCycleDone"),
        (0, "2. fbFormatProductData:"),
        (1, "converte in InputProductData; Execute se bNewVisionDataReady AND NOT Busy"),
        (0, "3. fbSequenceDistribution:"),
        (1, "TriggerConveyorPosition := rTriggeredPosition (latchata)"),
        (1, "scrive in MultiGrpProductData[0], buffer circolare da 150"),
        (0, "4. fbMultiGrpProductMonitor:"),
        (1, "calcola MonitorStatusData: distanze e stato dei prodotti"),
        (1, "è la sorgente di DistanceFromOrigin per il controllo nastro"),
    ], size=16,
       notes="Catena a stadi con handshake Busy/Done: nessuno stadio sovrascrive il "
             "precedente.")

    T("Opzioni di distribuzione (PartOptions)", ["Opzione", "Valore", "Effetto"], [
        ["DuplicateDetect", "TRUE", "scarta pezzi duplicati"],
        ["DuplicateMinDifference", "250.0", "soglia di distinguibilità"],
        ["Sort / SortBy / SortOrder", "TRUE / X / Ascending", "primo della coda = più avanti sul nastro"],
        ["SequenceLength", "1", "nessun pattern: pezzi indipendenti"],
        ["BufferSize", "150", "posti nell'anello MultiGrpProductData"],
    ], size=12, col_widths=[3.6, 2.8, 5.8],
       notes="L'ordinamento per X crescente è il presupposto del sequencer: 'il "
             "primo della coda' è il pezzo più avanti.")

    B("Contatori di visione", [
        (0, "Incrementati al fronte di xVisionCycleDone:"),
        (1, "G_udiVisionCycles, G_udiVisionEmptyPhotos, G_udiProductsDetected"),
        (0, "Tempo di elaborazione:"),
        (1, "dal fronte del trigger fisico al Done"),
        (1, "tonVisionProc con timeout 10 s"),
        (1, "salvato in G_tVisionLastProcTime"),
        (0, "Perché contare le foto vuote:"),
        (1, "percentuale alta = nastro non caricato o trigger fuori zona"),
        (1, "è un KPI diagnostico, non produttivo"),
    ], size=16,
       notes="FB_KPI legge questi contatori per differenza.")

    T("Guasti tipici della visione", ["Sintomo", "Causa", "Dove guardare"], [
        ["Nessun pezzo in coda", "telecamera non connessa / job errato", "ConnectionState, EIP_STATUS_REF"],
        ["Pezzi sfasati in avanti", "trigger in ritardo o pulse lungo", "tPhysTriggerPulse, uscita SLIO"],
        ["Pezzi sfasati indietro", "latch non catturato", "TouchProbeDone, TouchProbe_Err"],
        ["Coordinate assurde", "endianness o ÷1000", "FC_BytesToReal, mappa byte"],
        ["Pezzi doppi", "DuplicateMinDifference bassa", "PartOptions"],
        ["Coda satura", "BufferSize 150 superato", "UsePointer/StorePointer"],
        ["Rz sbagliato di 90°", "normalizzazione del frame", "M_Step_EnablePickTracking"],
    ], size=11.5, col_widths=[3.2, 4.4, 4.4],
       notes="'Coda piena' significa che la produzione non smaltisce quanto la "
             "visione rileva: indicatore di saturazione.")

    # ---------------------------------------------------------------- 11
    d.section("11", "Gestione errori",
              "FB_ErrorHandler: buffer circolare, severità, ack e reset",
              topics=["Buffer circolare", "AddUpdateError", "LogEvent",
                      "Severità", "Ack vs Reset", "ErrorManager"],
              notes="Sistema unico di raccolta errori, condiviso da tutti i POU.")

    B("Il modello: un buffer circolare globale", [
        (0, "Struttura:"),
        (1, "G_ErrorBuffer[1..C_ERROR_BUFFER_SIZE], condiviso fra tutti i POU"),
        (1, "indici G_udiErrorHead (scrittura) e G_udiErrorTail (lettura)"),
        (1, "G_bBufferFull distingue pieno da vuoto"),
        (0, "Ogni voce:"),
        (1, "ErrorCode, ErrorSource, ErrorMessage, Severity"),
        (1, "IsActive, Acknowledged, Timestamp (SysTimestamp)"),
        (0, "Chi lo usa:"),
        (1, "MachineController, sequencer, VisionManager, ErrorManager"),
    ], size=16,
       notes="Il buffer è globale e non per istanza: una sola lista errori visibile "
             "al pannello.")

    C("AddUpdateError — la logica di deduplica", """IF bErrorDetected THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        IF G_ErrorBuffer[i].ErrorCode = udiErrorID AND
           G_ErrorBuffer[i].ErrorSource = sErrorSource AND
           G_ErrorBuffer[i].IsActive THEN
            udiActiveMatchIndex := i;  EXIT;
        END_IF
    END_FOR
    IF udiActiveMatchIndex = 0 THEN          // nuovo errore
        G_ErrorBuffer[G_udiErrorHead].ErrorCode   := udiErrorID;
        G_ErrorBuffer[G_udiErrorHead].ErrorSource := sErrorSource;
        G_ErrorBuffer[G_udiErrorHead].Severity    := eErrorSeverity;
        G_ErrorBuffer[G_udiErrorHead].IsActive    := TRUE;
        G_ErrorBuffer[G_udiErrorHead].Timestamp   := SysTimestamp;
    END_IF
ELSE
    // errore rientrato: marca inattiva la voce attiva con stessa sorgente
END_IF""", size=10,
      caption="Chiave di deduplica: la coppia (ErrorCode, ErrorSource), non il solo codice.",
      notes="Senza deduplica un errore persistente riempirebbe il buffer di "
            "migliaia di righe identiche.")

    B("Perché la deduplica è indispensabile", [
        (0, "Il codice è ciclico:"),
        (1, "una condizione viene valutata ogni 2-64 ms"),
        (1, "senza deduplica: centinaia di voci identiche al secondo"),
        (0, "Criterio:"),
        (1, "stessa sorgente + stesso codice = stessa voce"),
        (0, "Rientro:"),
        (1, "quando la condizione torna FALSE la voce resta in buffer ma IsActive := FALSE"),
        (1, "lo storico è preservato: si sa che è avvenuto e quando"),
        (0, "Conseguenza:"),
        (1, "il numero di voci attive è un indicatore affidabile di stato"),
    ], size=16,
       notes="Le voci inattive restano nello storico eventi: base per la diagnosi "
             "post-turno.")

    T("Le severità e cosa comportano", ["Severità", "Significato", "Effetto"], [
        ["Info", "evento informativo", "solo log"],
        ["Warning", "anomalia non bloccante", "log + indicazione su HMI"],
        ["MinorError", "errore recuperabile", "stop ciclo, reset necessario"],
        ["MajorError", "guasto serio", "macchina in STOPPING/ERROR"],
        ["None", "voce cancellata", "usato dal reset"],
    ], size=12.5, col_widths=[2.6, 4.2, 5.4],
       notes="E_ErrorSeverity è ordinato: il confronto '>' restituisce la severità "
             "massima. Dettaglio implementativo elegante.")

    B("LogEvent vs AddUpdateError vs CheckAndEnqueue", [
        (0, "LogEvent(code, source, message, severity):"),
        (1, "evento puntuale, non condizione persistente"),
        (1, "usato per transizioni di stato e azioni operatore"),
        (0, "AddUpdateError(condizione, ...):"),
        (1, "legato a una condizione: TRUE = attivo, FALSE = rientrato"),
        (1, "è il metodo da usare per i guasti di campo"),
        (0, "CheckAndEnqueue(...):"),
        (1, "usa un 'old state' per rilevare solo il fronte di salita"),
        (1, "nel progetto molti usi sono commentati"),
        (0, "Regola:"),
        (1, "condizione che dura → AddUpdateError; evento istantaneo → LogEvent"),
    ], size=16,
       notes="Confondere i tre è una fonte di rumore: un evento loggato come "
             "condizione resta 'attivo' per sempre.")

    C("Update — reset e acknowledge", """xResetErrorsR_TRIG(CLK := bResetErrors OR G_bResetAllErrors);
IF xResetErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        G_ErrorBuffer[i].IsActive := FALSE;  G_ErrorBuffer[i].Acknowledged := FALSE;
        G_ErrorBuffer[i].ErrorCode := 0;     G_ErrorBuffer[i].Severity := E_ErrorSeverity#None;
    END_FOR
    G_udiErrorHead := 1;  G_udiErrorTail := 1;  G_bBufferFull := FALSE;
    G_bResetAllErrors := FALSE;
END_IF

xAcknowledgeErrorsR_TRIG(CLK := bAcknowledgeErrors OR G_bAcknowledgeAllErrors);
IF xAcknowledgeErrorsR_TRIG.Q THEN
    FOR i := 1 TO C_ERROR_BUFFER_SIZE DO
        IF G_ErrorBuffer[i].IsActive THEN G_ErrorBuffer[i].Acknowledged := TRUE; END_IF
    END_FOR
    G_bAcknowledgeAllErrors := FALSE;
END_IF""", size=9.5,
      caption="Reset = svuota tutto. Ack = prende atto, ma l'errore resta se la condizione persiste.",
      notes="Distinzione fondamentale per l'operatore: Ack non risolve.")

    B("ErrorManager e diagnosi del motion", [
        (0, "ErrorManager (task dedicato, 64 ms):"),
        (1, "scansiona il buffer, conta le voci attive, calcola la severità massima"),
        (1, "espone la lista su HMI, mantiene il pareto per codice/sorgente"),
        (1, "funziona anche se il ciclo di macchina è bloccato"),
        (0, "Errori di motion:"),
        (1, "drive → allarme EtherCAT → FB_AxisController → DATA_AXI.Status/Error"),
        (1, "FB_MachineController legge lo stato servo e chiama AddUpdateError"),
        (1, "si espone la condizione aggregata + DriveAlarmID per la diagnosi"),
        (0, "Perché non si mappa ogni allarme:"),
        (1, "centinaia di codici Yaskawa, manutenzione impossibile"),
    ], size=15,
       notes="Compromesso: messaggi generici ma codice allarme sempre visibile per "
             "la ricerca sul manuale.")

    S("Un allarme che si ripete ogni ciclo non è un errore: è un difetto di progetto.",
      "Se il buffer riceve voci sempre uguali, il problema è il criterio di "
      "rilevamento, non il guasto.",
      notes="Suggerimento: introdurre un rate-limiter per sorgente con finestra "
            "temporale.")

    # ---------------------------------------------------------------- 12
    d.section("12", "KPI e metriche",
              "FB_KPI: cosa misuriamo, come e perché",
              topics=["Contatori turno/lifetime", "Formule di produzione",
                      "Tempi di ciclo", "Disponibilità", "Reset turno"],
              notes="Metriche di turno e di vita macchina, con formule e sorgenti.")

    B("Architettura dei contatori", [
        (0, "Tre livelli:"),
        (1, "variabili G_udi* globali incrementate dai POU sorgente"),
        (1, "contatori di turno (udiSh*) resettabili da G_xKPI_ResetShift"),
        (1, "contatori lifetime (udiLife*) mai resettati"),
        (0, "Sorgenti di evento:"),
        (1, "G_bPieceInHand (salita = prelievo, discesa = piazzatura)"),
        (1, "G_bPickPlaceError, xPhysTriggerCamera, TouchProbeDone"),
        (0, "Calcolo:"),
        (1, "delta rispetto al valore precedente, tick da 1 s e 1 min"),
        (0, "Output:"),
        (1, "KPI_Data (OPC) + copia in HMI_Data.Process.Status"),
    ], size=16,
       notes="Il doppio livello turno/lifetime evita di perdere la storia della "
             "macchina a ogni cambio turno.")

    B("Perché i contatori globali richiedono i delta", [
        (0, "G_udiVisionCycles è un UDINT sempre crescente:"),
        (1, "FB_KPI non lo resetta: non ne è il proprietario"),
        (1, "calcola udiDelta := G_udiVisionCycles − udiVisionCyclesOld"),
        (0, "Vantaggi:"),
        (1, "un solo scrittore per variabile"),
        (1, "il KPI può essere ricalcolato senza toccare i contatori"),
        (0, "Attenzione:"),
        (1, "al riavvio i G_ tornano a 0: il delta diventerebbe negativo"),
        (1, "su UDINT diventa un numero enorme: da verificare prima di pubblicare"),
    ], size=16,
       notes="Punto in roadmap: clamp dei delta negativi o uso di DINT con controllo "
             "di segno.")

    T("KPI di produzione", ["KPI", "Formula", "Unità"], [
        ["Picked", "fronti di salita di G_bPieceInHand", "pz"],
        ["Placed", "fronti di discesa di G_bPieceInHand", "pz"],
        ["Cycles / Good cycles", "piazzature concluse / senza errore", "cicli"],
        ["Quality rate", "Good cycles / Cycles × 100", "%"],
        ["Products detected", "somma Part_Count della visione", "pz"],
        ["Empty photos", "foto con Part_Count = 0", "foto"],
        ["Products/min", "placed nell'ultimo minuto (array 60 posti)", "pz/min"],
    ], size=12, col_widths=[3.0, 7.4, 1.6],
       notes="Il rateo è su finestra scorrevole a 60 posizioni, non su media dall'inizio "
             "turno: riflette lo stato attuale.")

    T("KPI di tempo", ["KPI", "Definizione", "Note"], [
        ["Cycle time last/min/max/avg", "da piazzatura a piazzatura (tonCycle)", "timeout 600 s"],
        ["Pick time last/avg", "da prelievo a piazzatura (tonPick)", "timeout 60 s"],
        ["Vision proc time", "dal trigger fisico al Done", "timeout 10 s"],
        ["Error episode time", "durata media degli episodi di errore", "aggregato"],
        ["Uptime / time in error", "secondi operativi / in ERROR", "per stato"],
        ["Since last error", "secondi dall'ultimo errore", "contatore"],
    ], size=12, col_widths=[3.6, 5.4, 3.0],
       notes="Tempi con TON e conversione TIME_TO_DINT(ET) in ms. Il primo ciclo non "
             "entra nella statistica.")

    T("Distribuzione del tempo per stato", ["Contatore", "Quando incrementa"], [
        ["udiShStateAuto", "stato OPERATIONAL_AUTOMATIC"],
        ["udiShStateManual", "stato OPERATIONAL_MANUAL"],
        ["udiShStateStopping", "stato STOPPING"],
        ["udiShStateError", "stato ERROR"],
        ["udiShStateOther", "tutti gli altri stati"],
        ["udiShUptimeSec", "secondi totali di osservazione"],
    ], size=12, col_widths=[3.6, 8.4],
       notes="Serve a calcolare la disponibilità: tempo operativo / tempo totale.")

    B("Disponibilità e OEE: cosa manca", [
        (0, "Calcolabile oggi:"),
        (1, "availability ≈ (uptime − time in error) / uptime"),
        (1, "quality ≈ good cycles / cycles"),
        (1, "performance ≈ products/min reale vs teorico"),
        (0, "Cosa manca per un OEE formale:"),
        (1, "tempo teorico per pezzo definito e accettato"),
        (1, "distinzione fra fermate pianificate e non pianificate"),
        (1, "motivo di fermata categorizzato"),
        (0, "Perché dirlo:"),
        (1, "un OEE su basi ambigue genera discussioni invece di decisioni"),
    ], size=16,
       notes="Raccomandazione: introdurre le categorie di fermata prima di parlare "
             "di OEE. È un lavoro sui codici errore.")

    C("Reset turno: cosa azzera e cosa no", """IF rtReset.Q THEN                      // G_xKPI_ResetShift
    udiShPlaced := 0;  udiShPicked := 0;  udiShCycles := 0;  udiShCyclesGood := 0;
    udiShPickErr := 0; udiShVisionCycles := 0; udiShEmptyPhotos := 0; udiShDetected := 0;
    udiShTriggers := 0; udiShLatch := 0; udiShStray := 0; udiShErrors := 0;
    udiShStateAuto := 0; ...  rCycleSumMs := 0.0; rCycleMinMs := 999999999.0;
END_IF
// NON azzerati: udiLifePicked, udiLifePlaced, udiLifeCycles, udiLifeVision ...""",
      size=10.5,
      caption="Reset intenzionale e manuale: nessun azzeramento automatico a mezzanotte.",
      notes="L'inizio turno non è sincronizzato con l'orologio del controllore: "
            "quindi il reset è un comando operatore.")

    # ---------------------------------------------------------------- 13
    d.section("13", "HMI e interfaccia operatore",
              "Un solo canale dati, nessuna eccezione",
              topics=["Canale unico", "DataList e flag OPC", "HMI.pou",
                      "Pagina Robot & Part Positions", "Cosa non è esponibile"],
              notes="La regola architetturale più importante per chi aggiunge pagine.")

    S("Il pannello non legge il PLC: legge HMI_Data.",
      "Una sola struttura, un solo punto di mappatura, nessuna pagina che conosce "
      "il codice.",
      notes="È ciò che permette di rifare una pagina HMI senza toccare la logica di "
            "macchina.")

    B("La regola del canale unico", [
        (0, "Tutto ciò che il pannello vede è in HMI_Data (RETAIN, IsOpc = True)"),
        (1, "comandi scritti dal pannello, validati dal PLC"),
        (1, "status e feedback scritti dal PLC, sola lettura lato pannello"),
        (0, "Perché:"),
        (1, "cambiare l'HMI non richiede di cambiare la logica"),
        (1, "l'interfaccia si può versionare separatamente dal processo"),
        (1, "il pannello non può scrivere una variabile interna per errore"),
        (0, "Eccezione controllata:"),
        (1, "KPI_Data è pubblicata direttamente (solo lettura)"),
        (0, "Regola per aggiungere campi:"),
        (1, "prima il tipo in DT_HMI, poi la mappatura in HMI.pou, poi la pagina"),
    ], size=16,
       notes="Trappola: aggiungere una variabile al DataList senza mapparla in "
             "HMI.pou produce un nodo OPC sempre a zero.")

    C("Come si aggiunge un campo HMI (3 passi)", """// 1) DT_HMI.dt — dichiarazione nel tipo giusto
ST_HMI_Tracking : STRUCT
    WindowStart : LREAL;
    WindowEnd   : LREAL;
    BeltPos     : ARRAY[0..7] OF LREAL;
    ...
END_STRUCT

// 2) HMI.pou — mappatura (SlowTask, 32 ms)
HMI_Data.Tracking.WindowStart := vFeedIn_FrameOffset[1] + DATA_Machine.Setting.TrackingWindowStart;

// 3) DataList — HMI_Data ha IsOpc = True: il nodo OPC compare da solo""",
      size=11,
      caption="Nessun passaggio in più: ogni campo sotto HMI_Data è automaticamente visibile.",
      notes="Non serve registrare i singoli campi: si pubblica la radice.")

    T("Flag del DataList (estratto)", ["Variabile", "OPC", "RETAIN", "Motivo"], [
        ["HMI_Data", "Sì", "Sì", "canale unico pannello, impostazioni persistenti"],
        ["KPI_Data", "Sì", "Sì", "metriche consultabili anche da altri sistemi"],
        ["G_xCycleActive / G_bAutoCycleRunning", "Sì", "No", "indicatori di ciclo"],
        ["G_xKPI_ResetShift", "Sì", "No", "comando di reset turno"],
        ["MultiGrpProductData", "No", "No", "buffer grande: si pubblica solo il mirror"],
        ["MonitorStatusData", "No", "No", "dato interno del monitor prodotti"],
        ["DATA_Delta, DATA_FeedInAxis", "No", "No", "accesso diretto non necessario"],
    ], size=11.5, col_widths=[4.4, 1.2, 1.4, 5.0],
       notes="Se una variabile non è OPC, l'unico modo per vederla è copiarla in "
             "HMI_Data da un POU che vi accede.")

    B("HMI.pou: struttura tipica", [
        (0, "Sezioni, in ordine:"),
        (1, "1. comandi (HMI → PLC) con validazione di modo e sicurezza"),
        (1, "2. setting copiati nelle strutture DATA_*"),
        (1, "3. status (PLC → HMI): stati macchina, assi, gruppo, processo"),
        (1, "4. sezioni specifiche (Tracking, pagina Robot & Part Positions)"),
        (0, "Perché è lungo e piatto:"),
        (1, "un solo scrittore per campo, ordine di lettura prevedibile"),
        (1, "si legge dall'alto in basso come una tabella"),
        (0, "Costo accettato:"),
        (1, "righe ripetitive, in cambio della leggibilità"),
    ], size=16,
       notes="In iCube non esistono le regioni: i commenti a blocchi sono l'unico "
             "modo per orientarsi e vanno mantenuti.")

    B("Il ciclo di un comando: esempio MoveAbsolute", [
        (0, "1. Il pannello scrive HMI_Data.Axis.FeedIn.Command.MoveAbsolute"),
        (0, "2. HMI.pou valida:"),
        (1, "modo manuale, Safety_Button, nessun altro comando in corso"),
        (0, "3. Copia in DATA_FeedInAxis.Command.AbsPositioning"),
        (0, "4. FB_AxisController mappa su CMD_AbsPos e chiama MC_MoveAbsolute"),
        (0, "5. Il drive esegue; lo stato torna in DATA_FeedInAxis.Status"),
        (0, "6. HMI.pou copia in HMI_Data.Axis.FeedIn.Status"),
        (0, "Punto critico:"),
        (1, "la validazione va nel PLC, non nell'HMI"),
    ], size=16,
       notes="Il passo 2 è quello che manca più spesso nelle modifiche fatte di "
             "fretta.")

    B("Pagina 'Robot & Part Positions' — requisiti", [
        (0, "Mostra, tutto da HMI_Data:"),
        (1, "posa del TCP: X, Y, Z, Rx, Ry, Rz come scalari"),
        (1, "angoli dei giunti: S, L, U, T, B"),
        (1, "coda pezzi: X, Y, Rz, BELT, DIST. TO WINDOW, STATO (8 righe)"),
        (1, "prossimo pezzo da prendere + livello del buffer"),
        (1, "stato robot/sequencer e nome ricetta"),
        (0, "Perché scalari e non un VECTOR:"),
        (1, "l'accesso a elementi di VECTOR su OPC è fragile in JMobile"),
        (0, "Cosa NON è stato messo:"),
        (1, "punteggio visione (non esiste nel telegramma), indice di priorità inventato"),
    ], size=15,
       notes="Se un dato non esiste, non si inventa un KPI: meglio togliere la "
             "colonna che mostrare un numero senza significato.")

    T("Mappa tag della pagina", ["Blocco pagina", "Tag", "Sorgente PLC"], [
        ["TCP attuale", "HMI_Data.Robot.Feedback.TCP.X/Y/Z/Rx/Ry/Rz", "DATA_Delta.Status"],
        ["Giunti", "HMI_Data.Robot.Feedback.Joint[0..4]", "DATA_Delta.Status"],
        ["Robot status", "HMI_Data.Robot.Status.ErrorID", "DATA_Delta.Error"],
        ["Coda pezzi", "HMI_Data.Tracking.{X,Y,Rz,BeltPos,DistToWindow,State}[0..7]", "mirror MultiGrpProductData"],
        ["Buffer level", "HMI_Data.Tracking.BufferLevel", "UsePointer/StorePointer"],
        ["Finestra", "HMI_Data.Tracking.WindowStart / WindowEnd", "FrameOffset + Setting"],
        ["Prossimo target", "HMI_Data.Tracking.NextX / NextY / NextRz / NextDistToWindow", "mirror"],
        ["Velocità nastro", "HMI_Data.Tracking.BeltSpeedActual / Setpoint", "Feedback.ActualSpeed"],
        ["Stato processo", "HMI_Data.Process.Status.* (Step, RecipeName, TrackingActive)", "sequencer / HMI"],
    ], size=11, col_widths=[2.6, 6.4, 3.2],
       notes="Tutti i tag sono verificati come esistenti: nessun collegamento verso "
             "variabili non pubblicate.")

    B("Cosa non è esponibile (e perché)", [
        (0, "Punteggio / ClassID della visione:"),
        (1, "il telegramma VISOR contiene solo posizione, angolo e conteggio"),
        (0, "Tempo ciclo per singolo pezzo:"),
        (1, "esistono il tempo di pick e il tempo di ciclo, non per pezzo"),
        (0, "'Slot' di deposito numerico:"),
        (1, "il deposito è definito dal frame FeedOut, non da un indice"),
        (0, "Sensore 'B1':"),
        (1, "non esiste: ci sono DI0_4/6/7_Spare, GreenInputButton, YellowInputButton"),
        (0, "Conseguenza:"),
        (1, "servirebbe aggiungere sensori o cambiare il telegramma"),
    ], size=16,
       notes="La scelta di progetto è stata togliere i campi, non simularli.")

    S("Se l'HMI ha bisogno di un dato, quel dato deve esistere nel PLC.",
      "Altrimenti si aggiunge il sensore o si toglie il campo: mai inventare.",
      notes="È la lezione pratica della sezione HMI.")

    # ---------------------------------------------------------------- 14
    d.section("14", "Sicurezza",
              "Cosa è hardware, cosa è software, cosa non si può bypassare",
              topics=["Catene CH0/CH1", "STO", "Guard lock",
                      "Ruolo del PLC standard", "Sequenza E-stop"],
              notes="Sezione di confine: chiarire i limiti del software standard.")

    S("La sicurezza non è nel codice: il codice legge solo l'esito.",
      "Nessuna riga di Structured Text può escludere una catena di sicurezza.",
      notes="Slide da dire esplicitamente a chi pensa che 'basta mettere un IF'.")

    T("Segnali di sicurezza nel progetto", ["Segnale", "Tipo", "Uso nel software"], [
        ["safeEmergency_CH0 / CH1", "BOOL", "letto come E_Stop"],
        ["safeDeltaDoor_CH0 / CH1", "BOOL", "porta robot: consenso/guard lock"],
        ["safeCameraDoor_CH0 / CH1", "BOOL", "porta camera"],
        ["safePilzSTO_SL / _UB / _TInv / _Spare", "BOOL", "STO per gruppi di assi"],
        ["safeOutDeltaDoor / safeOutCameraDoor", "BOOL", "uscite guard lock"],
    ], size=12.5, col_widths=[4.6, 1.6, 5.8],
       notes="Catene ridondate CH0/CH1: il software standard ne legge l'esito "
             "consolidato.")

    B("STO e la differenza con 'power off'", [
        (0, "STO (Safe Torque Off):"),
        (1, "toglie la coppia senza togliere l'alimentazione"),
        (1, "il drive resta vivo e in comunicazione, il riavvio è immediato"),
        (0, "Power off (En_Power := FALSE):"),
        (1, "disabilitazione controllata dal software standard"),
        (1, "passa da UNPOWERING con timeout e verifica"),
        (0, "Perché servono entrambi:"),
        (1, "STO protegge le persone (hardware)"),
        (1, "power off è la sequenza di riposo della macchina (software)"),
        (0, "Errore comune:"),
        (1, "credere che una E-stop software fermi il robot: la coppia la toglie FSoE"),
    ], size=16,
       notes="La E-stop software serve per la logica (transizioni, log, HMI): non è "
             "il dispositivo di protezione.")

    B("Guard lock: chi apre e quando", [
        (0, "Regola:"),
        (1, "la porta resta bloccata finché l'uscita sicura safeOut*Door è attiva"),
        (1, "lo sblocco richiede macchina ferma e nessun movimento in corso"),
        (0, "Nel software standard:"),
        (1, "le uscite sicure sono pilotate dalla logica di sicurezza"),
        (1, "il PLC standard può solo leggere lo stato porta e bloccare i comandi"),
        (0, "Conseguenza per la manutenzione:"),
        (1, "se un comando non parte con porta aperta non è un bug: manca un consenso"),
        (0, "Diagnostica:"),
        (1, "stato porte e consensi nella pagina di sicurezza del pannello"),
    ], size=16,
       notes="In aula: far vedere il comportamento con porta aperta e servo ON per "
             "capire chi comanda cosa.")

    T("Cosa può e non può fare il PLC standard", ["Azione", "Possibile?", "Note"], [
        ["Leggere lo stato di una catena", "Sì", "solo come informazione"],
        ["Escludere una catena di sicurezza", "**No**", "compito dell'impianto FSoE"],
        ["Riavviare un drive dopo STO", "Sì", "se la catena è ripristinata"],
        ["Bloccare un comando HMI", "Sì", "validazione di modo/consenso"],
        ["Forzare un'uscita sicura", "**No**", "solo il programma di sicurezza"],
        ["Registrare l'evento", "Sì", "LogEvent / AddUpdateError"],
    ], size=12.5, col_widths=[5.0, 2.0, 5.2],
       notes="Tabella utile anche in audit: mostra che il confine è rispettato.")

    B("Sequenza E-stop vista dal software standard", [
        (0, "1. La catena si apre (hardware): STO su tutti i gruppi"),
        (0, "2. safeEmergency_CH0/CH1 arrivano come BOOL"),
        (0, "3. FB_MachineController rileva E_Stop nei gestori di stato"),
        (0, "4. Transizione a STOPPING (toglie comandi, arma group stop)"),
        (0, "5. Sequencer in NON esecuzione, visione disabilitata"),
        (0, "6. UNPOWERING → SHUTDOWN, con log di ogni passo"),
        (0, "Cosa si vede sul pannello:"),
        (1, "stato macchina, lista errori con timestamp, causa più recente"),
        (0, "Cosa non si vede:"),
        (1, "quale catena fisica ha ceduto: competenza del diagnostico FSoE"),
    ], size=16,
       notes="La cronologia nel buffer permette di ricostruire l'ordine degli eventi "
             "al millisecondo.")

    # ---------------------------------------------------------------- 15
    d.section("15", "Casi di studio",
              "Tre modifiche reali, lette come design review",
              topics=["Stop ciclo asimmetrico", "Finestra di tracking",
                      "Pagina HMI con dati inesistenti", "Metodo comune"],
              notes="La parte più formativa: come si ragiona su una modifica a "
                    "codice esistente.")

    S("Caso 1: il FeedIn impiegava molto più del FeedOut a fermarsi.",
      "Sintomo dell'operatore: 'lo stop ciclo è lento e sembra che il nastro in "
      "ingresso non risponda'.",
      notes="La causa è un parametro 'ottimizzato' in un punto solo del sistema.")

    B("Caso 1 — analisi", [
        (0, "Sintomo:"),
        (1, "allo Stop Cycle il FeedOut si ferma subito, il FeedIn no"),
        (1, "nessun errore: solo comportamento diverso"),
        (0, "Causa:"),
        (1, "i nastri in automatico sono in JOG → si fermano con JogDec"),
        (1, "HMI.pou mappava JogDec del FeedIn con MIN(CommandDeceleration, FeedIn_SmoothDeceleration)"),
        (1, "FeedIn_SmoothDeceleration usciva dal blocco di rampa (dec_min = 100)"),
        (1, "il FeedOut usa CommandDeceleration: da qui l'asimmetria"),
        (0, "Perché sembrava ragionevole:"),
        (1, "l'idea era che la decelerazione seguisse la rampa di velocità"),
        (1, "in realtà la rampa modula il setpoint, non la decelerazione"),
    ], size=15,
       notes="Un parametro 'adattivo' in un punto solo rompe un invariante globale: "
             "due nastri devono fermarsi uguali.")

    C("Caso 1 — prima e dopo", """// PRIMA (HMI.pou)
DATA_FeedInAxis.Setting.JogDec := MIN(HMI_Data.Axis.FeedIn.Setting.CommandDeceleration,
                                      FeedIn_SmoothDeceleration);

// DOPO (HMI.pou)
DATA_FeedInAxis.Setting.JogDec := HMI_Data.Axis.FeedIn.Setting.CommandDeceleration;

// FB_ConveyorController: la decelerazione non dipende piu' dalla zona
deceleration := dec_max;   // era: dec_min in zona 1, MAX(...) nelle fasi""",
      size=11,
      caption="La correzione è piccola: la diagnosi è stata la parte difficile.",
      notes="Metodo: confrontare i due percorsi di stop fino alla prima differenza. "
            "Il diff dei parametri JogDec è stato immediato.")

    S("Caso 2: la fine della rampa deve stare dentro la finestra di tracking.",
      "Il nastro si ferma a 450 mm, il tracking arriva a 500 mm: 50 mm di margine.",
      notes="50 mm a 50 mm/s sono circa un secondo di sicurezza per la presa.")

    B("Caso 2 — analisi", [
        (0, "Problema originale:"),
        (1, "il setpoint passava da v_nominal a v_min e poi a 0 'di colpo'"),
        (1, "con decelerazione minima il pezzo superava il punto di stop"),
        (0, "Conseguenza:"),
        (1, "il robot perdeva il sync, il ciclo andava in errore"),
        (1, "oppure il pezzo era preso 'di striscio' (errore di posizione)"),
        (0, "Correzione:"),
        (1, "rampa proporzionale negli ultimi 50 mm: setpoint a 0 sulla soglia"),
        (1, "zona 2 a velocità costante contro l'effetto pompa"),
        (1, "azzeramento secco sotto 1 mm per garantire il fermo"),
        (0, "Verifica:"),
        (1, "pezzo marcato: scostamento fra punto di stop e 450 mm ≤ pochi mm"),
    ], size=15,
       notes="Il margine di 50 mm è la vera specifica di progetto: va scritta nel "
             "documento di collaudo, non solo nei commenti.")

    C("La rampa finale, in tre righe", """d_remaining := tracking_end - distance;               // 0 .. 50 mm
ratio_end   := 1.0 - (d_remaining / ramp_margin);     // 0 .. 1
speed_setpoint := v_ramp_min * (1.0 - ratio_end);     // v_min .. 0
IF d_remaining < 1.0 THEN speed_setpoint := 0.0; END_IF""",
      size=12,
      caption="Continua per costruzione: nessun gradino nel setpoint, zero esatto sulla soglia.",
      notes="Esercizio in aula: disegnare il grafico velocità/distanza e verificare "
            "la pendenza (v_min / ramp_margin = 1 mm/s per mm).")

    S("Caso 3: la pagina HMI conteneva dati che il PLC non aveva.",
      "Punteggio visione, tempo ciclo per pezzo, indice di priorità: non esistono "
      "nel sistema.",
      notes="Un mockup grafico promette cose che il sistema non sa: va allineato "
            "prima di arrivare in reparto.")

    B("Caso 3 — analisi", [
        (0, "Origine:"),
        (1, "pagina disegnata come mockup, senza verificare i tag disponibili"),
        (0, "Verifica sul telegramma VISOR:"),
        (1, "solo X, Y, Rz per 4 pezzi e Part_Count"),
        (1, "nessun punteggio, nessuna classe, nessun tempo per pezzo"),
        (0, "Verifica sui moduli I/O:"),
        (1, "non esiste un ingresso 'B1'"),
        (0, "Decisione:"),
        (1, "togliere i campi, non sostituirli con valori inventati"),
        (1, "aggiungere invece coda pezzi, prossimo target, finestra"),
        (0, "Perché:"),
        (1, "un numero senza significato genera decisioni sbagliate"),
    ], size=15,
       notes="Se servisse il punteggio, la strada è cambiare il telegramma e la "
             "mappa dei byte: progetto, non patch.")

    T("Cosa è stato aggiunto alla pagina (con la sorgente)", ["Dato", "Sorgente", "Motivo"], [
        ["TCP X/Y/Z/Rx/Ry/Rz scalari", "HMI_Data.Robot.Feedback.TCP", "JMobile non digerisce bene i VECTOR"],
        ["Coda pezzi (8 righe)", "mirror di MultiGrpProductData", "variabile non OPC"],
        ["BeltPos per pezzo", "ActualPosition − RecordedPosition − OffsetCamera", "stessa formula della logica"],
        ["DistToWindow", "WindowStart − BeltPos (clampato a 0)", "rende visibile il margine"],
        ["Prossimo target", "UsePointer della coda", "anticipa cosa farà il robot"],
        ["Stato sequencer", "eCurrentStepName del sequencer", "istanza locale al manager"],
    ], size=11.5, col_widths=[3.2, 5.0, 4.0],
       notes="Ogni riga corrisponde a una decisione verificata sul codice, non a "
             "un'ipotesi.")

    B("Le tre lezioni dei casi di studio", [
        (0, "1. Un parametro 'adattivo' rompe un invariante:"),
        (1, "se due attori devono comportarsi uguale, il parametro deve essere uno"),
        (0, "2. La specifica fisica va scritta:"),
        (1, "'il pezzo non deve superare la finestra' è un requisito"),
        (1, "va tradotto in un margine numerico e verificato in collaudo"),
        (0, "3. Non si inventano dati:"),
        (1, "se il dato non esiste, si toglie il campo o si aggiunge il sensore"),
        (0, "Metodo comune:"),
        (1, "confrontare i percorsi, misurare, scrivere la specifica, poi correggere"),
    ], size=16,
       notes="Chiudere chiedendo ai partecipanti un caso reale e applicando lo stesso "
             "metodo.")

    # ---------------------------------------------------------------- 16
    d.section("16", "Procedure operative",
              "Avvio, commissioning, deploy e troubleshooting",
              topics=["Sequenza di avvio", "Teach frame", "Deploy",
                      "Troubleshooting in 6 passi", "Diagnostica rapida"],
              notes="La parte 'da manuale d'uso' per chi lavora sulla macchina.")

    T("Sequenza di avvio", ["Passo", "Stato", "Cosa deve essere vero"], [
        ["1", "INIT", "uscite di default, nessun comando armato"],
        ["2", "IDLE", "macchina in sicurezza, porte chiuse, E-stop non attiva"],
        ["3", "POWERING_UP", "servo che si abilitano, nessun allarme persistente"],
        ["4", "HOMING", "assi referenziati, posizione valida"],
        ["5", "WAIT_FOR_COMMISSIONING", "solo se richiesto: posizione manuale impostata"],
        ["6", "OPERATIONAL_MANUAL", "jog e teach disponibili con Safety_Button"],
        ["7", "OPERATIONAL_AUTOMATIC", "Start Cycle → nastri e sequencer"],
    ], size=12, col_widths=[0.9, 4.6, 6.7],
       notes="Il passaggio 5 è spesso frainteso: non è un errore, è una scelta per la "
             "messa in servizio.")

    B("Procedura di teach frame", [
        (0, "Preparazione:"),
        (1, "macchina in MANUAL, servo ON (o free-drag con servo OFF)"),
        (1, "pezzo di riferimento posizionato nel frame"),
        (0, "Esecuzione:"),
        (1, "selezionare il frame (FeedIn = aTeachFrame[1], FeedOut = aTeachFrame[2])"),
        (1, "TCP su OO → ConfirmPoint; su XX → ConfirmPoint; su XY → ConfirmPoint"),
        (0, "Verifica:"),
        (1, "controllare il frame calcolato prima di uscire dallo stato"),
        (1, "fare un pick a vuoto e misurare lo scostamento"),
        (0, "Errori tipici:"),
        (1, "punti troppo vicini, punti non complanari, conferma con doppio fronte"),
    ], size=16,
       notes="Distanza minima consigliata fra OO e XX: almeno 100 mm per un buon "
             "condizionamento numerico.")

    B("Deploy e versionamento", [
        (0, "Flusso iCube:"),
        (1, "modifica → build → download; verificare i warning prima del download"),
        (0, "Prima del deploy:"),
        (1, "backup del progetto e dei parametri drive"),
        (1, "annotare la versione in CHANGELOG.pou"),
        (0, "Nel repository:"),
        (1, "un branch per modifica, un commit descrittivo, una PR"),
        (1, "il messaggio dice cosa cambia e perché, non solo 'fix'"),
        (0, "Dopo il deploy:"),
        (1, "power-up, homing, un ciclo manuale, un ciclo automatico"),
        (1, "controllo del buffer errori e dei KPI di turno"),
    ], size=16,
       notes="Il changelog è un POU: è visibile anche in iCube senza aprire il "
             "repository.")

    C("CHANGELOG.pou — convenzione di versione", """v_0.08.05 - HMI: dati completi per la pagina 'Robot & Part Positions'
  + HMI_Data.Tracking: mirror della coda prodotti (8 righe)
  + scalari TCP per compatibilita' JMobile
  ~ OffsetCamera e finestre da DT_Machine.Setting (unica sorgente)

v_0.08.04 - Nastro: rampa continua e decelerazione unica
  + FB_ConveyorController: 4 zone, v_min costante, rampa finale
  ~ JogDec FeedIn = CommandDeceleration

v_0.08.03 - Fix stop ciclo FeedIn
  - rimosso MIN(CommandDeceleration, SmoothDeceleration)""", size=10.5,
      caption="Formato: versione, area, elenco con + aggiunte / ~ modifiche / − rimosse.",
      notes="Una voce per modifica funzionale, non per file toccato.")

    B("Troubleshooting in 6 passi", [
        (0, "1. Dove si è fermato il ciclo?"),
        (1, "HMI_Data.Process.Status.Step → nome dello step corrente"),
        (0, "2. In che stato è la macchina?"),
        (1, "OPERATIONAL, STOPPING, ERROR"),
        (0, "3. C'è un errore attivo?"),
        (1, "severità, sorgente, timestamp; poi il codice allarme del drive"),
        (0, "4. Gli assi sono abilitati e referenziati?"),
        (1, "ServoOn, Homed, Enabled"),
        (0, "5. Il dato di ingresso è coerente?"),
        (1, "coda pezzi, posizione latchata, connessione visione"),
        (0, "6. Solo ora il codice:"),
        (1, "il metodo dello step, il dispatcher, il driver di motion"),
    ], size=15,
       notes="Dal sintomo al codice, mai dal codice al sintomo: il codice conferma, "
             "non scopre.")

    T("Diagnostica rapida per sintomo", ["Sintomo", "Prima verifica", "Poi"], [
        ["Non parte il ciclo", "stato macchina e modo", "G_bAutoCycleRunning, comandi HMI"],
        ["Ciclo fermo su uno step", "Step su HMI", "metodo dello step, FB che deve dare Done"],
        ["Pezzo preso male", "frame e offset", "tracking, latch, Rz"],
        ["Nastro non si ferma in tempo", "v_min, end_zone_margin", "OffsetCamera, finestra"],
        ["Servo non si abilita", "catena sicurezza, allarme drive", "En_Power, reset allarmi"],
        ["HMI non aggiorna", "SlowTask, watchdog", "mappatura in HMI.pou, IsOpc"],
        ["KPI a zero", "contatori G_, reset turno", "FB_KPI, delta e old"],
        ["Doppio pick non eseguito", "modo doppio selezionato", "step 0, SelectNextProduct"],
    ], size=11.5, col_widths=[3.6, 4.0, 4.6],
       notes="Tabella da stampare e tenere in armadio elettrico.")

    # ---------------------------------------------------------------- 17
    d.section("17", "Debito tecnico e roadmap",
              "Cosa migliorare, in che ordine e con quale rischio",
              topics=["Debito riconosciuto", "Tre priorità", "Roadmap",
                      "Glossario", "Dove trovare le cose"],
              notes="Chiusura costruttiva: il progetto è solido, ma con punti noti.")

    T("Debito tecnico riconosciuto", ["Voce", "Rischio", "Priorità"], [
        ["Delta UDINT negativi dopo riavvio", "KPI errati", "**Alta**"],
        ["Limiti di pick/place commentati", "movimento fuori area", "**Alta**"],
        ["Nessun test automatico / simulazione", "regressioni invisibili", "**Alta**"],
        ["Parametri di rampa hardcoded in PickPlaceManager", "difficili da tarare", "Media"],
        ["Molti AddUpdateError/CheckAndEnqueue commentati", "diagnostica incompleta", "Media"],
        ["Doppia copia della formula distanza (logica + HMI)", "rischio divergenza", "Media"],
        ["Teach senza validazione geometrica", "frame mal condizionati", "Bassa"],
        ["Codice legacy commentato nel blocco di rampa", "confusione", "Bassa"],
    ], size=12, col_widths=[5.6, 4.0, 1.8],
       notes="Nessuna voce è un difetto grave oggi: sono attriti che costano tempo in "
             "manutenzione.")

    B("Le tre priorità consigliate", [
        (0, "1. Proteggere i KPI dal riavvio:"),
        (1, "clamp dei delta negativi o inizializzazione coerente degli old"),
        (0, "2. Ripristinare i controlli di limite:"),
        (1, "verificare X/Y/Rz contro LimitPos prima del pick"),
        (1, "evita prese fuori area con possibile collisione"),
        (0, "3. Portare i parametri di rampa in DT_Machine:"),
        (1, "v_min, end_zone_margin, acc_min/dec_min come setting"),
        (1, "taratura senza rebuild"),
        (0, "Metodo:"),
        (1, "una modifica per volta, con changelog e verifica in manuale"),
    ], size=16,
       notes="Ordinare per rapporto impatto/rischio, non per 'quanto è bello'.")

    T("Roadmap proposta (6-12 mesi)", ["Orizzonte", "Attività", "Output"], [
        ["Breve", "clamp KPI, controlli limite, parametri in DT_Machine", "v_0.09.x"],
        ["Breve", "pulizia codice legacy e commenti morti", "leggibilità"],
        ["Medio", "categorie di fermata per il calcolo OEE", "report turno"],
        ["Medio", "rate-limiter e pareto errori lato HMI", "diagnostica"],
        ["Medio", "simulazione su asse virtuale per test di sequenza", "test ripetibili"],
        ["Lungo", "telegramma visione esteso (classe/punteggio)", "selezione pezzi"],
        ["Lungo", "validazione geometrica del teach frame", "setup più sicuro"],
    ], size=12, col_widths=[1.8, 7.4, 3.0],
       notes="La simulazione è già possibile: VIRTUAL_AXIS esiste ed è abilitato come "
             "gli altri assi.")

    T("Glossario essenziale", ["Termine", "Significato"], [
        ["TCP", "Tool Center Point: punto di lavoro del robot"],
        ["PCS / MCS / WCS", "sistemi di coordinate: pezzo / macchina / mondo"],
        ["Delta (gruppo)", "cinematica parallela a 5 assi S L U T B"],
        ["FeedIn / FeedOut (CI/CO)", "nastri di ingresso e uscita"],
        ["Tracking", "inseguimento del pezzo in movimento"],
        ["Latch / touch probe", "cattura hardware della posizione a un evento"],
        ["Blend", "fusione di più movimenti consecutivi"],
        ["STO / FSoE", "Safe Torque Off / Fail Safe over EtherCAT"],
        ["OPC UA / DataList", "esposizione delle variabili al pannello"],
        ["RETAIN", "persistenza oltre il power cycle"],
    ], size=11.5, col_widths=[3.4, 8.6],
       notes="Glossario per chi arriva da un'altra macchina: molti termini sono "
             "specifici del mondo Yaskawa/iCube.")

    B("Dove trovare le cose nel progetto", [
        (0, "Macchina:"),
        (1, "FB_MachineController + i suoi 11 metodi"),
        (0, "Ciclo:"),
        (1, "FB_PickPlace_Sequencer1 (motore, dispatcher, playlist, step)"),
        (0, "Nastro:"),
        (1, "FB_ConveyorController + PickPlaceManager + Init.pou"),
        (0, "Visione:"),
        (1, "VisionManager + FB_VisionApplication + FB_VisorDriver"),
        (0, "Interfaccia:"),
        (1, "DT_HMI.dt + HMI.pou + DataList"),
        (0, "Storia:"),
        (1, "CHANGELOG.pou e la storia git del repository"),
    ], size=16,
       notes="È il riassunto operativo di tutto il corso.")

    S("Il codice racconta le decisioni: leggerlo è la formazione.",
      "Ogni commento esteso nel progetto è un pezzo di questa storia.",
      notes="Invitare a leggere i commenti in testa a FB_ConveyorController e "
            "PickPlaceManager come esempio di documentazione nel codice.")
