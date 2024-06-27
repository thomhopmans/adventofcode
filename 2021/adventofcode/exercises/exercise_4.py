from loguru import logger
import numpy as np

from adventofcode import utils

EXERCISE = 4


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(data):
    drawn_numbers, boards = parse_data(data)
    return calculate_winner_score(drawn_numbers, boards)


def run_b(data):
    drawn_numbers, boards = parse_data(data)
    return calculate_score_of_last_winning_board(drawn_numbers, boards)


def parse_data(data: str) -> tuple[list[int], dict[int, np.array]]:
    data = data.splitlines()
    drawn_numbers = [int(i) for i in data[0].split(",")]

    # Boards
    n_boards = int((len(data[2:]) + 1) / 6)
    # logger.info(f"Number of boards: {n_boards}")

    boards = dict()
    for i in range(n_boards):
        board_numbers = data[2 + (i * 6) : 2 + 5 + (i * 6)]
        board_numbers = [
            b.lstrip().replace("  ", " ").split(" ") for b in board_numbers
        ]
        board_numbers = [[int(col) for col in row] for row in board_numbers]
        boards[i] = np.array(board_numbers)

    return drawn_numbers, boards


def calculate_winner_score(drawn_numbers, boards):
    n_boards = len(boards)
    masks = {i: np.ones((5, 5)) for i in range(n_boards)}

    winners = []
    for selected in drawn_numbers:
        # logger.info(f"Drawn number: {selected}")

        # Update boards and masks
        for (index, board) in boards.items():
            update = np.where(board == selected)
            masks[index][update] = 0.0

        # Find winner
        for (index, mask) in masks.items():
            if is_winner(mask):
                # logger.info(f"Board {index} is a WINNER")
                winners.append(index)

        if len(winners) > 0:
            break

    for index in winners:
        score = calculate_score(boards[index], masks[index], selected)
        # logger.info(f"Score of board {index} is {score}")

    return score


def calculate_score_of_last_winning_board(drawn_numbers, boards):
    n_boards = len(boards)
    masks = {i: np.ones((5, 5)) for i in range(n_boards)}

    winners = []
    for selected in drawn_numbers:
        # logger.info(f"Drawn number: {selected}")

        # Update boards and masks
        for (index, board) in boards.items():
            update = np.where(board == selected)
            masks[index][update] = 0.0

        # Find winners
        for (index, mask) in masks.items():
            if is_winner(mask) and index not in winners:
                # logger.info(f"Board {index} is a WINNER")
                winners.append(index)

        if len(winners) == len(boards):
            break

    last_winner = winners[-1]
    score = calculate_score(boards[last_winner], masks[last_winner], selected)
    # logger.info(f"Score of board {last_winner} is {score}")

    return score


def is_winner(mask):
    # Vertical
    if len(np.where(mask.sum(axis=0) == 0.0)[0]) > 0:
        return True
    # Horizontal
    if len(np.where(mask.sum(axis=1) == 0.0)[0]) > 0:
        return True
    return False


def calculate_score(board, mask, latest_number):
    score = int(np.multiply(board, mask).sum() * latest_number)
    return score


if __name__ == "__main__":
    main()
