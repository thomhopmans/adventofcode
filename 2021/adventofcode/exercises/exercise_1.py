from loguru import logger

from adventofcode import utils

EXERCISE = 1


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str) -> int:
    data = parse_data(input_data.splitlines())
    return count_is_larger(data)


def run_b(input_data: str) -> int:
    data = parse_data(input_data.splitlines())
    return count_sliding_window_is_larger(data)


def parse_data(data) -> list[int]:
    return [int(line) for line in data]


def count_is_larger(data):
    first = data[:-1]
    second = data[1:]
    larger = [True for (a, b) in zip(first, second) if b > a]
    return len(larger)


def count_sliding_window_is_larger(data):
    def get_sliding_windows(x):
        first = data[0:-2]
        second = data[1:-1]
        third = data[2:]

        return [a + b + c for (a, b, c) in zip(first, second, third)]

    first = get_sliding_windows(data)
    return count_is_larger(first)


if __name__ == "__main__":
    main()
