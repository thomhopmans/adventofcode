from adventofcode.exercises import exercise_23
from adventofcode import utils


TEST_DATA = """#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
"""

def test_example_on_exercise_a():
    assert exercise_23.run_a(TEST_DATA) == 12521


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_23.EXERCISE)
    assert exercise_23.run_a(input_data) == 19160


def test_example_on_exercise_b():
    assert exercise_23.run_b(TEST_DATA) == 44169


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_23.EXERCISE)
    assert exercise_23.run_b(input_data) == 47232
