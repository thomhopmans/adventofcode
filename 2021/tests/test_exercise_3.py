from adventofcode.exercises import exercise_3

TEST_DATA = ""


def test_3a():
    assert exercise_3.run_a(TEST_DATA) == 7


def test_3b():
    assert exercise_3.run_b(TEST_DATA) == 5
