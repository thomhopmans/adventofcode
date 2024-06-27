from adventofcode.exercises import exercise_5
from adventofcode import utils

TEST_DATA = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""


def test_5a():
    assert exercise_5.run_a(TEST_DATA) == 5


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_5.EXERCISE)
    assert exercise_5.run_a(input_data) == 7414


def test_5b():
    assert exercise_5.run_b(TEST_DATA) == 12

def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_5.EXERCISE)
    assert exercise_5.run_b(input_data) == 19676
