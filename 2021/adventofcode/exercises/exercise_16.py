from functools import reduce

from loguru import logger

from adventofcode import utils

EXERCISE = 16

HEX_TO_BITS = {
    "0": "0000",
    "1": "0001",
    "2": "0010",
    "3": "0011",
    "4": "0100",
    "5": "0101",
    "6": "0110",
    "7": "0111",
    "8": "1000",
    "9": "1001",
    "A": "1010",
    "B": "1011",
    "C": "1100",
    "D": "1101",
    "E": "1110",
    "F": "1111",
}


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    input_data = list(input_data.strip())
    bits = "".join([HEX_TO_BITS[c] for c in input_data])

    bits, version_sum, _ = decode(bits, 0)

    return version_sum


def run_b(input_data: str):
    input_data = list(input_data.strip())
    bits = "".join([HEX_TO_BITS[c] for c in input_data])

    bits, _, value = decode(bits, 0)
    value = value[0]

    return value


def decode(bits: str, version_sum):
    packet_version = int(bits[:3], 2)
    packet_type_id = int(bits[3:6], 2)

    # packet version sum
    version_sum += packet_version

    # parse bits
    bits = bits[6:]

    sub_packet_values = []

    if packet_type_id == 4:
        # Literal
        lit_bits = []
        while bits[0] == "1":
            # Not last group
            lit_bits.extend(bits[1:5])
            bits = bits[5:]
        else:
            # Last group
            lit_bits.extend(bits[1:5])
            lit_value = int("".join(lit_bits), 2)
            return bits[5:], version_sum, [lit_value]
    else:
        # Operator
        length_type_id = int(bits[0], 2)
        bits = bits[1:]

        if length_type_id == 0:
            length_bits = int(bits[:15], 2)
            bits = bits[15:]

            start_length_bits = len(bits)
            while start_length_bits - len(bits) < length_bits:
                bits, version_sum, value = decode(bits, version_sum)
                sub_packet_values.extend(value)

        elif length_type_id == 1:
            number_of_subpackets = int(bits[0:11], 2)

            bits = bits[11:]
            for _ in range(number_of_subpackets):
                bits, version_sum, value = decode(bits, version_sum)
                sub_packet_values.extend(value)

        else:
            raise ValueError(f"Invalid length_type_id: {length_type_id}")

    applied_value = apply_operator(packet_type_id, sub_packet_values)
    return bits, version_sum, [applied_value]


def apply_operator(operator: int, values):
    # 0 = sum
    # 1 = product
    # 2 = minimum
    # 3 = maximum
    # 5 are greater than packets - 1 if the value of the first sub-packet is greater than the value of the second sub-packet; otherwise, their value is 0
    # 6 are less than packets - 1 if the value of the first sub-packet is less than the value of the second sub-packet; otherwise, their value is 0.
    # 7 are equal to packets - 1 if the value of the first sub-packet is equal to the value of the second sub-packet; otherwise, their value is 0.
    if operator == 0:
        return reduce(lambda x, y: x + y, values)
    elif operator == 1:
        return reduce(lambda x, y: x * y, values)
    elif operator == 2:
        return min(values)
    elif operator == 3:
        return max(values)
    elif operator == 5:
        return 1 if values[0] > values[1] else 0
    elif operator == 6:
        return 1 if values[0] < values[1] else 0
    elif operator == 7:
        return 1 if values[0] == values[1] else 0
    else:
        raise ValueError(f"Invalid operator: {operator}")


if __name__ == "__main__":
    main()
