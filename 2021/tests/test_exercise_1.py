from adventofcode.exercises import exercise_1

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


def test_1a_returns_7_for_test_data():
    assert exercise_1.run_a(TEST_DATA) == 7


def test_1b_returns_5_for_test_data():
    assert exercise_1.run_b(TEST_DATA) == 5
