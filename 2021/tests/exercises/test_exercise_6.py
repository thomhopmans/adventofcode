from adventofcode.exercises import exercise_6
from adventofcode import utils

TEST_DATA = """3,4,3,1,2"""


def test_6a():
    assert exercise_6.run_a(TEST_DATA) == 5934


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_6.EXERCISE)
    assert exercise_6.run_a(input_data) == 391888


def test_6b():
    assert exercise_6.run_b(TEST_DATA) == 26984457539

def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_6.EXERCISE)
    assert exercise_6.run_b(input_data) == 1754597645339
