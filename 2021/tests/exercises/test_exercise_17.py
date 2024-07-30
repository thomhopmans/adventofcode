import pytest

from adventofcode.exercises import exercise_17
from adventofcode import utils

TEST_DATA = "target area: x=20..30, y=-10..-5"


@pytest.mark.parametrize(
    "velocity, expected",
    [
        [(7, 2), 3],
        [(6, 3), 6],
        [(9, 0), 0],
        [(17, -4), -1],  # Never reached
        [(6, 9), 45],  # Highest
    ],
)
def test_example_on_run_probe(velocity, expected):
    target = exercise_17.parse_target(TEST_DATA)
    assert exercise_17.run_probe(target, velocity) == expected


def test_example_on_exercise_a():
    assert exercise_17.run_a(TEST_DATA) == 45


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_17.EXERCISE)
    assert exercise_17.run_a(input_data) == 4186


def test_example_on_exercise_b():
    assert exercise_17.run_b(TEST_DATA) == 112


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_17.EXERCISE)
    assert exercise_17.run_b(input_data) == 2709
