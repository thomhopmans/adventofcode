from adventofcode.exercises import exercise_6

TEST_DATA = """3,4,3,1,2"""


def test_6a():
    assert exercise_6.run_a(TEST_DATA) == 7


def test_6b():
    assert exercise_6.run_b(TEST_DATA) == 5
