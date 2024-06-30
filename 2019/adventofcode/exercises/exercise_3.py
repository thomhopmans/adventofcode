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


if __name__ == "__main__":
    ## MANHATTAN DISTANCE
    # input_1 = "R8,U5,L5,D3"
    # input_2 = "U7,R6,D4,L4"
    # expected_output = 6

    # input_1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    # input_2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    # expected_output = 159

    # input_1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    # input_2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    # expected_output = 135

    # input_1, input_2 = get_wires()
    # expected_output = 248

    ## SIGNAL DELAY
    # input_1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    # input_2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    # expected_output = 610
    #
    # input_1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    # input_2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    # expected_output = 410

    input_1, input_2 = get_wires()
    expected_output = 28580

    lowest_distance = get_lowest_signal_delay_to_collision(input_1, input_2)
