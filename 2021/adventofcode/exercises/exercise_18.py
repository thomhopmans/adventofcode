import re
import math
import json

from loguru import logger

from adventofcode import utils

EXERCISE = 18


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    snailfish_numbers = input_data.strip().split("\n")

    current_snailfish_number = snailfish_numbers[0]
    for snailfish_number in snailfish_numbers[1:]:
        current_snailfish_number = reduce(
            addition(current_snailfish_number, snailfish_number)
        )

    return magnitude(current_snailfish_number)


def run_b(input_data: str):
    snailfish_numbers = input_data.strip().split("\n")

    magnitudes = []
    for a in snailfish_numbers:
        for b in snailfish_numbers:
            if a != b:
                magnitudes.append(magnitude(reduce(addition(a, b))))

    return max(magnitudes)


def addition(a, b):
    return f"[{a},{b}]"


def reduce(line: str):
    chars = line.strip()

    count_opening_bracket = 0
    pos = 0

    # Look for explodes
    while pos < len(chars):
        current_char = chars[pos]
        if current_char == "[":
            count_opening_bracket += 1
            pos += 1
        elif current_char == "]":
            count_opening_bracket -= 1
            pos += 1
        elif count_opening_bracket == 5:
            chars = explode(chars, pos)

            # Restart the search from beginning
            count_opening_bracket = 0
            pos = 0
        else:
            pos += 1

    # Look for splits
    large_number_matches = re.search(r"(\d{2,})", chars)
    if large_number_matches:
        first_large_value = large_number_matches.group(1)
        start_index = chars.find(first_large_value)
        end_index = start_index + len(first_large_value)
        pair = int(chars[start_index:end_index])
        left = math.floor(pair / 2)
        right = math.ceil(pair / 2)
        new_pair = f"[{left},{right}]"
        chars = chars[:start_index] + new_pair + chars[end_index:]

    if line.strip() != chars:
        return reduce(chars)

    return chars


def explode(chars: str, pos: int):
    matches = re.search(r"(\d+),(\d+).*", chars[pos:])

    explode_left = int(matches.group(1))
    explode_right = int(matches.group(2))

    # Search first left value
    search_left_pos = pos - 1
    left_matches = re.findall(r"(\d+)", chars[:search_left_pos])

    if not left_matches:
        new_left_value = "0"
    else:
        first_left_value = int(left_matches[-1])
        new_left_value = str(first_left_value + explode_left)

    # Search first right value
    search_right_pos = pos + 1 + chars[pos + 1 :].find("]")
    right_matches = re.findall(r"(\d+)", chars[search_right_pos:])
    if not right_matches:
        new_right_value = "0"
    else:
        first_right_value = int(right_matches[0])
        new_right_value = str(first_right_value + explode_right)

    # Replace the digits from the exploded value
    chars = (
        re.sub(r"(\d+)", new_left_value[::-1], chars[:search_left_pos][::-1], count=1)[
            ::-1
        ]
        + "0"
        + re.sub(r"(\d+)", new_right_value, chars[search_right_pos + 1 :], count=1)
    )

    return chars


def magnitude(snailfish_number: str) -> int:
    snailfish_number = json.loads(snailfish_number)
    return magnitude_calc(snailfish_number)


def magnitude_calc(x: list[int]) -> int:
    if isinstance(x, int):
        return x
    return 3 * magnitude_calc(x[0]) + 2 * magnitude_calc(x[1])


if __name__ == "__main__":
    main()
