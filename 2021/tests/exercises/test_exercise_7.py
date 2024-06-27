from adventofcode.exercises import exercise_7
from adventofcode import utils

TEST_DATA = """16,1,2,0,4,2,7,1,2,14"""


def test_7a():
    assert exercise_7.run_a(TEST_DATA) == 37


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_7.EXERCISE)
    assert exercise_7.run_a(input_data) == 341534


def test_7b():
    assert exercise_7.run_b(TEST_DATA) == 168

def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_7.EXERCISE)
    assert exercise_7.run_b(input_data) == 93397632
