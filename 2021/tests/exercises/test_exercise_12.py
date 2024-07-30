from adventofcode.exercises import exercise_12
from adventofcode import utils

TEST_DATA_SMALL = """start-A
start-b
A-c
A-b
b-d
A-end
b-end"""

TEST_DATA_LARGE = """dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

TEST_DATA_EVEN_LARGER = """fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"""


def test_small_example_on_exercise_a():
    assert exercise_12.run_a(TEST_DATA_SMALL) == 10


def test_large_example_on_exercise_a():
    assert exercise_12.run_a(TEST_DATA_LARGE) == 19


def test_even_larger_example_on_exercise_a():
    assert exercise_12.run_a(TEST_DATA_EVEN_LARGER) == 226


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_12.EXERCISE)
    assert exercise_12.run_a(input_data) == 3463


def test_small_example_on_exercise_b():
    assert exercise_12.run_b(TEST_DATA_SMALL) == 36


def test_large_example_on_exercise_b():
    assert exercise_12.run_b(TEST_DATA_LARGE) == 103


def test_even_larger_example_on_exercise_b():
    assert exercise_12.run_b(TEST_DATA_EVEN_LARGER) == 3509


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_12.EXERCISE)
    assert exercise_12.run_b(input_data) == 91533
