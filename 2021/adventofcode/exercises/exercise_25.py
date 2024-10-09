from loguru import logger

from adventofcode.exercises.helpers import grid
from adventofcode import utils

EXERCISE = 25

EAST = ">"
SOUTH = "v"
EMPTY = "."


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")


def run_a(input_data: str) -> int:
    # Parse input data as grid
    position_grid = grid.Grid.from_data(input_data)
    rows = position_grid.n_rows
    cols = position_grid.n_columns

    # Dictionary to track the positions of the elements
    position_tracker = {
        key: value for key, value in position_grid.to_dict().items() if value != EMPTY
    }

    # Start simulating the movement until no more changes occur
    steps = 0
    while True:
        steps += 1

        east_moves = set()
        south_moves = set()
        east_removals = set()
        south_removals = set()

        # Check for east elements and plan their movement
        for i, j in [pos for pos in position_tracker if position_tracker[pos] == EAST]:
            next_pos = (i, (j + 1) % cols)  # Move east with wrap around
            if next_pos not in position_tracker:
                east_moves.add(next_pos)
                east_removals.add((i, j))

        # Apply the east movements
        if east_moves:
            for pos in east_removals:
                del position_tracker[pos]  # Remove from old position
            for pos in east_moves:
                position_tracker[pos] = EAST  # Move to new position

        # Check for south elements and plan their movement
        for i, j in [pos for pos in position_tracker if position_tracker[pos] == SOUTH]:
            next_pos = ((i + 1) % rows, j)  # Move south with wraparound
            if next_pos not in position_tracker:
                south_moves.add(next_pos)
                south_removals.add((i, j))

        # Apply the south movements
        if south_moves:
            for pos in south_removals:
                del position_tracker[pos]  # Remove from old position
            for pos in south_moves:
                position_tracker[pos] = SOUTH  # Move to new position

        # If no moves occurred, submarine can land
        if not east_moves and not south_moves:
            break

    return steps


if __name__ == "__main__":
    main()
