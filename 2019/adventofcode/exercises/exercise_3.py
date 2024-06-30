import numpy as np

from loguru import logger

from adventofcode import utils

EXERCISE = 3


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(data: str):
    data = data.split("\n")
    input_1 = data[0]
    input_2 = data[1]
    return get_lowest_distance_to_collision(input_1, input_2)


def run_b(data: str):
    data = data.split("\n")
    input_1 = data[0]
    input_2 = data[1]
    return get_lowest_signal_delay_to_collision(input_1, input_2)


def get_lowest_distance_to_collision(input_1, input_2):
    input_1 = input_1.split(",")
    input_2 = input_2.split(",")

    coordinates_1 = get_coordinates(input_1)
    coordinates_2 = get_coordinates(input_2)
    print(f"N. coordinates 1: {len(coordinates_1)}")
    print(f"N. coordinates 2: {len(coordinates_2)}")

    collisions = intersection(coordinates_1, coordinates_2)
    print(f"Collisions: {collisions}")
    lowest_distance = closest_to_origin(collisions)
    print(f"Lowest distance: {lowest_distance}")
    return lowest_distance


def get_coordinates(input):
    coordinates = list()
    current_pos = [0, 0]
    for wire in input:
        direction = str(wire[0])
        length = int(wire[1:])

        for i in range(length):
            if direction == "R":
                current_pos[0] = current_pos[0] + 1
            elif direction == "U":
                current_pos[1] = current_pos[1] + 1
            elif direction == "L":
                current_pos[0] = current_pos[0] - 1
            elif direction == "D":
                current_pos[1] = current_pos[1] - 1

            coordinates.append(tuple(current_pos))

        # print(direction, length, current_pos)
    return coordinates


def intersection(a, b):
    c = set.intersection(set(a), set(b))
    return c


def closest_to_origin(coordinates):
    coordinates = list(coordinates)
    distances = [manhattan_distance(c) for c in coordinates]
    index = int(np.argmin(distances))
    closest_coordinate = coordinates[index]
    lowest_distance = manhattan_distance(closest_coordinate)
    return lowest_distance


def manhattan_distance(coordinate):
    return np.abs(coordinate[0]) + np.abs(coordinate[1])


def get_lowest_signal_delay_to_collision(input_1, input_2):
    input_1 = input_1.split(",")
    input_2 = input_2.split(",")

    coordinates_1 = get_coordinates(input_1)
    coordinates_2 = get_coordinates(input_2)
    print(f"N. coordinates 1: {len(coordinates_1)}")
    print(f"N. coordinates 2: {len(coordinates_2)}")

    collisions = intersection(coordinates_1, coordinates_2)
    print(f"Collisions: {collisions}")
    signal_delay = lowest_signal_delay(coordinates_1, coordinates_2, collisions)
    print(f"Lowest signal delay: {signal_delay}")
    return signal_delay


def lowest_signal_delay(coordinates_1, coordinates_2, collisions):
    delays = [signal_delay(coordinates_1, coordinates_2, point) for point in collisions]
    index = int(np.argmin(delays))
    lowest_delay = delays[index]
    return lowest_delay


def signal_delay(coordinates_1, coordinates_2, point):
    steps_1 = get_steps(coordinates_1, point)
    steps_2 = get_steps(coordinates_2, point)
    delay = steps_1 + steps_2
    return delay


def get_steps(coordinates, point):
    n_steps = 0
    while True:
        n_steps += 1
        if point == coordinates[n_steps]:
            return n_steps + 1
