from adventofcode.exercises import exercise_2

TEST_DATA = """199
200
208
210
200
207
240
269
260
263"""


def test_2a():
    assert exercise_2.run_a(TEST_DATA) == 7


def test_2b():
    assert exercise_2.run_b(TEST_DATA) == 5
