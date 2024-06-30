import pytest
from adventofcode.exercises import exercise_1
from adventofcode import utils


@pytest.mark.parametrize(
    "test_input,expected", [["12", 2], ["14", 2], ["1969", 654], ["100756", 33583]]
)
def test_inputs_in_a(test_input, expected):
    assert exercise_1.run_a(test_input) == expected


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_1.EXERCISE)
    assert exercise_1.run_a(input_data) == 3268951


@pytest.mark.parametrize(
    "test_input,expected", [["14", 2], ["1969", 966], ["100756", 50346]]
)
def test_inputs_in_b(test_input, expected):
    assert exercise_1.run_b(test_input) == expected


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_1.EXERCISE)
    assert exercise_1.run_b(input_data) == 4900568
