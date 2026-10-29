# Presentazione di training — Delta5 iCE2026_6 CELL

Deck di formazione tecnica sul software di macchina del progetto: architettura,
specifiche, scelte di progetto e procedure operative.

| File | Contenuto |
|---|---|
| `Delta5_iCE2026_6_CELL_Training.pptx` | la presentazione (16:9, note del relatore su ogni slide) |
| `INDICE.md` | indice con il numero di slide di ogni sezione |
| `build.py` | genera il `.pptx` |
| `deck_lib.py` | motore di impaginazione (copertina, sezioni, bullet, tabelle, codice) |
| `content_main.py` | contenuto delle sezioni 00-17 |
| `content_cards.py` | appendici A-D: schede POU, schede step, esercizi, riferimento |
| `tools.py` | rigenera `INDICE.md` e verifica che nessun testo esca dalla slide |

## Come si rigenera

```bash
pip install python-pptx
python3 docs/presentazione/build.py     # scrive il .pptx
python3 docs/presentazione/tools.py     # aggiorna INDICE.md e controlla il layout
```

Il testo delle slide si modifica nei file `content_*.py`: ogni voce è una tupla
`(livello, testo)` nei bullet, oppure una riga di tabella, oppure un blocco di
codice. Le note del relatore sono il parametro `notes`.

## Struttura

- **00-05** contesto: sistema, runtime (task, priorità, watchdog), hardware e
  fieldbus, organizzazione del software, dati e tipi/OPC UA
- **06-09** il cuore: macchina a stati, assi e gruppo, sequencer pick & place,
  tracking e controllo nastri
- **10-13** servizi trasversali: visione, gestione errori, KPI, HMI
- **14-17** sicurezza, casi di studio (design review), procedure operative,
  debito tecnico e roadmap
- **A-D** appendici: schede POU, schede step, esercizi d'aula, riferimento rapido

## Note di manutenzione

- I valori citati (300/450/500 mm, `v_min` 50 mm/s, `end_zone_margin` 50 mm,
  `OffsetCamera` 750 mm, EndDistance 200 mm sul FeedOut, soglie KPI) sono quelli
  del codice alla versione **v_0.08.05**: se cambiano in `Init.pou` o in
  `PickPlaceManager`, vanno aggiornati qui.
- Il deck cita il file legacy e le parti commentate: sono volutamente descritte
  come non attive, per evitare che vengano lette come codice in esercizio.
