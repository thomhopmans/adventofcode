from typing import Any


class Grid:
    def __init__(self, grid):
        self.grid = grid

    @classmethod
    def from_data(cls, data: str) -> "Grid":
        return cls(grid=[[str(c) for c in line] for line in data.strip().split("\n")])

    @classmethod
    def from_coordinates(
        cls, coordinates: list, empty_value=".", fill_value="#"
    ) -> "Grid":
        max_x = max([x for x, _ in coordinates])
        max_y = max([y for _, y in coordinates])
        grid = cls.from_dimensions(max_y + 1, max_x + 1, empty_value)
        for x, y in coordinates:
            grid.set_value(y, x, fill_value)
        return grid

    @classmethod
    def from_dimensions(cls, n_rows: int, n_columns: int, value: Any) -> "Grid":
        return cls(grid=[[value for _ in range(n_columns)] for _ in range(n_rows)])

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

    def add_row_above(self, value: Any):
        new_grid = [[value for _ in range(self.n_columns)]]
        for row in self.grid:
            new_grid.append(row)
        self.grid = new_grid

    def add_row_below(self, value: Any):
        new_grid = [row for row in self.grid]
        new_grid.append([value for _ in range(self.n_columns)])
        self.grid = new_grid

    def add_row_to_left(self, value: Any):
        new_grid = [[value] + row for row in self.grid]
        self.grid = new_grid

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
        print(self.printable_grid())

    def printable_grid(self):
        return "\n".join(["".join([str(c) for c in row]) for row in self.grid])

    def find_all(self, value: Any) -> list[list[int]]:
        return [
            [i, j]
            for i in range(self.n_rows)
            for j in range(self.n_columns)
            if self.value(i, j) == value
        ]

    def remove_last_row(self):
        self.grid.pop()

    def remove_last_column(self):
        for row in self.grid:
            row.pop()


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
