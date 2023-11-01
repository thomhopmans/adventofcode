from dataclasses import dataclass
from loguru import logger
import numpy as np

from adventofcode import utils

EXERCISE = 5


def main():
    input_data = utils.load_data(EXERCISE).splitlines()
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")  #
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")  #


def run_a(data):
    coordinates = parse_data(data)
    return find_dangerous_points(coordinates, skip_diagonal=True)


def run_b(data):
    coordinates = parse_data(data)
    return find_dangerous_points(coordinates, skip_diagonal=False)


@dataclass
class Point:
    x: int
    y: int


@dataclass
class Line:
    start: Point
    end: Point

    def is_horizontal(self):
        return self.start.y == self.end.y

    def is_vertical(self):
        return self.start.x == self.end.x

    def is_diagonal(self):
        return not self.is_horizontal() and not self.is_vertical()

    def get_line(self, shape):
        line_field = np.zeros(shape)

        if self.is_horizontal():
            # logger.info("Horizontal line")
            diff = abs(self.end.x - self.start.x) + 1
            y = self.start.y
            for i in range(diff):
                if self.start.x > self.end.x:
                    update_coord = (self.end.x + i, y)
                else:
                    update_coord = (self.start.x + i, y)
                line_field[update_coord] = 1

        if self.is_vertical():
            # logger.info("Vertical line")
            diff = abs(self.end.y - self.start.y) + 1
            x = self.start.x
            for i in range(diff):
                if self.start.y > self.end.y:
                    update_coord = (x, self.end.y + i)
                else:
                    update_coord = (x, self.start.y + i)
                line_field[update_coord] = 1

        if self.is_diagonal():
            # logger.info("Diagonal line")
            diff = abs(self.end.y - self.start.y) + 1
            x = self.start.x
            y = self.start.y
            for i in range(diff):
                if (self.start.x < self.end.x) and (self.start.y < self.end.y):
                    # Top-left to bottom-right, i.e. (3,3) to (5, 5)
                    update_coord = (self.start.x + i, self.start.y + i)
                elif (self.start.x > self.end.x) and (self.start.y < self.end.y):
                    # Top-right to bottom-left, i.e. (4,4) to (2, 6)
                    update_coord = (self.start.x - i, self.start.y + i)
                elif (self.start.x < self.end.x) and (self.start.y > self.end.y):
                    # Bottom-left to top-right, i.e. (2,6) to (4, 4)
                    update_coord = (self.start.x + i, self.start.y - i)
                elif (self.start.x > self.end.x) and (self.start.y > self.end.y):
                    # Bottom-right to top-left, i.e. (5,5) to (3, 3)
                    update_coord = (self.start.x - i, self.start.y - i)
                else:
                    raise ValueError
                line_field[update_coord] = 1

        line_field = line_field.T
        return line_field


def parse_data(data):
    lines = []
    for line in data:
        start, end = line.split(" -> ")

        start = tuple([int(i) for i in start.split(",")])
        start = Point(x=start[0], y=start[1])

        end = tuple([int(i) for i in end.split(",")])
        end = Point(x=end[0], y=end[1])

        lines.append(Line(start=start, end=end))
    return lines


def find_dangerous_points(lines, skip_diagonal):
    if skip_diagonal:
        lines = filter_straight_lines(lines)
    shape = calculate_shape(lines)
    field = np.zeros(shape)
    field = draw_lines(field, lines)
    # print(field)
    n_dangerous_points = len(np.where(field >= 2)[0])
    # logger.info(f"Dangerous points: {n_dangerous_points}")


def filter_straight_lines(lines):
    keep_lines = []
    for line in lines:
        if line.is_horizontal() or line.is_vertical():
            keep_lines.append(line)
    return keep_lines


def calculate_shape(lines):
    x = []
    y = []
    for line in lines:
        x.extend([line.start.x, line.end.x])
        y.extend([line.start.y, line.end.y])
    return (max(x) + 1, max(y) + 1)


def draw_lines(field, lines):
    shape = field.shape
    for line in lines:
        # logger.info(f"Line: {line.start} to {line.end}")
        drawn = line.get_line(shape)
        field = drawn + field
    return field


if __name__ == "__main__":
    main()
