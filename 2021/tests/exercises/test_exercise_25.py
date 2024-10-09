from adventofcode.exercises import exercise_25
from adventofcode import utils


TEST_DATA = """v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
"""


def test_example_on_exercise_a():
    assert exercise_25.run_a(TEST_DATA) == 58


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_25.EXERCISE)
    assert exercise_25.run_a(input_data) == 400
