from adventofcode.exercises import exercise_21
from adventofcode import utils


TEST_DATA = """Player 1 starting position: 4
Player 2 starting position: 8
"""


def test_example_on_exercise_a():
    assert exercise_21.run_a(TEST_DATA) == 739785


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_21.EXERCISE)
    assert exercise_21.run_a(input_data) == 893700


def test_example_on_exercise_b():
    assert exercise_21.run_b(TEST_DATA) == 444356092776315


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_21.EXERCISE)
    assert exercise_21.run_b(input_data) == 568867175661958
