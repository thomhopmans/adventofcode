import pytest

from adventofcode.exercises import exercise_16
from adventofcode import utils


@pytest.mark.parametrize(
    "input_data,expected",
    [
        ("8A004A801A8002F478", 16),
        ("620080001611562C8802118E34", 12),
        ("C0015000016115A2E0802F182340", 23),
        ("A0016C880162017C3686B18A3D4780", 31),
    ],
)
def test_example_on_exercise_a(input_data, expected):
    assert exercise_16.run_a(input_data) == expected


def test_returns_correct_answer_on_exercise_a():
    input_data = utils.load_data(exercise_16.EXERCISE)
    assert exercise_16.run_a(input_data) == 866


@pytest.mark.parametrize(
    "input_data,expected",
    [
        ("C200B40A82", 3),
        ("04005AC33890", 54),
        ("880086C3E88112", 7),
        ("CE00C43D881120", 9),
        ("D8005AC2A8F0", 1),
        ("F600BC2D8F", 0),
        ("9C005AC2F8F0", 0),
        ("9C0141080250320F1802104A08", 1),
        ("8A004A801A8002F478", 15),
        ("3232D42BF9400", 5000000000),
        ("26008C8E2DA0191C5B400", 10000000000),
    ],
)
def test_example_on_exercise_b(input_data, expected):
    assert exercise_16.run_b(input_data) == expected


def test_returns_correct_answer_on_exercise_b():
    input_data = utils.load_data(exercise_16.EXERCISE)
    assert exercise_16.run_b(input_data) == 1392637195518
