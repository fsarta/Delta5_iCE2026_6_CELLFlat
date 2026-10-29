# Indice della presentazione

`Delta5_iCE2026_6_CELL_Training.pptx` — 235 slide 16:9, note del relatore su ogni slide.

- 1. Copertina

## 00 · Premessa e percorso   (da slide 2)
- 3. Obiettivo della formazione
- 4. Indice delle sezioni
- 5. Convenzioni sul codice

## 01 · Il sistema   (da slide 6)
- 7. La macchina in una slide
- 8. Flusso fisico del prodotto
- 9. Requisiti e vincoli di progetto
- 10. Attori e periferiche
- 11. Il nastro non si ferma mai: il robot deve inseguirlo.

## 02 · Architettura di runtime   (da slide 12)
- 13. Controller e risorse
- 14. I 6 task: priorità e tempi
- 15. Programmi e assegnazione ai task
- 16. Perché questa ripartizione
- 17. Watchdog: perché i tempi sono stretti
- 18. Regola: ogni variabile ha un solo scrittore.

## 03 · Hardware e fieldbus   (da slide 19)
- 20. Nodi EtherCAT
- 21. Le due reti principali
- 22. Il telegramma della telecamera (Main.pou)
- 23. SliceBus e sicurezza
- 24. Assi e gruppi nel codice
- 25. File di configurazione

## 04 · Organizzazione del software   (da slide 26)
- 27. Alberatura (Logical Elements)
- 28. Le quattro macro-aree
- 29. Perché i PROGRAM sono sottili
- 30. Residui e Recycle Bin: cosa NON è codice attivo

## 05 · Dati, tipi e interfaccia OPC UA   (da slide 31)
- 32. Dove sono definiti i tipi
- 33. ST_HMI_Interface — la radice dell'interfaccia
- 34. Comando vs Stato
- 35. Setting vs Command
- 36. DT_Machine — parametri di macchina
- 37. Flag del DataList
- 38. RETAIN: cosa significa in pratica
- 39. Enumerativi principali
- 40. I numeri distanziati negli enum sono spazio per crescere, non pigrizia.

## 06 · La macchina a stati   (da slide 41)
- 42. Il pattern fondamentale
- 43. L'ossatura del FB (STATE_MACHINE.st)
- 44. Gli stati e i loro handler
- 45. Diagramma degli stati
- 46. HandleIdleState — pronta ma ferma
- 47. HandlePowerUpState — dare potenza in sicurezza
- 48. HandleHomingState — referenziare gli assi
- 49. HandleCommissioningState — messa in posizione
- 50. HandleAutomaticState — il cuore produttivo
- 51. HandleManualState — jog e posizionamento
- 52. HandleStoppingState — arresto controllato
- 53. HandleUnpoweringState / HandleShutdownState
- 54. HandleErrorState — diagnosi e recupero
- 55. HandleTeachFrameState — calibrazione 3 punti
- 56. Priorità delle transizioni in AUTOMATICO
- 57. Ogni attesa ha un timeout, ogni transizione un log.

## 07 · Assi e gruppo cinematico   (da slide 58)
- 59. FB_AxisController: la catena di mapping
- 60. Mapping in ingresso (MAPPING_In.st)
- 61. MOTION.st — i FB PLCopen chiamati
- 62. Jog vs Posizionamento
- 63. Il comando di velocità del FeedIn (HMI.pou)
- 64. FB_GroupController e il sequencer
- 65. Blend ring buffer: perché 4 blocchi
- 66. Il ciclo dei blocchi (M_Driver_Motion_Cmd)
- 67. MC_TrackConveyorBelt: i parametri che contano
- 68. Diagnostica di asse: cosa guardare

## 08 · Il sequencer Pick & Place   (da slide 69)
- 70. Il sequencer non è un CASE monolitico: è una playlist eseguita da un dispatcher.
- 71. M_ConfigSequence_Run — la playlist
- 72. Perché una playlist e non un CASE
- 73. Il motore del sequencer
- 74. Il motore: stati e flag
- 75. M_Dispatcher — il ponte fra playlist e metodi
- 76. M_Driver_Motion_Cmd — l'unica porta verso il motion
- 77. M_Driver_Motion_Check — come uno step sa di aver finito
- 78. Il pattern di uno step
- 79. Fase PICK: gli step 0-6
- 80. Step 1-2: coda e offset gripper
- 81. Step 5-6: PCS e aggancio al nastro
- 82. Step 7-10: avvicinamento, presa, risalita
- 83. Step 11-12: uscita dal pick
- 84. Fase PLACE: gli step 13-18
- 85. Fase PLACE: gli step 19-23
- 86. Playlist di servizio: parking e abort
- 87. M_ResetMachine — il reset pulito
- 88. I 43 metodi del sequencer, per famiglia
- 89. Come aggiungere uno step
- 90. Errori tipici nel sequencer

## 09 · Tracking e controllo nastri   (da slide 91)
- 92. Il nastro non deve mai portare il pezzo fuori dalla finestra di tracking.
- 93. Le soglie del sistema
- 94. La formula della distanza (unica per la macchina)
- 95. Le quattro zone del controllo nastro
- 96. FB_ConveyorController — la scelta delle zone
- 97. Perché la zona 2 è costante
- 98. La rampa finale e il fermo garantito
- 99. La decelerazione è una sola per i due nastri: quella impostata in HMI.
- 100. Reti di sicurezza del blocco
- 101. Come si regola la legge del nastro
- 102. Sintomi e cause sul controllo nastro

## 10 · Catena di visione   (da slide 103)
- 104. La posizione del pezzo non è 'dov'è il nastro adesso', ma 'dov'era quando la telecamera ha scattato'.
- 105. Perché trigger fisico e posizione latchata
- 106. Latch e trigger in VisionManager
- 107. Trigger su distanza
- 108. Telegramma VISOR: mappa dei byte
- 109. Conversione byte → REAL
- 110. Dal risultato grezzo al pezzo in coda
- 111. Opzioni di distribuzione (PartOptions)
- 112. Contatori di visione
- 113. Guasti tipici della visione

## 11 · Gestione errori   (da slide 114)
- 115. Il modello: un buffer circolare globale
- 116. AddUpdateError — la logica di deduplica
- 117. Perché la deduplica è indispensabile
- 118. Le severità e cosa comportano
- 119. LogEvent vs AddUpdateError vs CheckAndEnqueue
- 120. Update — reset e acknowledge
- 121. ErrorManager e diagnosi del motion
- 122. Un allarme che si ripete ogni ciclo non è un errore: è un difetto di progetto.

## 12 · KPI e metriche   (da slide 123)
- 124. Architettura dei contatori
- 125. Perché i contatori globali richiedono i delta
- 126. KPI di produzione
- 127. KPI di tempo
- 128. Distribuzione del tempo per stato
- 129. Disponibilità e OEE: cosa manca
- 130. Reset turno: cosa azzera e cosa no

## 13 · HMI e interfaccia operatore   (da slide 131)
- 132. Il pannello non legge il PLC: legge HMI_Data.
- 133. La regola del canale unico
- 134. Come si aggiunge un campo HMI (3 passi)
- 135. Flag del DataList (estratto)
- 136. HMI.pou: struttura tipica
- 137. Il ciclo di un comando: esempio MoveAbsolute
- 138. Pagina 'Robot & Part Positions' — requisiti
- 139. Mappa tag della pagina
- 140. Cosa non è esponibile (e perché)
- 141. Se l'HMI ha bisogno di un dato, quel dato deve esistere nel PLC.

## 14 · Sicurezza   (da slide 142)
- 143. La sicurezza non è nel codice: il codice legge solo l'esito.
- 144. Segnali di sicurezza nel progetto
- 145. STO e la differenza con 'power off'
- 146. Guard lock: chi apre e quando
- 147. Cosa può e non può fare il PLC standard
- 148. Sequenza E-stop vista dal software standard

## 15 · Casi di studio   (da slide 149)
- 150. Caso 1: il FeedIn impiegava molto più del FeedOut a fermarsi.
- 151. Caso 1 — analisi
- 152. Caso 1 — prima e dopo
- 153. Caso 2: la fine della rampa deve stare dentro la finestra di tracking.
- 154. Caso 2 — analisi
- 155. La rampa finale, in tre righe
- 156. Caso 3: la pagina HMI conteneva dati che il PLC non aveva.
- 157. Caso 3 — analisi
- 158. Cosa è stato aggiunto alla pagina (con la sorgente)
- 159. Le tre lezioni dei casi di studio

## 16 · Procedure operative   (da slide 160)
- 161. Sequenza di avvio
- 162. Procedura di teach frame
- 163. Deploy e versionamento
- 164. CHANGELOG.pou — convenzione di versione
- 165. Troubleshooting in 6 passi
- 166. Diagnostica rapida per sintomo

## 17 · Debito tecnico e roadmap   (da slide 167)
- 168. Debito tecnico riconosciuto
- 169. Le tre priorità consigliate
- 170. Roadmap proposta (6-12 mesi)
- 171. Glossario essenziale
- 172. Dove trovare le cose nel progetto
- 173. Il codice racconta le decisioni: leggerlo è la formazione.

## A · Appendice A · schede POU   (da slide 174)
- 175. FB_MachineController
- 176. FB_PickPlace_Sequencer1
- 177. FB_GroupController
- 178. FB_AxisController
- 179. FB_ErrorHandler
- 180. FB_KPI
- 181. FB_VisionApplication
- 182. FB_VisorDriver
- 183. FB_ConveyorController
- 184. FB_TeachFrame
- 185. FB_RotatePosition
- 186. MyFormatProductData
- 187. McePosTable
- 188. HMI.pou
- 189. PickPlaceManager.pou
- 190. VisionManager.pou
- 191. Main.pou
- 192. IO.pou
- 193. Init.pou

## B · Appendice B · schede step   (da slide 194)
- 195. M_Step_Initialize
- 196. M_Step_CheckPickLimits
- 197. M_Step_CalcPickOffset
- 198. M_Step_SetPickFrame_Tracking
- 199. M_Step_ConvertPickToCartesian_Tracking
- 200. M_Step_SetPickOffsetAndPCS_Tracking
- 201. M_Step_EnablePickTracking
- 202. M_Step_ApproachPick_Tracking
- 203. M_Step_WaitForPickSync
- 204. M_Step_DescendAndPick
- 205. M_Step_AscendAfterPick
- 206. M_Step_MoveToParking_AfterPick
- 207. M_Step_SelectNextProduct_Pick
- 208. M_Step_InitializePlace
- 209. M_Step_SetPlaceFrame_Tracking
- 210. M_Step_ConvertPlaceToCartesian_Tracking
- 211. M_Step_EnablePlaceTracking
- 212. M_Step_ApproachPlace_Tracking
- 213. M_Step_WaitForPlaceSync
- 214. M_Step_DescendAndPlace
- 215. M_Step_WaitAfterPlace_Tracking
- 216. M_Step_AscendAfterPlace
- 217. M_Step_MoveToParking_AfterPlace
- 218. M_Step_CycleCompletitionAndChangeMode
- 219. M_Step_InitParking
- 220. M_Step_MoveToParking_SafePosition
- 221. M_Step_FinalParkingCompletition
- 222. M_Step_Error
- 223. M_Step_StartMovePath
- 224. Riepilogo: esiti attesi per step

## C · Appendice C · esercizi in aula   (da slide 225)
- 226. Esercizi 1-2: lettura e tracciamento
- 227. Esercizi 3-4: parametri e diagnosi
- 228. Esercizi 5-6: codice e modifiche
- 229. Esercizi 7-8: interfaccia e KPI

## D · Appendice D · riferimento rapido   (da slide 230)
- 231. Variabili globali più usate
- 232. Unità e convenzioni
- 233. Prefissi e suffissi
- 234. Indice dei file più consultati
- 235. Domande, dubbi, casi reali: la formazione continua in reparto.
