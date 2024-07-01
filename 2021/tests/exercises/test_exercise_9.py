from adventofcode.exercises import exercise_9
from adventofcode import utils

TEST_DATA = """2199943210
3987894921
9856789892
8767896789
9899965678
"""


def test_example_on_exercise_a():
    assert exercise_9.run_a(TEST_DATA) == 15


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_9.EXERCISE)
    assert exercise_9.run_a(input_data) == 448


def test_example_on_exercise_b():
    assert exercise_9.run_b(TEST_DATA) == 1134


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_9.EXERCISE)
    assert exercise_9.run_b(input_data) == 1417248
