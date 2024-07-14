import re
from dataclasses import dataclass

from loguru import logger

from adventofcode import utils

EXERCISE = 17


@dataclass
class Target:
    x1: int
    x2: int
    y1: int
    y2: int

    def __str__(self):
        return f"Target(x={self.x1}..{self.x2}, y={self.y1}..{self.y2})"

    def within_bounds(self, x: int, y: int) -> bool:
        return self.x1 <= x <= self.x2 and self.y1 <= y <= self.y2

    def cannot_reach_target(self, x: int, y: int) -> bool:
        return y < min(self.y1, self.y2)


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    target = parse_target(input_data)

    best_height = 0
    for x in range(0, target.x2 + 1):
        for y in range(0, abs(target.y1)):
            velocity = (x, y)
            best_height = max(best_height, run_probe(target, velocity))

    return best_height


def run_b(input_data: str):
    target = parse_target(input_data)

    n_reached = 0
    for x in range(0, target.x2 + 1):
        for y in range(target.y1, abs(target.y1)):
            velocity = (x, y)
            reached = run_probe(target, velocity) >= 0
            n_reached += reached

    return n_reached


def run_probe(target: Target, velocity: tuple[int, int]) -> int:
    position = (0, 0)
    max_height = 0
    step = 0
    while True:
        # Update position
        position = (position[0] + velocity[0], position[1] + velocity[1])
        max_height = max(max_height, position[1])
        step += 1

        # Apply drag on velocity
        if velocity[0] < 0:
            new_x = velocity[0] + 1
        elif velocity[0] > 0:
            new_x = velocity[0] - 1
        else:
            new_x = 0
        velocity = (new_x, velocity[1] - 1)

        # Stopping condition
        if target.within_bounds(*position):
            return max_height
        elif target.cannot_reach_target(*position):
            return -1


def parse_target(input_data: str) -> Target:
    pattern = r"x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)"
    matches = re.search(pattern, input_data)

    if matches:
        x1 = matches.group(1)
        x2 = matches.group(2)
        y1 = matches.group(3)
        y2 = matches.group(4)
        return Target(int(x1), int(x2), int(y1), int(y2))

    raise ValueError("Invalid target area")


if __name__ == "__main__":
    main()
