import functools
import re

from loguru import logger

from adventofcode import utils

EXERCISE = 21


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    position_players = parse_data(input_data)
    return roll_deterministic(position_players[0], position_players[1], 0, 0, 0)


def roll_deterministic(
    position_player1, position_player2, score_player1, score_player2, dice_i
):
    if score_player2 >= 1000:
        return dice_i * score_player1

    position_player1 = (position_player1 + 3 * dice_i + 6) % 10 or 10
    return roll_deterministic(
        position_player2,
        position_player1,
        score_player2,
        score_player1 + position_player1,
        dice_i + 3,
    )


def run_b(input_data: str):
    position_players = parse_data(input_data)

    return max(roll_dirac(position_players[0], position_players[1], 0, 0))


@functools.cache
def roll_dirac(position_player1, position_player2, score_player1, score_player2):
    if score_player2 >= 21:
        return 0, 1

    # Possible outcomes for the dice rolls:
    #   - a 3 is possible in one scenario (1+1+1)
    #   - a 4 in three scenarios (1+1+2, 1+2+1, 2+1+1)
    #   ...
    dirac_dice_outcome_probabilities = [
        (3, 1),
        (4, 3),
        (5, 6),
        (6, 7),
        (7, 6),
        (8, 3),
        (9, 1),
    ]

    wins_player1, wins_player2 = 0, 0

    for move, n in dirac_dice_outcome_probabilities:
        new_position_player1 = (position_player1 + move) % 10 or 10

        wins_2, wins_1 = roll_dirac(
            position_player2,
            new_position_player1,
            score_player2,
            score_player1 + new_position_player1,
        )

        # Update wins and multiply by the number of possible outcomes
        wins_player1 = wins_player1 + n * wins_1
        wins_player2 = wins_player2 + n * wins_2

    return wins_player1, wins_player2


def parse_data(input_data: str) -> list[int, int]:
    # Parse starting positions from the following two lines using regex:
    #   Player 1 starting position: 4
    #   Player 2 starting position: 8
    start_positions = list(
        map(int, re.findall(r"Player \d starting position: (\d+)", input_data))
    )
    return start_positions


if __name__ == "__main__":
    main()
