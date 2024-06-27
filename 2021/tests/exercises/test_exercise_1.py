from adventofcode.exercises import exercise_1
from adventofcode import utils

TEST_DATA = """199
200
208
210
200
207
240
269
260
263"""


def test_1a_returns_7_for_test_data():
    assert exercise_1.run_a(TEST_DATA) == 7


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_1.EXERCISE)
    assert exercise_1.run_a(input_data) == 1665


def test_1b_returns_5_for_test_data():
    assert exercise_1.run_b(TEST_DATA) == 5


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_1.EXERCISE)
    assert exercise_1.run_b(input_data) == 1702

