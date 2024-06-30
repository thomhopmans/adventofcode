import math

from loguru import logger

from adventofcode import utils

EXERCISE = 1


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(data: str) -> int:
    modules_mass = parse_modules_mass(data)
    total_fuel_requirement = [fuel_requirement(mass) for mass in modules_mass]
    return sum(total_fuel_requirement)


def run_b(data: str) -> int:
    modules_mass = parse_modules_mass(data)
    total_fuel_requirement = [recursive_fuel_requirement(mass) for mass in modules_mass]
    return sum(total_fuel_requirement)


def parse_modules_mass(data: str) -> list[int]:
    return [int(line) for line in data.splitlines()]


def recursive_fuel_requirement(mass: list[int]) -> int:
    fuel = fuel_requirement(mass)

    additional_fuel = fuel_requirement(fuel)
    while additional_fuel > 0:
        fuel = fuel + additional_fuel
        additional_fuel = fuel_requirement(additional_fuel)

    return fuel


def fuel_requirement(mass: list[int]) -> int:
    return max(0, math.floor(mass / 3) - 2)
