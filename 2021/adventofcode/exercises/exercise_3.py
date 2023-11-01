from loguru import logger

from adventofcode import utils

EXERCISE = 3


def main():
    input_data = utils.load_data(EXERCISE).splitlines()
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")  #
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")  #


def run_a(data):
    gamma, epsilon = calculate_condition(data)
    return gamma * epsilon


def run_b(data):
    oxygen, co2 = calculate_advanced_condition(data)
    return oxygen * co2


def load_dummy_data():
    return [
        "00100",
        "11110",
        "10110",
        "10111",
        "10101",
        "01111",
        "00111",
        "11100",
        "10000",
        "11001",
        "00010",
        "01010",
    ]


def calculate_condition(data):
    def most_frequent(List):
        return max(set(List), key=List.count)

    gamma = ""
    epsilon = ""
    n_bits = len(data[0])
    # logger.info(f"N bits: {n_bits}")

    for i in range(n_bits):
        bits = [value[i] for value in data]
        most_frequent_value = most_frequent(bits)
        if most_frequent_value == "1":
            gamma += "1"
            epsilon += "0"
        elif most_frequent_value == "0":
            gamma += "0"
            epsilon += "1"

    gamma = int(gamma, 2)
    epsilon = int(epsilon, 2)

    return gamma, epsilon


def calculate_advanced_condition(data):
    def most_frequent(bits, equal, reverse=False):
        """Frequencies"""
        zero_frequency = bits.count("0")
        one_frequency = bits.count("1")
        if zero_frequency == one_frequency:
            most_frequent_value = equal
        elif reverse:
            most_frequent_value = "1" if one_frequency < zero_frequency else "0"
        else:
            most_frequent_value = "1" if one_frequency > zero_frequency else "0"
        return most_frequent_value

    oxygen = "1"
    co2 = ""
    n_bits = len(data[0])
    # logger.info(f"N bits: {n_bits}")

    # Oxygen
    data_oxygen = data
    for i in range(n_bits):
        bits = [value[i] for value in data_oxygen]
        most_frequent_value = most_frequent(bits, "1")
        data_oxygen = bit_filter(data_oxygen, bits, value=most_frequent_value)
        if len(data_oxygen) == 1:
            oxygen = data_oxygen[0]
            break

    # CO2
    data_co2 = data
    for i in range(n_bits):
        bits = [value[i] for value in data_co2]
        most_frequent_value = most_frequent(bits, "0", reverse=True)
        data_co2 = bit_filter(data_co2, bits, value=most_frequent_value)
        if len(data_co2) == 1:
            co2 = data_co2[0]
            break

    oxygen = int(oxygen, 2)
    co2 = int(co2, 2)

    return oxygen, co2


def most_frequent(List):
    return max(set(List), key=List.count)


def bit_filter(data, bits, value):
    return [data[i] for i in range(len(data)) if bits[i] == value]


if __name__ == "__main__":
    main()
