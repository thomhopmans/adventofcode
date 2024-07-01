from adventofcode.exercises import exercise_10
from adventofcode import utils

TEST_DATA = """[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"""


def test_example_on_exercise_a():
    assert exercise_10.run_a(TEST_DATA) == 26397


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_10.EXERCISE)
    assert exercise_10.run_a(input_data) == 374061


def test_example_on_exercise_b():
    assert exercise_10.run_b(TEST_DATA) == 288957


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_10.EXERCISE)
    assert exercise_10.run_b(input_data) == 2116639949
