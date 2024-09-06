import re
from collections import Counter
from dataclasses import dataclass
from functools import cached_property
from pprint import pprint
from copy import deepcopy

import numpy as np
from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.matrix import Vector

EXERCISE = 19


@dataclass
class Scanner:
    number: int
    coordinates: Vector
    orientation: int  # orientation 0 - 23
    beacons: list["ScannerBeacon"]

    def set_orientation(self, orientation: int):
        self.orientation = orientation
        for beacon in self.beacons:
            beacon.set_orientation(orientation)

    def add_coordinates_to_beacons(self):
        for beacon in self.beacons:
            beacon.orientation += self.coordinates


@dataclass
class ScannerBeacon:
    number: int
    orientation: Vector

    @classmethod
    def from_text(cls, number, text):
        x, y, z = re.findall(r"-?\d+", text)
        orientation = Vector(*[int(x), int(y), int(z)])
        return cls(number, orientation)

    @property
    def orientations(self) -> list["ScannerBeacon"]:
        return [
            Vector(*rotate(self.orientation)) for rotate in self.rotation_functions()
        ]

    def rotation_functions(self):
        """Generate all 24 possible 3D rotation functions based on unit vectors."""
        vectors = [
            (1, 0, 0),
            (-1, 0, 0),
            (0, 1, 0),
            (0, -1, 0),
            (0, 0, 1),
            (0, 0, -1),
        ]
        vectors = list(map(np.array, vectors))
        for vi in vectors:
            for vj in vectors:
                if np.dot(vi, vj) == 0:
                    vk = np.cross(vi, vj)
                    yield lambda x: np.matmul(x.numpy(), np.array([vi, vj, vk]))

    def set_orientation(self, orientation_index: int):
        if orientation_index < 0 or orientation_index > 23:
            raise ValueError("Orientation index must be between 0 and 23")

        self.orientation = self.orientations[orientation_index]

    def distance(self, other: "ScannerBeacon"):
        return self.orientation.distance(other.orientation)

    def delta(self, other: "ScannerBeacon"):
        return self.orientation.delta(other.orientation)


@dataclass
class BeaconPair:
    first: ScannerBeacon
    second: ScannerBeacon
    distance: int
    delta: Vector


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    # logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    scanners = parse_data(input_data=input_data)

    # Determine positions of all scanners
    for first_scanner in scanners:
        for second_scanner in scanners:
            if first_scanner.number >= second_scanner.number:
                continue

            elif pairs := check_overlap(first_scanner, second_scanner):
                overlapping_beacons = overlapping(pairs)
                delta_vector = overlapping_beacons[0].delta
                print(" ", delta_vector)

                if (
                    first_scanner.coordinates != Vector(0, 0, 0)
                    or first_scanner.number == 0
                ):
                    second_scanner.coordinates = (
                        first_scanner.coordinates + delta_vector
                    )
                    print(
                        f"  Scanner {second_scanner.number} coordinates: {second_scanner.coordinates}"
                    )
                else:
                    first_scanner.coordinates = (
                        second_scanner.coordinates + delta_vector
                    )
                    print(
                        f"  Scanner {first_scanner.number} coordinates: {first_scanner.coordinates}"
                    )
                # second_scanner.add_coordinates_to_beacons()
                # for b in second_scanner.beacons:
                #     print(" ", b.orientation)

            else:
                pass
                # print(
                #     f"Scanner {first_scanner.number} and {second_scanner.number} do not overlap"
                # )

    # Scanner coordinates
    # print("")
    # for scanner in scanners:
    #     print(f"Scanner {scanner.number} at {scanner.coordinates}")

    return


def check_overlap(first_scanner: Scanner, second_scanner: Scanner):
    for second_orientation in range(0, 24):
        second_scanner.set_orientation(second_orientation)
        pairs = beacon_pairs(first_scanner, second_scanner)
        distances = sorted([p.distance for p in pairs])

        if max(Counter(distances).values()) >= 12:
            print(
                f"Scanner {first_scanner.number} ({first_scanner.orientation}) and {second_scanner.number} ({second_scanner.orientation}) overlap!"
            )
            return pairs

    return []


def beacon_pairs(first_scanner: Scanner, second_scanner: Scanner) -> list[BeaconPair]:
    beacon_pairs = []

    for first_scanner_beacon in first_scanner.beacons:
        for second_scanner_beacon in second_scanner.beacons:
            beacon_pairs.append(
                BeaconPair(
                    first_scanner_beacon,
                    second_scanner_beacon,
                    first_scanner_beacon.distance(second_scanner_beacon),
                    first_scanner_beacon.delta(second_scanner_beacon),
                )
            )

    return beacon_pairs


def overlapping(pairs: list[BeaconPair]) -> list[BeaconPair]:
    # Check overlapping beacons in distance
    most_frequent_distance = max(
        Counter([p.distance for p in pairs]).items(), key=lambda x: x[1]
    )[0]
    pairs = [pair for pair in pairs if pair.distance == most_frequent_distance]

    return pairs


def parse_data(input_data: str) -> list[Scanner]:
    print("")
    scanners_str = input_data.strip().split("\n\n")
    return [
        Scanner(
            number=index,
            coordinates=Vector(0, 0, 0),
            orientation=0,
            beacons=[
                ScannerBeacon.from_text(number, line.strip())
                for number, line in enumerate(scanner.split("\n")[1:])
            ],
        )
        for index, scanner in enumerate(scanners_str)
    ]


def run_b(input_data: str):
    return


if __name__ == "__main__":
    main()
