from adventofcode.exercises import exercise_24
from adventofcode import utils


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_24.EXERCISE)
    assert exercise_24.run_a(input_data) == "12934998949199"


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_24.EXERCISE)
    assert exercise_24.run_b(input_data) == "11711691612189"
