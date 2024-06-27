from adventofcode.exercises import exercise_3
from adventofcode import utils

TEST_DATA = """00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"""


def test_3a():
    assert exercise_3.run_a(TEST_DATA) == 198


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_3.EXERCISE)
    assert exercise_3.run_a(input_data) == 1997414


def test_3b():
    assert exercise_3.run_b(TEST_DATA) == 230


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_3.EXERCISE)
    assert exercise_3.run_b(input_data) == 1032597
