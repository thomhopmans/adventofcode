import dataclasses
import re
from typing import Set

from loguru import logger

from adventofcode import utils

EXERCISE = 22


@dataclasses.dataclass
class Side:
    """Represents a single dimensional side of a cuboid."""

    start: int  # Lower bound
    end: int  # Upper bound

    def encloses(self, other):
        """Check if this side fully encloses the other."""
        return (self.start <= other.start <= self.end) and (
            self.start <= other.end <= self.end
        )

    def overlaps(self, other: "Side"):
        """Check if two sides overlap and whether one encloses the other."""
        if self.start == other.end or self.end == other.start:
            return False

        return (self.start <= other.start <= self.end) or (
            other.start <= self.start <= other.end
        )


@dataclasses.dataclass
class Cuboid:
    """Represents a 3D cuboid defined by three sides (x, y, z)."""

    xSide: Side
    ySide: Side
    zSide: Side
    is_on: bool

    def __hash__(self):
        """Generate a hash based on the cuboid's coordinates."""
        return hash(
            (
                self.xSide.start,
                self.xSide.end,
                self.ySide.start,
                self.ySide.end,
                self.zSide.start,
                self.zSide.end,
            )
        )

    def outside_bounds(self) -> bool:
        return (
            self.xSide.start < -50
            or self.xSide.end > 51
            or self.ySide.start < -50
            or self.ySide.end > 51
            or self.zSide.start < -50
            or self.zSide.end > 51
        )

    def is_inside_of(self, other: "Cuboid") -> bool:
        """Check if this cuboid is entirely inside another cuboid."""
        return (
            other.xSide.encloses(self.xSide)
            and other.ySide.encloses(self.ySide)
            and other.zSide.encloses(self.zSide)
        )

    def volume(self) -> int:
        """Calculate the volume of the cuboid."""
        return (
            (self.xSide.end - self.xSide.start)
            * (self.ySide.end - self.ySide.start)
            * (self.zSide.end - self.zSide.start)
        )

    def intersects(self, other: "Cuboid") -> bool:
        """Check if two cuboids intersect."""
        return (
            self.xSide.overlaps(other.xSide)
            and self.ySide.overlaps(other.ySide)
            and self.zSide.overlaps(other.zSide)
        )

    def get_bounds(self, self_side: "Side", other_side: "Side") -> list["Side"]:
        """Get the non-overlapping segments of a side."""
        self_encloses_other = self_side.encloses(other_side)

        if other_side.encloses(self_side):
            return [self_side]

        if self_encloses_other:
            return [
                Side(self_side.start, other_side.start),
                Side(other_side.start, other_side.end),
                Side(other_side.end, self_side.end),
            ]
        else:
            bounds = [
                x for x in [other_side.end, other_side.start] if x > self_side.start
            ]
            if bounds:
                lowest_after_start = min(bounds)
                return [
                    Side(self_side.start, lowest_after_start),
                    Side(lowest_after_start, self_side.end),
                ]
            return []

    def split(self, other: "Cuboid") -> Set["Cuboid"]:
        """Split the current cuboid into parts, excluding the overlapping region with another cuboid."""
        if self.is_inside_of(other):
            return set()
        if not self.intersects(other):
            return {self}

        result = set()
        for x in self.get_bounds(self.xSide, other.xSide):
            for y in self.get_bounds(self.ySide, other.ySide):
                for z in self.get_bounds(self.zSide, other.zSide):
                    current_cuboid = Cuboid(x, y, z, True)
                    if current_cuboid not in result and not current_cuboid.is_inside_of(
                        other
                    ):
                        result.add(current_cuboid)

        return result

    def __sub__(self, other):
        """Subtract another cuboid from this one."""
        return self.split(other)


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str) -> int:
    instructions = parse_data(input_data)
    all_cubes = [cuboid for cuboid in instructions if not cuboid.outside_bounds()]
    return process(all_cubes)


def run_b(input_data: str) -> int:
    instructions = parse_data(input_data)
    return process(instructions)


def parse_data(input_data: str) -> list[Cuboid]:
    return [parse_instruction(instruction) for instruction in input_data.splitlines()]


def parse_instruction(line: str) -> Cuboid:
    """
    Parse Instruction from line using regex.

    Example: on x=-20..26,y=-36..17,z=-47..7
    """
    # Extract the operation (on/off)
    operation = line.startswith("on")

    # Use regex to extract the ranges for x, y, z
    pattern = r"x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)"
    match = re.search(pattern, line)

    if match:
        x_min, x_max, y_min, y_max, z_min, z_max = map(int, match.groups())
        return Cuboid(
            Side(x_min, x_max + 1),
            Side(y_min, y_max + 1),
            Side(z_min, z_max + 1),
            operation,
        )
    else:
        raise ValueError(f"Unable to parse instruction: {line}")


def process(all_cubes: list[Cuboid]) -> int:
    # Process all cubes to find the overlap
    on_cubes: Set[Cuboid] = set()

    for new_cube in all_cubes:
        if not on_cubes:
            on_cubes.add(new_cube)
            continue

        next_on_cubes = set()

        for existing_cube in on_cubes:
            non_overlap_parts = existing_cube - new_cube
            next_on_cubes |= non_overlap_parts

        if new_cube.is_on:
            next_on_cubes.add(new_cube)

        on_cubes = next_on_cubes

    total_volume = sum(c.volume() for c in on_cubes)

    return total_volume


if __name__ == "__main__":
    main()
