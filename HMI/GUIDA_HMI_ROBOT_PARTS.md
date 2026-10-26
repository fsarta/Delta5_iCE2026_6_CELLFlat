# Pagina HMI "Robot & Part Positions" — mappa dei tag

Riferimento per il collegamento della pagina `robot parts.jmx` (JMobile) ai tag OPC UA del
progetto `Delta5_iCE2026_6_CELLFlat`.

Regola base di questa architettura: **solo i global marcati `IsOpc = True` nel DataList
(`CFG_DAD2D28`) sono visibili al pannello**. Sono:

| Global | Pubblicato | Uso |
|---|---|---|
| `HMI_Data` (`ST_HMI_Interface`) | sì (RETAIN) | **unico canale HMI** |
| `KPI_Data` (`ST_KPI_Data`) | sì | KPI di turno |
| `MultiGrpProductData` | **no** | coda prodotti visione |
| `MonitorStatusData` | **no** | stato monitor prodotti |

Per questo la coda prodotti non è leggibile direttamente: `HMI.pou` ne costruisce un mirror
in `HMI_Data.Tracking` (sezione "TRACKING · CODA PEZZI FEEDIN").

---

## 1. Header / stato cella

| Elemento pagina | Tag OPC UA | Note |
|---|---|---|
| pill RUNNING | `HMI_Data.Dashboard.Status.IsRunning` | stato `OPERATIONAL_AUTOMATIC` |
| pill AUTO | `HMI_Data.Dashboard.Status.IsAutoMode` | |
| recipe VITI_M6 | `HMI_Data.Process.Status.RecipeName` | WSTRING; etichetta, nessuna gestione ricette nel progetto (valore impostato in `Init.pou`) |
| clock | — | orologio del pannello |
| stato macchina esteso | `HMI_Data.Dashboard.Status.State_MachineController` | enum `E_MachineState` |
| stato macchina (numerico) | `HMI_Data.Process.Status.CurrentState` | 0..11, vedi `FB_KPI` |

## 2. Card "ROBOT · TCP POSITION (MCS)"

| Elemento | Tag | Note |
|---|---|---|
| X [mm] | `HMI_Data.Robot.Feedback.TCP.X` | |
| Y [mm] | `HMI_Data.Robot.Feedback.TCP.Y` | |
| Z [mm] | `HMI_Data.Robot.Feedback.TCP.Z` | |
| Rx [deg] | `HMI_Data.Robot.Feedback.TCP.Rx` | |
| Ry [deg] | `HMI_Data.Robot.Feedback.TCP.Ry` | |
| Rz [deg] | `HMI_Data.Robot.Feedback.TCP.Rz` | |
| STATE | `HMI_Data.Process.Status.Step` | enum `E_PickPlace_State` (testo) |
| STATE (numerico) | `HMI_Data.Process.Status.StepId` | valori enum: 100 CheckPickLimits, 400 EnablePickTracking, 500 ApproachPick, 600 WaitForPickSync, 700 DescendAndPick, 2400 EnablePlaceTracking… 2900 CycleCompletition |

I VECTOR originali (`HMI_Data.Robot.Feedback.Linear_Position`) restano disponibili ma molti
client non leggono gli elementi di un VECTOR: usare gli scalari qui sopra.

## 3. Card "JOINTS · S L U T B"

| Elemento | Tag |
|---|---|
| S | `HMI_Data.Robot.Feedback.Joint[0]` |
| L | `HMI_Data.Robot.Feedback.Joint[1]` |
| U | `HMI_Data.Robot.Feedback.Joint[2]` |
| T | `HMI_Data.Robot.Feedback.Joint[3]` |
| B | `HMI_Data.Robot.Feedback.Joint[4]` |

## 4. Tabella "PARTS TO PICK · TRACKING QUEUE"

Righe disponibili: **8** (`[0..7]`), dalla più vecchia (= prossima al prelievo) alla più recente.
`Count` dice quante righe sono valide (`Valid[i]`).

| Colonna | Tag | Note |
|---|---|---|
| # | `HMI_Data.Tracking.Id[i]` | indice del pezzo nell'anello della coda |
| X [mm] | `HMI_Data.Tracking.X[i]` | vision X |
| Y [mm] | `HMI_Data.Tracking.Y[i]` | vision Y |
| Rz [deg] | `HMI_Data.Tracking.Rz[i]` | vision Rz |
| BELT [mm] | `HMI_Data.Tracking.BeltPos[i]` | mm percorsi sul nastro: confrontabile con `WindowStart` / `WindowEnd` |
| DIST. TO WINDOW [mm] | `HMI_Data.Tracking.DistToWindow[i]` | 0 se già in finestra |
| STATO | `HMI_Data.Tracking.State[i]` | 0 QUEUED · 1 IN_WINDOW · 2 TRACKING · 3 PAST |
| (riga valida) | `HMI_Data.Tracking.Valid[i]` | |

> **Colonna SCORE %: rimossa.** Il telegramma VISOR non fornisce alcun punteggio di qualità
> (né ClassID): un valore inventato sarebbe fuorviante in produzione.

Riferimenti finestra / nastro:

| Tag | Significato |
|---|---|
| `HMI_Data.Tracking.WindowStart` | inizio fascia di prelievo (frame FeedIn + 300 mm) |
| `HMI_Data.Tracking.WindowEnd` | nastro fermo (frame FeedIn + 450 mm) |
| `HMI_Data.Tracking.BeltSpeedSetpoint` | setpoint velocità nastro (`FeedIn_SmoothSpeed`) |
| `HMI_Data.Tracking.BeltSpeedActual` | velocità reale nastro [mm/s] |
| `HMI_Data.Tracking.BufferLevel` | pezzi totali in coda nel buffer (0..150) |
| `HMI_Data.Tracking.Count` | righe valide nella tabella (0..8) |

## 5. Card "NEXT PICK TARGET"

| Elemento | Tag |
|---|---|
| validità | `HMI_Data.Tracking.NextValid` |
| X [mm] | `HMI_Data.Tracking.NextX` |
| Y [mm] | `HMI_Data.Tracking.NextY` |
| Rz [deg] | `HMI_Data.Tracking.NextRz` |
| id pezzo | `HMI_Data.Tracking.NextId` |
| BELT [mm] | `HMI_Data.Tracking.NextBeltPos` |
| mm all'ingresso in finestra | `HMI_Data.Tracking.NextDistToWindow` |

Criterio di scelta (in `HMI.pou`):
1. il pezzo **in finestra** più avanti (il più vicino a `WindowEnd`);
2. se nessuno è in finestra, il pezzo in coda più avanti (il primo che entrerà).

Per il testo "entra in finestra tra ~x s" usare `NextDistToWindow / BeltSpeedActual`
(con `BeltSpeedActual > 0`).

## 6. Altri dati utili già presenti

| Tag | Significato |
|---|---|
| `HMI_Data.Process.Status.PickedCount` / `PlacedCount` | contatori turno |
| `HMI_Data.Process.Status.TrackingActive` | tracking attivo |
| `HMI_Data.Dashboard.Status.CurrentSpeed` | velocità nastro [mm/s] (KPI) |
| `HMI_Data.Axis.FeedIn.Status.*` | stato asse FeedIn |
| `HMI_Data.Vision.Status.*` / `LastProduct.*` | stato visione |

---

## Note di implementazione

- **Dove viene popolato**: `HMI.pou` (programma `HMI1`, `SlowTask` 32 ms). Nessun impatto sulle
  task di movimento (`FastTask` / `MediumTask`).
- **Geometria unica**: gli offset della finestra (`300` / `450` mm) sono in un solo posto,
  `DATA_Machine.Setting.TrackingWindowStart/End` (inizializzati in `Init.pou`), e sono usati sia
  da `PickPlaceManager` (rampa nastro) sia da `HMI.pou` (mirror HMI): pagina e logica non
  possono divergere.
- **`BeltPos`** = `DATA_FeedInAxis.Feedback.ActualPosition − RecordedPosition − OffsetCamera`,
  cioè la stessa grandezza di `MonitorStatusData[0].DistanceFromOrigin[1] − OffsetCamera` che
  `PickPlaceManager` passa a `FB_ConveyorController` per il pezzo in uso.
- **`Step`** viene copiato in `PickPlaceManager`, perché l'istanza `FB_PickPlace_Sequencer1` è
  locale a quel programma.
- **Memoria RETAIN**: `HMI_Data` è retentiva; la tabella è limitata a 8 righe per non appesantire
  l'area ritentiva.
- **Dopo il build**: essendo cambiati i tipi di `ST_HMI_Interface`, va riesportata la tag list in
  JMobile (i nodi OPC UA nuovi compaiono sotto `HMI_Data/Tracking/...`).
