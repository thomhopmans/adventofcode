from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers import grid

EXERCISE = 20


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    algorithm, image = parse_data(input_data)

    for _ in range(10):
        image.add_boundary_to_grid(".")

    for _ in range(2):
        image = run_enhancement_algorithm(image, algorithm)

    return len(image.find_all("#"))


def run_b(input_data: str):
    algorithm, image = parse_data(input_data)

    for _ in range(101):
        image.add_boundary_to_grid(".")

    for _ in range(50):
        image = run_enhancement_algorithm(image, algorithm)

    return len(image.find_all("#"))
    

def run_enhancement_algorithm(image: grid.Grid, algorithm: str) -> grid.Grid:
    enhanced_image = image.copy()

    for m in range(1, image.n_rows):
        for n in range(1, image.n_columns):
            surrounding_pixels = image.neighbours8(m, n)
            pixel_9bit = "".join(["1" if x == "#" else "0" for x in surrounding_pixels])
            pixel_value = int(pixel_9bit, 2)
            new_value = algorithm[pixel_value]
            enhanced_image.set_value(m, n, new_value)

    # The outer border of the 'infinite' grid is removed to deal with algorithm flipping from . to # for the infinite grid,
    # which happens when index 0 in the algorithm returns a # and index 511 returns a . like the real input data.
    enhanced_image.remove_first_column()
    enhanced_image.remove_first_row()
    enhanced_image.remove_last_row()
    enhanced_image.remove_last_column()

    return enhanced_image.copy()


def parse_data(input_data: str) -> tuple[str, grid.Grid]:
    algorithm, image = input_data.strip().split("\n\n")

    algorithm = "".join(algorithm.split("\n"))

    image = grid.Grid.from_data(image)

    return algorithm, image


if __name__ == "__main__":
    main()
