from collections import Counter

from loguru import logger

from adventofcode import utils

EXERCISE = 14


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    return run_steps(input_data=input_data, n_steps=10)


def run_b(input_data: str):
    return run_steps(input_data=input_data, n_steps=40)


def run_steps(input_data: str, n_steps: int) -> int:
    polymer_template, insertion_rules = parse_data(input_data)

    # Calculate what each possible pair will lead to after 1 step
    mapping = {}
    for pair, insert_char in insertion_rules.items():
        value_counts = Counter()
        value_counts[pair[0] + insert_char] += 1
        value_counts[insert_char + pair[1]] += 1
        mapping[pair] = value_counts

    # Count pairs in starting polymer
    current_counters = Counter()
    for i in range(len(polymer_template) - 1):
        pair = "".join(polymer_template[i : i + 2])
        current_counters[pair] += 1

    # Apply recursive counters, e.g. NN will always lead to a fixed set of pairs after X iterations
    # so we can multiply the count of present NN with the count of the pairs it will lead to
    for i in range(0, n_steps):
        new_counters = Counter()
        for key, value in current_counters.items():
            new_counters += multiply_counter_by_int(mapping[key], value)
        current_counters = Counter({key: value for key, value in new_counters.items()})

    # Remove first character from keys, i.e. "NN" -> "N", and add the last character of the polymer
    first_char_counter = Counter()
    for key, value in new_counters.items():
        first_char_counter[key[0]] += value
    first_char_counter += Counter({polymer_template[-1]: 1})

    # Result of most common - least common
    max_arg = max(first_char_counter, key=first_char_counter.get)
    min_arg = min(first_char_counter, key=first_char_counter.get)

    return first_char_counter[max_arg] - first_char_counter[min_arg]


def parse_data(input_data: str) -> tuple[str, dict[str, str]]:
    polymer_template, insertion_rules = input_data.strip().split("\n\n")
    polymer_template = list(polymer_template)
    insertion_rules = dict([rule.split(" -> ") for rule in insertion_rules.split("\n")])

    return polymer_template, insertion_rules


def multiply_counter_by_int(counter, n):
    return Counter({key: value * n for key, value in counter.items()})


if __name__ == "__main__":
    main()
