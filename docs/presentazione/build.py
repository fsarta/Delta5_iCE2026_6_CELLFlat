"""build.py — genera la presentazione di training Delta5_iCE2026_6_CELLFlat.

Uso:  python3 docs/presentazione/build.py
Output: docs/presentazione/Delta5_iCE2026_6_CELL_Training.pptx
Requisiti: python-pptx (pip install python-pptx)
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from deck_lib import Deck          # noqa: E402
import content_main                # noqa: E402
import content_cards               # noqa: E402

OUT = os.path.join(HERE, "Delta5_iCE2026_6_CELL_Training.pptx")


def main():
    d = Deck("Delta5 iCE2026_6 CELL")
    d.cover(
        "Delta5 iCE2026_6 CELL",
        "Formazione tecnica sul software di macchina: architettura, specifiche e "
        "scelte di progetto",
        [
            "Controller iC9226M-FSoE · iCube Engineer 2025.6 (build 7.2.38936.0)",
            "Cella robotizzata Delta 5 assi, due nastri servo, visione SensoPart VISOR",
            "Documento basato sul codice del progetto (v_0.08.05)",
            "18 sezioni + 4 appendici · percorso consigliato: 2 giornate",
        ],
        notes="Training interno. Obiettivo: rendere autonomi i partecipanti nella "
              "lettura e nella modifica del progetto. Ogni slide ha note del "
              "relatore con i riferimenti al codice.")

    content_main.add(d)
    content_cards.add(d)

    d.statement("Domande, dubbi, casi reali: la formazione continua in reparto.",
                "Materiale: il progetto stesso, la sua storia git e il CHANGELOG.",
                notes="Raccogliere i casi reali dei partecipanti per la prossima "
                      "sessione.")

    n = d.save(OUT)
    print("OK:", OUT, "->", n, "slide")


if __name__ == "__main__":
    main()
