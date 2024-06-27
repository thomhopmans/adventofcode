from adventofcode.exercises import exercise_5

TEST_DATA = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""


def test_5a():
    assert exercise_5.run_a(TEST_DATA) == 7


def test_5b():
    assert exercise_5.run_b(TEST_DATA) == 5
