from copy import copy


def get_int_code():
    with open("inputs/day_2.txt", "r") as handle:
        int_code = [int(line) for line in handle.readline().split(",")]
    return int_code


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
        # print(int_code)
        op_code = int_code[instruction_pointer]
        # print(f"Instruction pointer: {instruction_pointer}. Opcode: {op_code}")
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


if __name__ == "__main__":
    int_code = get_int_code()
    desired_output = 19690720
    output, noun, verb = search_for_output(int_code, desired_output)
    answer = 100 * noun + verb
    print(output, noun, verb, answer)
