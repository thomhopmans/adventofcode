from adventofcode.exercises import exercise_7

TEST_DATA = """16,1,2,0,4,2,7,1,2,14"""


def test_7a():
    assert exercise_7.run_a(TEST_DATA) == 7


def test_7b():
    assert exercise_7.run_b(TEST_DATA) == 5
