from loguru import logger

from adventofcode import utils

EXERCISE = 4


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str) -> int:
    start, end = [int(x) for x in input_data.strip().split("-")]
    n_positives = sum([meets_criteria(value) for value in range(start, end)])
    return n_positives


def run_b(input_data: str) -> int:
    pass


def meets_criteria(value: int) -> int:
    return (
        1
        if _has_two_identical_adjacent_digits_not_part_of_bigger_group(value)
        and _is_non_decreasing(value)
        else 0
    )


def _has_two_identical_adjacent_digits_not_part_of_bigger_group(value: int):
    value = str(value)

    for i in range(len(value) - 1):
        if value[i] == value[i + 1]:
            return True

    return False


def _has_two_identical_adjacent_digits(value: int):
    value = str(value)
    for i in range(len(value) - 1):
        if value[i] == value[i + 1]:
            return True
    return False


def _is_non_decreasing(value: int):
    value = str(value)
    for i in range(len(value) - 1):
        if int(value[i]) > int(value[i + 1]):
            return False
    return True
