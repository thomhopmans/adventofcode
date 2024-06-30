import pytest

from adventofcode.exercises import exercise_4
from adventofcode import utils


@pytest.mark.parametrize("test_input,expected", [[111111, 1], [223450, 0], [123789, 0]])
def test_examples_meets_criteria(test_input, expected):
    assert exercise_4.meets_criteria(test_input) == expected


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_4.EXERCISE)
    assert exercise_4.run_a(input_data) == 1178


# def test_4b():
#     assert exercise_4.run_b(TEST_DATA) == 0


# def test_returns_correct_answer_on_exercise_b():
#     input_data = utils.load_data(exercise_4.EXERCISE)
#     assert exercise_4.run_b(input_data) == 0
