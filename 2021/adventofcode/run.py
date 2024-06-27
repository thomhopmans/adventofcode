from adventofcode import exercises

N_EXERCISES = 7


def main():
    print(exercises.__all__)
    for i in range(1, N_EXERCISES + 1):
        getattr(exercises, f"main_{i}")()


if __name__ == "__main__":
    main()
