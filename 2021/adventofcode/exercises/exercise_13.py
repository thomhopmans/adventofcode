from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.grid import Grid

EXERCISE = 13


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: \n{run_b(input_data)}")


def run_a(input_data: str):
    dot_coordinates, fold_instructions = input_data.split("\n\n")
    dot_coordinates = [
        tuple(map(int, line.split(","))) for line in dot_coordinates.split("\n")
    ]
    grid = Grid.from_coordinates(dot_coordinates)

    fold_instructions = fold_instructions.split("\n")
    for instruction in fold_instructions:
        instruction, value = instruction.split(" ")[-1].split("=")
        if instruction == "y":
            grid = fold_along_y(grid, int(value))
        else:
            grid = fold_along_x(grid, int(value))

        break

    return len(grid.find_all("#"))


def run_b(input_data: str):
    dot_coordinates, fold_instructions = input_data.split("\n\n")
    dot_coordinates = [
        tuple(map(int, line.split(","))) for line in dot_coordinates.split("\n")
    ]
    grid = Grid.from_coordinates(dot_coordinates)
    grid.add_row_below(".")

    fold_instructions = fold_instructions.strip().split("\n")
    for instruction in fold_instructions:
        instruction, value = instruction.split(" ")[-1].split("=")
        if instruction == "y":
            grid = fold_along_y(grid, int(value))
        else:
            grid = fold_along_x(grid, int(value))

    return grid.printable_grid()


def fold_along_y(grid: Grid, x: int):
    n_rows = grid.n_rows
    n_cols = grid.n_columns

    # Add rows above
    if x < n_rows // 2:
        for _ in range(n_rows // 2 - x):
            grid.add_row_above(".")

    # Apply fold
    for i in range(x + 1, n_rows):
        for j in range(n_cols):
            mirror_i = n_rows - i - 1
            if grid.value(i, j) == "#":
                grid.set_value(mirror_i, j, "#")
                grid.set_value(i, j, ".")

    # Remove last rows
    for _ in range(x, n_rows):
        grid.remove_last_row()

    return grid


def fold_along_x(grid: Grid, y: int):
    n_rows = grid.n_rows
    n_cols = grid.n_columns

    # Add rows above
    if y < n_cols // 2:
        for _ in range(n_cols // 2 - y):
            grid.add_row_to_left(".")

    # Apply fold
    for i in range(n_rows):
        for j in range(y + 1, n_cols):
            mirror_j = n_cols - j - 1
            if grid.value(i, j) == "#":
                grid.set_value(i, mirror_j, "#")
                grid.set_value(i, j, ".")

    # Remove last columns
    for _ in range(y, n_cols):
        grid.remove_last_column()

    return grid


if __name__ == "__main__":
    main()
