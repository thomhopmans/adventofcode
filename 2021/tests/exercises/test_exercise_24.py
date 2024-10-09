from adventofcode.exercises import exercise_24
from adventofcode import utils


TEST_DATA = """inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2
"""


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_24.EXERCISE)
    assert exercise_24.run_a(input_data) == "12934998949199"


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_24.EXERCISE)
    assert exercise_24.run_b(input_data) == "11711691612189"
