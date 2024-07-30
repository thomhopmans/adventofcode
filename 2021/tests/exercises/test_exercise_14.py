from adventofcode.exercises import exercise_14
from adventofcode import utils

TEST_DATA = """NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"""


def test_example_on_exercise_a():
    assert exercise_14.run_a(TEST_DATA) == 1588


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_14.EXERCISE)
    assert exercise_14.run_a(input_data) == 2712


def test_example_on_exercise_b():
    assert exercise_14.run_b(TEST_DATA) == 2188189693529


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_14.EXERCISE)
    assert exercise_14.run_b(input_data) == 8336623059567
