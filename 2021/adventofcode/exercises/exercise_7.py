from collections import defaultdict

from loguru import logger

from adventofcode import utils

EXERCISE = 7


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    crab_positions = parse_data(input_data)
    return horizontal_align_crab(crab_positions, increasing=False)


def run_b(input_data: str):
    crab_positions = parse_data(input_data)
    return horizontal_align_crab(crab_positions, increasing=True)


def parse_data(data: str) -> list[int]:
    line = data.splitlines()[0]
    crab_positions = line.split(",")
    return [int(x) for x in crab_positions]


def horizontal_align_crab(crab_positions, increasing=False):
    max_position = max(crab_positions)

    # Calculate fuel usage for all possible positions
    fuel_used = defaultdict(int)
    for p in range(max_position + 1):
        # Calculate fuel usage for each crab
        if increasing is True:
            fuel = [abs(crab - p) for crab in crab_positions]
            fuel = [(f * (f + 1)) / 2 for f in fuel]
        else:
            fuel = [abs(crab - p) for crab in crab_positions]
        fuel = sum(fuel)
        fuel_used[p] = fuel

    # Find best position, e.g. lowest fuel
    position_min_fuel = min(fuel_used, key=fuel_used.get)

    logger.info(
        f"Best position: {position_min_fuel}, fuel used: {fuel_used[position_min_fuel]}"
    )
    return int(fuel_used[position_min_fuel])


if __name__ == "__main__":
    main()
