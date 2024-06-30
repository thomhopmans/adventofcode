import pytest

from adventofcode.exercises import exercise_3
from adventofcode import utils


@pytest.mark.parametrize(
    "test_input,expected",
    [
        ["R8,U5,L5,D3\nU7,R6,D4,L4", 6],
        ["R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 159],
        ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", 135]
    ],
)
def test_two_wire_examples_on_exercise_a(test_input, expected):
    assert exercise_3.run_a(test_input) == expected


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_3.EXERCISE)
    assert exercise_3.run_a(input_data) == 248


@pytest.mark.parametrize(
    "test_input,expected",
    [
        ["R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 610],
        ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", 410]
    ],
)
def test_two_wire_examples_on_exercise_b(test_input, expected):
    assert exercise_3.run_b(test_input) == expected



def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_3.EXERCISE)
    assert exercise_3.run_b(input_data) == 28580
