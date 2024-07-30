from adventofcode.exercises import exercise_13
from adventofcode import utils

TEST_DATA = """6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"""


def test_example_on_exercise_a():
    assert exercise_13.run_a(TEST_DATA) == 17


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_13.EXERCISE)
    assert exercise_13.run_a(input_data) == 735


# def test_example_on_exercise_b():
#     assert exercise_13.run_b(TEST_DATA) == """#####
# #...#
# #...#
# #...#
# #####
# .....
# ....."""


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_13.EXERCISE)
    assert exercise_13.run_b(input_data) == """#..#.####.###..####.#..#..##..#..#.####.
#..#.#....#..#....#.#.#..#..#.#..#....#.
#..#.###..#..#...#..##...#..#.#..#...#..
#..#.#....###...#...#.#..####.#..#..#...
#..#.#....#.#..#....#.#..#..#.#..#.#....
.##..#....#..#.####.#..#.#..#..##..####."""
