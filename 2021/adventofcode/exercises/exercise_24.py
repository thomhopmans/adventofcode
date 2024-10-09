from pprint import pprint

from loguru import logger

from adventofcode import utils

EXERCISE = 24


def main():
    input_data = utils.load_data(EXERCISE)
    # logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str) -> int:
    instructions = parse_data(input_data)

    blocks = get_instruction_blocks(instructions)
    block_abc_instructions = [block_to_abc(block) for block in blocks]

    largest_model = find_largest_valid_model(block_abc_instructions)

    return largest_model


def run_b(input_data: str) -> int:
    instructions = parse_data(input_data)

    blocks = get_instruction_blocks(instructions)
    block_abc_instructions = [block_to_abc(block) for block in blocks]

    smallest_model = find_smallest_valid_model(block_abc_instructions)

    return smallest_model


def parse_data(input_data: str) -> None:
    return input_data.strip().split("\n")


def find_largest_valid_model(block_abc_instructions: list[tuple[int, int, int]]) -> str:
    # Check the largest 14-digit number (descending), all digits 1-9 (no 0 allowed)
    for num in range(9999999, 1111111, -1):
        num_str = str(num)

        # Skip numbers with 0 as it's not allowed
        if "0" in num_str:
            continue

        input_values = [int(d) for d in num_str]
        model_number = run_instructions(block_abc_instructions, input_values)

        if model_number is not False:
            return model_number

    raise ValueError("No valid model found")


def find_smallest_valid_model(
    block_abc_instructions: list[tuple[int, int, int]],
) -> str:
    # Check the largest 14-digit number (descending), all digits 1-9 (no 0 allowed)
    for num in range(1111111, 9999999):
        num_str = str(num)

        # Skip numbers with 0 as it's not allowed
        if "0" in num_str:
            continue

        input_values = [int(d) for d in num_str]
        model_number = run_instructions(block_abc_instructions, input_values)

        if model_number is not False:
            return model_number

    raise ValueError("No valid model found")


def run_instructions(
    block_abc_instructions: list[tuple[int, int, int]], input_values: list[int]
) -> str:
    stack = [0]
    push_i = 0
    model_number = ""

    for block in block_abc_instructions:
        # push block
        if block[0] == 1:
            w = input_values[push_i]
            # z = block_in_python(w=w, z=0, a=block[0], b=block[1], c=block[2])
            z = compiled_block_if_a_is_1_and_b_is_10plus(w=w, z=0, c=block[2])

            stack.append(z)
            push_i += 1
            model_number += str(w)

        # pop block
        else:
            z = stack.pop()
            for w in range(1, 10):
                new_z = block_in_python(w=w, z=z, a=block[0], b=block[1], c=block[2])
                if new_z == 0:
                    model_number += str(w)
                    break
            else:
                return False

        if len(model_number) == 14:
            return model_number

    return False


def get_instruction_blocks(instructions: list[str]) -> list[list[str]]:
    """Split the instructions into blocks starting with 'inp'."""
    blocks = []
    current_block = []

    for instruction in instructions:
        # New block
        if instruction.startswith("inp"):
            if current_block:
                blocks.append(current_block)
            current_block = [instruction]
        # Append to existing block
        else:
            current_block.append(instruction)

    # Add last block adn return
    if current_block:
        blocks.append(current_block)

    return blocks


def block_to_abc(block_lines: list[str]) -> tuple[int, int, int]:
    def third_element(line: str):
        return int(line.split(" ")[2])

    a = third_element(block_lines[4])
    b = third_element(block_lines[5])
    c = third_element(block_lines[15])
    return (a, b, c)


def block_in_python(w: int, z: int, a: int, b: int, c: int) -> int:
    x = int((z % 26) + b != w)
    z //= a
    z *= 25 * x + 1
    z += (w + c) * x
    return z


def compiled_block_if_a_is_1_and_b_is_10plus(w: int, z: int, c: int) -> int:
    z *= 26
    z += w + c
    return z


def calculate_z(model_number: str, block_abc_instructions: list[tuple[int, int, int]]):
    input_values = [int(d) for d in model_number]

    z = 0
    for index, block in enumerate(block_abc_instructions):
        w = input_values[index]
        z = block_in_python(w=w, z=z, a=block[0], b=block[1], c=block[2])
        print(index, z)

    return z


if __name__ == "__main__":
    main()
