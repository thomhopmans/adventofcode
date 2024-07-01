import functools

from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.grid import Grid, get_adjacent_coordinates

EXERCISE = 9
VISITED = "x"
NOT_VISITED = "."


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    grid = Grid.from_data(input_data)

    risk_levels = []
    for i in range(grid.n_rows):
        for j in range(grid.n_columns):
            coord = [i, j]
            coord_value = int(grid.value(i, j))
            adjacents = get_adjacent_coordinates(coord, grid.n_rows, grid.n_columns)
            all_adjacents_higher = all(
                [int(grid.value(*adj)) > coord_value for adj in adjacents]
            )
            if all_adjacents_higher:
                risk_levels += [coord_value + 1]

    return sum(risk_levels)


def run_b(input_data: str):
    grid = Grid.from_data(input_data)

    visited = grid.clone_as_empty_grid(value=NOT_VISITED)

    # Mark high points as visited
    for i in range(grid.n_rows):
        for j in range(grid.n_columns):
            coord = [i, j]
            coord_value = grid.value(i, j)
            if coord_value == "9":
                visited.set_value(i, j, VISITED)

    # Add boundaries
    grid.add_boundary_to_grid(value=9)
    visited.add_boundary_to_grid(value=VISITED)

    # Find bassin sizes
    sizes = []
    for i in range(grid.n_rows):
        for j in range(grid.n_columns):
            if visited.value(i, j) == NOT_VISITED:
                # Start floodfill to find size of bassin.
                coord = [i, j]
                visited, size_bassin = run_floodfill(grid, coord, visited)
                sizes.append(size_bassin)

    three_largest_sizes = sorted(sizes, reverse=True)[:3]
    return functools.reduce(lambda x, y: x * y, three_largest_sizes)


def run_floodfill(grid: Grid, coord: list[int], visited: Grid):
    queue = [coord]
    bassin_coords = [coord]
    visited.set_value(*coord, VISITED)

    while queue:
        coord = queue.pop()
        visited.set_value(*coord, VISITED)
        adjacents = get_adjacent_coordinates(coord, grid.n_rows, grid.n_columns)
        for adj in adjacents:
            if visited.value(*adj) == NOT_VISITED:
                visited.set_value(*adj, VISITED)
                queue.append(adj)
                bassin_coords.append(adj)

    return visited, len(bassin_coords)


if __name__ == "__main__":
    main()
