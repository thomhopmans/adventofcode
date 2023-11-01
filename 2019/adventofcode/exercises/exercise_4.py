def main(start, end):
    n_positives = sum([_meets_criteria(value) for value in range(start, end)])
    print(f"Numbers that meet criteria: {n_positives}")
    return n_positives


def _meets_criteria(value):
    # print(value, _has_two_identical_adjacent_digits_not_part_of_bigger_group(value), _is_non_decreasing(value))
    return (
        1
        if _has_two_identical_adjacent_digits_not_part_of_bigger_group(value)
        and _is_non_decreasing(value)
        else 0
    )


def _has_two_identical_adjacent_digits_not_part_of_bigger_group(value: int):
    value = str(value)

    for i in range(len(value) - 1):
        if value[i] == value[i + 1]:
            return True

    return False


def _has_two_identical_adjacent_digits(value: int):
    value = str(value)
    for i in range(len(value) - 1):
        if value[i] == value[i + 1]:
            return True
    return False


def _is_non_decreasing(value: int):
    value = str(value)
    for i in range(len(value) - 1):
        if int(value[i]) > int(value[i + 1]):
            return False
    return True


if __name__ == "__main__":
    puzzle_input = [235741, 706948]
    main(*puzzle_input)
