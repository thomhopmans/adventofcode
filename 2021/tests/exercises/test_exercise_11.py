from adventofcode.exercises import exercise_11
from adventofcode import utils

TEST_DATA = """5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"""


def test_example_on_exercise_a():
    assert exercise_11.run_a(TEST_DATA) == 1656


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_11.EXERCISE)
    assert exercise_11.run_a(input_data) == 1717


def test_example_on_exercise_b():
    assert exercise_11.run_b(TEST_DATA) == 195


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_11.EXERCISE)
    assert exercise_11.run_b(input_data) == 476
