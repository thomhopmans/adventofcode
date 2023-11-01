import math


def get_modules_mass():
    with open("inputs/day_1.txt", "r") as handle:
        modules = [int(line.strip()) for line in handle.readlines()]
    return modules


def calculate_fuel_requirement(mass):
    fuel = fuel_requirement(mass)

    additional_fuel = fuel_requirement(fuel)
    while additional_fuel > 0:
        fuel = fuel + additional_fuel
        additional_fuel = fuel_requirement(additional_fuel)

    return fuel


def fuel_requirement(mass):
    return max(0, math.floor(mass / 3) - 2)


if __name__ == "__main__":
    modules = get_modules_mass()

    total_fuel_requirement = [calculate_fuel_requirement(mass) for mass in modules]
    total_fuel_requirement = sum(total_fuel_requirement)
    print(total_fuel_requirement)
