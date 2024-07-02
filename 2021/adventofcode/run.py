import argparse
from adventofcode import exercises


def main(exercise):
    if exercise == "all":
        N_EXERCISES = 13
        for i in range(1, N_EXERCISES + 1):
            getattr(exercises, f"main_{i}")()
    else:
        try:
            getattr(exercises, f"main_{exercise}")()
        except AttributeError:
            print(f"No exercise found with the number {exercise}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Run a specific exercise or all exercises from adventofcode."
    )
    parser.add_argument(
        "exercise",
        type=str,
        help="The exercise number to run (e.g., 1, 2, 3) or 'all' to run all exercises.",
    )
    args = parser.parse_args()
    main(args.exercise)
