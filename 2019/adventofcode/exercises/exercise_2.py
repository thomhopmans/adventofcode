from copy import copy

from loguru import logger

from adventofcode import utils

EXERCISE = 2


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(data: str) -> int:
    int_code = get_int_code(data)
    return run_int_code_program(int_code, noun=12, verb=2)


def run_b(data: str) -> int:
    int_code = get_int_code(data)
    desired_output = 19690720
    output, noun, verb = search_for_output(int_code, desired_output)
    answer = 100 * noun + verb
    return answer


def get_int_code(data: str) -> list[int]:
    return [int(x) for line in data.splitlines() for x in line.split(",") ]


def search_for_output(int_code, desired_output):
    for noun in range(50):
        for verb in range(50):
            output = run_int_code_program(int_code, noun, verb)
            if output == desired_output:
                return output, noun, verb
    raise ValueError("Desired output not found")


def run_int_code_program(int_code, noun, verb):
    instruction_pointer = 0
    int_code = copy(int_code)
    int_code[1] = noun
    int_code[2] = verb

    while True:
        op_code = int_code[instruction_pointer]
        if op_code == 99:
            output = int_code[0]
            return output

        input_1 = int_code[int_code[instruction_pointer + 1]]
        input_2 = int_code[int_code[instruction_pointer + 2]]
        output_pos = int_code[instruction_pointer + 3]

        if op_code == 1:
            int_code[output_pos] = input_1 + input_2
        elif op_code == 2:
            int_code[output_pos] = input_1 * input_2

        instruction_pointer = instruction_pointer + 4
