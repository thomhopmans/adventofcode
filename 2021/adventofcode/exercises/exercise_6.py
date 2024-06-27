from collections import Counter, defaultdict

from loguru import logger

from adventofcode import utils

EXERCISE = 6


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(data: str):
    return run_for_n_days(data, n_days=80)


def run_b(data: str):
    return run_for_n_days(data, n_days=256)


def run_for_n_days(data: str, n_days: int):
    fish_state = parse_data(data)
    fish_state_counts = calculate_n_fish(fish_state, n_days=n_days)
    return sum(fish_state_counts.values())


def parse_data(data: str) -> list[int]:
    line = data.splitlines()[0]
    fish = line.split(",")
    return [int(f) for f in fish]


def calculate_n_fish(fish_state, n_days=10):
    fish_state_counts = Counter(fish_state)
    logger.info(f"Initial state: {fish_state_counts}")

    for i in range(1, n_days + 1):
        new_fish_state_counts = defaultdict(int)

        for timer_value, number in fish_state_counts.items():
            new_timer_value = timer_value - 1

            if new_timer_value < 0:
                new_fish_state_counts[8] += number
                new_fish_state_counts[6] += number
            else:
                new_fish_state_counts[new_timer_value] += number

        fish_state_counts = new_fish_state_counts

    return fish_state_counts


if __name__ == "__main__":
    main()
