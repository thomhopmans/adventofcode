from adventofcode.exercises import exercise_2
from adventofcode import utils

TEST_DATA = """1,9,10,3,2,3,11,0,99,30,40,50"""


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_2.EXERCISE)
    assert exercise_2.run_a(input_data) == 6730673


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_2.EXERCISE)
    assert exercise_2.run_b(input_data) == 3749
