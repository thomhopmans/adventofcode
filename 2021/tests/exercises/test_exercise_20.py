import pytest

from adventofcode.exercises import exercise_20
from adventofcode import utils


TEST_DATA = """
"""


def test_example_on_exercise_a():
    assert exercise_20.run_a(TEST_DATA) == 0


# def test_returns_correct_answer_on_exercise_a():
#     input_data = utils.load_data(exercise_20.EXERCISE)
#     assert exercise_20.run_a(input_data) == 0


# def test_example_on_exercise_b():
#     assert exercise_20.run_b(TEST_DATA) == 0


# def test_returns_correct_answer_on_exercise_b():
#     input_data = utils.load_data(exercise_20.EXERCISE)
#     assert exercise_20.run_b(input_data) == 0
