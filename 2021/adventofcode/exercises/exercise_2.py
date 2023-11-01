from loguru import logger

from adventofcode import utils

EXERCISE = 2


def main():
    input_data = utils.load_data(EXERCISE).splitlines()
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")  #
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")  #


def run_a(data):
    data = parse_data(data)

    pos, depth = process_instructions(data)

    return pos * depth


def run_b(data):
    data = parse_data(data)

    pos, depth = process_advanced_instructions(data)

    return pos * depth


def load_dummy_data():
    return ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]


def parse_data(data):
    parsed = []
    for rule in data:
        kind, value = rule.split(" ")
        value = int(value)
        parsed.append((kind, value))
    return parsed


def process_instructions(data):
    pos = 0
    depth = 0
    for (kind, value) in data:
        if kind == "forward":
            pos += value
        if kind == "up":
            depth -= value
        if kind == "down":
            depth += value
    return pos, depth


def process_advanced_instructions(data):
    aim = 0
    pos = 0
    depth = 0
    for (kind, value) in data:
        if kind == "forward":
            pos += value
            depth += value * aim
        if kind == "up":
            aim -= value
        if kind == "down":
            aim += value
    return pos, depth


if __name__ == "__main__":
    main()
