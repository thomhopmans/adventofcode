from pathlib import Path


def load_data(exercise):
    path = Path(__file__).parent /  "inputs" / f"exercise{exercise}.txt"
    with open(path, "r", encoding="utf-8") as handle:
        lines = handle.read()
    return lines
