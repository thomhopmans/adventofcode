from loguru import logger

from adventofcode import utils

EXERCISE = 10
SYNTAX_CHECKER_CHAR_SCORE = {")": 3, "]": 57, "}": 1197, ">": 25137}
AUTO_CORRECT_CHAR_SCORE = {")": 1, "]": 2, "}": 3, ">": 4}


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    lines = input_data.strip().splitlines()

    scores = []
    for line in lines:
        incorrect_char = check_syntax(line)
        line_score = SYNTAX_CHECKER_CHAR_SCORE.get(incorrect_char, 0)
        scores.append(line_score)

    return sum(scores)


def check_syntax(line: str):
    stack = []
    for char in line:
        if char in "({[<":
            stack.append(char)
        elif char in ")}]>":
            last_char = stack.pop()
            if last_char == "(" and char != ")":
                return char
            elif last_char == "{" and char != "}":
                return char
            elif last_char == "[" and char != "]":
                return char
            elif last_char == "<" and char != ">":
                return char
    return None


def run_b(input_data: str):
    lines = input_data.strip().splitlines()

    scores = []
    for line in lines:
        incorrect_char = check_syntax(line)

        # Corrupt line
        if incorrect_char is not None:
            continue

        # Line is incomplete -> append closing characters
        closing_characters = auto_correct(line)

        line_score = 0
        for char in closing_characters:
            line_score = (line_score * 5) + AUTO_CORRECT_CHAR_SCORE[char]

        scores.append(line_score)

    # Take median of sorted list since we are looking for the middle value of a list with odd elements
    return sorted(scores)[len(scores) // 2]


# 1829685989 is too low


def auto_correct(line: str):
    stack = []
    for char in line:
        if char in "({[<":
            stack.append(char)
        elif char in ")}]>":
            stack.pop()
    # Line ended, find closing characters
    stack = list(reversed(stack))
    replace_map = {"{": "}", "(": ")", "[": "]", "<": ">"}
    stack = [replace_map[char] for char in stack]
    return stack


if __name__ == "__main__":
    main()
