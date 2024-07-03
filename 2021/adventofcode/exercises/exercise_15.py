import heapq

from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.grid import Grid, get_adjacent_coordinates

EXERCISE = 15


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    grid = Grid.from_data(input_data)
    grid.to_int()

    start = [0, 0]
    target = [grid.n_rows - 1, grid.n_columns - 1]

    return run_min_priority_queue_algorithm(grid, start, target)


def run_min_priority_queue_algorithm(grid: Grid, start: list[int], target: list[int]):
    # min priority queue
    finals = set()
    queue = []
    queue.append((0, start))
    heapq.heapify(queue)

    visited = set()
    while queue:
        dist, current = heapq.heappop(queue)
        # print(current, " | ", dist, " | ", visited)
        if tuple(current) in visited:
            continue
        if current == target:
            finals.add(dist)
            continue

        visited.add(tuple(current))
        for neighbor in get_adjacent_coordinates(current, grid.n_rows, grid.n_columns):
            if tuple(neighbor) not in visited:
                risk_level = grid.value(*neighbor)
                heapq.heappush(queue, (dist + risk_level, neighbor))

    return min(finals)


def run_b(input_data: str):
    grid = Grid.from_data(input_data)
    grid.to_int()

    # Horizontally expand the grid
    other = grid.copy()
    for _ in range(1, 5):
        other.add(1)
        other.replace_values_above_threshold_by_new_value(9, 1)
        grid.hconcat(other)

    # Vertically expand the grid
    other = grid.copy()
    for _ in range(1, 5):
        other.add(1)
        other.replace_values_above_threshold_by_new_value(9, 1)
        grid.vconcat(other)

    # Run search algorithm
    start = [0, 0]
    target = [grid.n_rows - 1, grid.n_columns - 1]
    return run_min_priority_queue_algorithm(grid, start, target)


if __name__ == "__main__":
    main()
