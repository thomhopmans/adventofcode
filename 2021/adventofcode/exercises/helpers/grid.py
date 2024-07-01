from typing import Any


class Grid:
    def __init__(self, grid):
        self.grid = grid

    @classmethod
    def from_data(cls, data: str) -> "Grid":
        return cls(grid=[[str(c) for c in line] for line in data.strip().split("\n")])

    def to_int(self):
        self.grid = [[int(c) for c in line] for line in self.grid]

    @property
    def n(self):
        return self.n_rows * self.n_columns

    @property
    def n_rows(self):
        return len(self.grid)

    @property
    def n_columns(self):
        return len(self.grid[0])

    def set_value(self, i: int, j: int, value: Any):
        self.grid[i][j] = value

    def value(self, i: int, j: int):
        return self.grid[i][j]

    def clone_as_empty_grid(self, value=None):
        return Grid(
            [[value for _ in range(self.n_columns)] for _ in range(self.n_rows)]
        )

    def add_boundary_to_grid(self, value: str):
        n_cols = len(self.grid[0])

        boundary_row = [value] * (n_cols + 2)
        new_grid = [boundary_row]

        for row in self.grid:
            new_row = [value] + row + [value]
            new_grid.append(new_row)

        new_grid.append(boundary_row)

        self.grid = new_grid

    def print(self) -> None:
        for row in self.grid:
            print("".join([str(c) for c in row]))


def get_adjacent_coordinates(coord: list[int], n_rows: int, n_columns: int):
    complex_coord = list_to_complex(coord)

    # Adjacent moves in complex plane
    moves = [1, -1, 1j, -1j]

    # Calculate adjacent coordinates
    adjacents = [complex_coord + move for move in moves]

    return [
        complex_to_list(a)
        for a in adjacents
        if (a.real >= 0 and a.imag >= 0 and a.real < n_rows and a.imag < n_columns)
    ]


def get_adjacent_and_diagonal_coordinates(
    coord: list[int], n_rows: int, n_columns: int
):
    complex_coord = list_to_complex(coord)

    # Adjacent and diagonal moves in complex plane
    moves = [
        -1 + 0j,  # left
        1 + 0j,  # right
        0 + 1j,  # above
        0 - 1j,  # below
        -1 + 1j,  # top-left diagonal
        1 + 1j,  # top-right diagonal
        -1 - 1j,  # bottom-left diagonal
        1 - 1j,  # bottom-right diagonal
    ]

    # Calculate adjacent coordinates
    adjacents = [complex_coord + move for move in moves]

    return [
        complex_to_list(a)
        for a in adjacents
        if (a.real >= 0 and a.imag >= 0 and a.real < n_rows and a.imag < n_columns)
    ]


def list_to_complex(coord: list[int]):
    """
    Convert a list [x, y] to a complex number x + yi.
    """
    return complex(coord[0], coord[1])


def complex_to_list(c):
    """
    Convert a complex number x + yi to a list [x, y].
    """
    return [int(c.real), int(c.imag)]
