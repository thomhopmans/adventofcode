from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.grid import (
    Grid,
    get_adjacent_and_diagonal_coordinates,
)

EXERCISE = 11
NO_FLASH = "."
FLASH = "x"
FLASH_THRESHOLD = 10


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    grid = Grid.from_data(input_data)
    grid.to_int()

    current_step = 1
    n_flashes = 0
    while current_step <= 100:
        grid, n_flashes_in_step = run_step(grid)
        n_flashes += n_flashes_in_step
        current_step += 1

    return n_flashes


def run_step(grid: Grid) -> tuple[Grid, int]:
    flashed_in_step = grid.clone_as_empty_grid(NO_FLASH)
    grid = increase_all_by_one(grid)
    to_flash = find_all(grid, FLASH_THRESHOLD)

    while to_flash:
        for coord in to_flash:
            grid.set_value(*coord, 0)
            flashed_in_step.set_value(*coord, FLASH)

            adjacents = get_adjacent_and_diagonal_coordinates(
                coord, grid.n_rows, grid.n_columns
            )
            for adj in adjacents:
                if (
                    flashed_in_step.value(*adj) == NO_FLASH
                    and grid.value(*adj) < FLASH_THRESHOLD
                ):
                    grid.set_value(*adj, grid.value(*adj) + 1)
        to_flash = find_all(grid, FLASH_THRESHOLD)

    n_flashes = len(find_all(flashed_in_step, FLASH))
    return grid, n_flashes


def increase_all_by_one(grid: Grid):
    for i in range(grid.n_rows):
        for j in range(grid.n_columns):
            grid.set_value(i, j, grid.value(i, j) + 1)
    return grid


def find_all(grid: Grid, value: int):
    coords = []
    for i in range(grid.n_rows):
        for j in range(grid.n_columns):
            if grid.value(i, j) == value:
                coords.append([i, j])
    return coords


def run_b(input_data: str):
    grid = Grid.from_data(input_data)
    grid.to_int()

    current_step = 1
    while True:
        grid, n_flashes_in_step = run_step(grid)
        if n_flashes_in_step == grid.n:
            break
        current_step += 1

    return current_step


if __name__ == "__main__":
    main()
