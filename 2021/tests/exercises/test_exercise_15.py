from adventofcode.exercises import exercise_15
from adventofcode import utils

TEST_DATA = """1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"""


def test_example_on_exercise_a():
    assert exercise_15.run_a(TEST_DATA) == 40


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_15.EXERCISE)
    assert exercise_15.run_a(input_data) == 398


def test_example_on_exercise_b():
    assert exercise_15.run_b(TEST_DATA) == 315


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_15.EXERCISE)
    assert exercise_15.run_b(input_data) == 2817
