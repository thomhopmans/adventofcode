from loguru import logger
from dataclasses import dataclass

from adventofcode import utils

EXERCISE = 8


@dataclass
class Display:
    signal_patterns: list[str]
    output_patterns: list[str]
    output_digits: str | None = None

    def signals_with_n_wires(self, n: int):
        return [x for x in self.signal_patterns if len(x) == n]


@dataclass
class Pattern:
    wires: list[str]

    def __len__(self):
        return len(self.wires)


@dataclass
class SignalWirePattern:
    ALL_WIRES = "abcdefg"

    top = "?"
    top_left = "?"
    top_right = "?"
    middle = "?"
    bottom_left = "?"
    bottom_right = "?"
    bottom = "?"

    def __repr__(self):
        return f" {self.top} \n{self.top_left} {self.top_right}\n {self.middle} \n{self.bottom_left} {self.bottom_right}\n {self.bottom} "

    def digit_0_wires(self):
        return sorted(
            [
                self.top_left,
                self.top,
                self.top_right,
                self.bottom_right,
                self.bottom,
                self.bottom_left,
            ]
        )

    def digit_1_wires(self):
        return sorted([self.top_right, self.bottom_right])

    def digit_2_wires(self):
        return sorted(
            [self.top, self.top_right, self.middle, self.bottom_left, self.bottom]
        )

    def digit_3_wires(self):
        return sorted(
            [self.top, self.top_right, self.middle, self.bottom_right, self.bottom]
        )

    def digit_4_wires(self):
        return sorted([self.top_left, self.middle, self.top_right, self.bottom_right])

    def digit_5_wires(self):
        return sorted(
            [self.top, self.top_left, self.middle, self.bottom_right, self.bottom]
        )

    def digit_6_wires(self):
        return sorted(
            [
                self.top,
                self.top_left,
                self.middle,
                self.bottom_right,
                self.bottom,
                self.bottom_left,
            ]
        )

    def digit_7_wires(self):
        return sorted([self.top, self.top_right, self.bottom_right])

    def digit_8_wires(self):
        return sorted(list(self.ALL_WIRES))

    def digit_9_wires(self):
        return sorted(
            [
                self.middle,
                self.top_left,
                self.top,
                self.top_right,
                self.bottom_right,
                self.bottom,
            ]
        )

    def pattern_to_digit(self, pattern: Pattern) -> str:
        signal = list(sorted(pattern.wires))

        if signal == self.digit_0_wires():
            return "0"
        elif signal == self.digit_1_wires():
            return "1"
        elif signal == self.digit_2_wires():
            return "2"
        elif signal == self.digit_3_wires():
            return "3"
        elif signal == self.digit_4_wires():
            return "4"
        elif signal == self.digit_5_wires():
            return "5"
        elif signal == self.digit_6_wires():
            return "6"
        elif signal == self.digit_7_wires():
            return "7"
        elif signal == self.digit_8_wires():
            return "8"
        elif signal == self.digit_9_wires():
            return "9"
        else:
            raise ValueError(f"Unknown signal {pattern.wires}")


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    displays = parse_data(input_data)

    easy_digits = 0
    for display in displays:
        output_lengths = [len(s) for s in display.output_patterns]
        value_counts = _value_counts(output_lengths)
        easy_digits += (
            value_counts[2] + value_counts[3] + value_counts[4] + value_counts[7]
        )
    return easy_digits


def _value_counts(value: str):
    return {digit: value.count(digit) for digit in range(2, 8)}


def parse_data(input_data: str) -> list[Display]:
    lines = input_data.splitlines()
    displays = []
    for line in lines:
        patterns = line.replace(" | ", " ").split(" ")
        signal_patterns = [Pattern(wires=x) for x in patterns[:10]]
        output_patterns = [Pattern(wires=x) for x in patterns[10:]]
        displays.append(
            Display(signal_patterns=signal_patterns, output_patterns=output_patterns)
        )
    return displays


def run_b(input_data: str):
    displays = parse_data(input_data)

    for display in displays:
        signal_wire_pattern = SignalWirePattern()

        digit_to_wires = {}

        # Find digit one with two wires
        digit_to_wires[1] = display.signals_with_n_wires(2)[0].wires

        # Find digit seven with three wires
        digit_to_wires[7] = display.signals_with_n_wires(3)[0].wires

        signal_wire_pattern.top = _outersection(digit_to_wires[7], digit_to_wires[1])[0]

        # Find digit four with four wires
        digit_to_wires[4] = display.signals_with_n_wires(4)[0].wires

        # Find digit eight with seven wires
        digit_to_wires[8] = display.signals_with_n_wires(7)[0].wires

        # Find the three digits with six wires
        six_wires = [d.wires for d in display.signals_with_n_wires(6)]
        wires_for_digit_four_minus_one = _outersection(
            digit_to_wires[4], digit_to_wires[1]
        )

        for wire in six_wires:
            # Digit 6
            if (digit_to_wires[1][0] in wire and digit_to_wires[1][1] not in wire) or (
                digit_to_wires[1][1] in wire and digit_to_wires[1][0] not in wire
            ):
                signal_wire_pattern.top_right = (
                    digit_to_wires[1][1]
                    if digit_to_wires[1][0] in wire
                    else digit_to_wires[1][0]
                )
                signal_wire_pattern.bottom_right = (
                    digit_to_wires[1][0]
                    if digit_to_wires[1][0] in wire
                    else digit_to_wires[1][1]
                )

                digit_to_wires[6] = wire
            # Digit 0
            elif (
                wires_for_digit_four_minus_one[0] in wire
                and wires_for_digit_four_minus_one[1] not in wire
            ) or (
                wires_for_digit_four_minus_one[1] in wire
                and wires_for_digit_four_minus_one[0] not in wire
            ):
                signal_wire_pattern.middle = (
                    wires_for_digit_four_minus_one[1]
                    if wires_for_digit_four_minus_one[1] not in wire
                    else wires_for_digit_four_minus_one[0]
                )

                digit_to_wires[0] = wire

            # Digit 9
            else:
                signal_wire_pattern.bottom_left = _outersection("abcdefg", wire)[0]
                digit_to_wires[9] = wire

        signal_wire_pattern.top_left = _outersection(
            digit_to_wires[4],
            [
                signal_wire_pattern.top_right,
                signal_wire_pattern.bottom_right,
                signal_wire_pattern.middle,
            ],
        )[0]

        signal_wire_pattern.bottom = _outersection(
            "abcdefg",
            [
                signal_wire_pattern.top,
                signal_wire_pattern.top_left,
                signal_wire_pattern.top_right,
                signal_wire_pattern.middle,
                signal_wire_pattern.bottom_left,
                signal_wire_pattern.bottom_right,
            ],
        )[0]

        # digit_to_wires
        display.output_digits = int(
            "".join(
                [
                    signal_wire_pattern.pattern_to_digit(pattern)
                    for pattern in display.output_patterns
                ]
            )
        )

    return sum([d.output_digits for d in displays])


def _outersection(a: list[str], b: list[str]) -> list[str]:
    return [x for x in a if x not in b]


if __name__ == "__main__":
    main()
