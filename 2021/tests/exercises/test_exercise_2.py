from adventofcode.exercises import exercise_2
from adventofcode import utils

TEST_DATA = """forward 5
down 5
forward 8
up 3
down 8
forward 2"""


def test_2a():
    assert exercise_2.run_a(TEST_DATA) == 150


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_2.EXERCISE)
    assert exercise_2.run_a(input_data) == 2036120


def test_2b():
    assert exercise_2.run_b(TEST_DATA) == 900


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_2.EXERCISE)
    assert exercise_2.run_b(input_data) == 2015547716
