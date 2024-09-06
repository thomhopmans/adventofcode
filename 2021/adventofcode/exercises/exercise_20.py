import re
from collections import Counter
from dataclasses import dataclass
from functools import cached_property
from itertools import permutations, product
from pprint import pprint
import numpy as np
import math
from itertools import combinations
from copy import deepcopy
from dataclasses import dataclass


from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.matrix import Vector

EXERCISE = 20


@dataclass
class Scanner:
    beacons: np.ndarray


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    # logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    """Parse the input data, run the scanner alignment, and return the number of unique beacons."""
    scanners = parse_data(input_data)
    positions, beacons = locate_scanners(scanners)
    return len(beacons)


def parse_data(input_data: str) -> list[Scanner]:
    scanner_data = input_data.strip().split("\n\n")
    return [
        Scanner(
            np.array(
                [list(map(int, line.split(","))) for line in block.split("\n")[1:]]
            )
        )
        for block in scanner_data
    ]


def locate_scanners(scanners: list[Scanner]):
    """Determine the positions of all scanners and the set of unique beacons."""

    positions = {0: Vector(0, 0, 0)}
    distance_hashes = list(
        map(compute_distance_hash, [scanner.beacons for scanner in scanners])
    )
    unique_beacons: set[tuple[int, int, int]] = set(map(tuple, scanners[0].beacons))

    while len(positions) < len(scanners):
        for i, j, common_hash in find_matching_pairs(distance_hashes):
            if not (i in positions) ^ (j in positions):
                continue
            elif j in positions:
                i, j = j, i

            position, new_beacons, rotation_function = find_orientation(
                scanners, distance_hashes, i, j, common_hash
            )
            positions[j] = position
            scanners[j].beacons = rotation_function(scanners[j].beacons) + np.array(
                [position.x, position.y, position.z]
            )
            for b in scanners[j].beacons:
                print(b)

            unique_beacons |= new_beacons

    return [positions[i] for i in range(len(scanners))], unique_beacons


def compute_distance_hash(beacons: np.ndarray) -> dict:
    """
    Generate a hashset of sorted absolute coordinate differences
    between pairs of points (beacons).
    """
    hash_dict = {
        tuple(sorted(map(abs, beacons[i, :] - beacons[j, :]))): (i, j)
        for i, j in combinations(range(len(beacons)), 2)
    }
    return hash_dict


def find_matching_pairs(distance_hashes: list[dict]):
    """Find pairs of scanners that have sufficient overlap in their distance hashes."""
    for i, j in combinations(range(len(distance_hashes)), 2):
        common_hashes = set(distance_hashes[i]) & set(distance_hashes[j])
        if len(common_hashes) >= math.comb(12, 2):
            print(f"Scanners {i} and {j} have matching pairs.")
            yield i, j, next(iter(common_hashes))


def find_orientation(
    scanners: list[Scanner], distance_hashes: list[dict], i: int, j: int, common_hash
):
    """Find the correct rotation and translation to align the j-th scanner map with the i-th scanner map."""
    s1 = scanners[i].beacons
    s2 = scanners[j].beacons

    for rotate in rotation_functions():
        s2_transformed = rotate(s2)

        p = distance_hashes[i][common_hash][0]
        for q in distance_hashes[j][common_hash]:
            translation = s1[p, :] - s2_transformed[q, :]
            aligned_beacons = set(map(tuple, s2_transformed + translation))

            if len(aligned_beacons & set(map(tuple, s1))) >= 12:
                return Vector(*translation), aligned_beacons, rotate


def rotation_functions():
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
                yield lambda x: np.matmul(x, np.array([vi, vj, vk]))


if __name__ == "__main__":
    main()
