from loguru import logger
import heapq

from adventofcode import utils

EXERCISE = 23

COSTS = {
    "A": 1,
    "B": 10,
    "C": 100,
    "D": 1000,
}
ROOMS = {
    "A": 2,
    "B": 4,
    "C": 6,
    "D": 8,
}
ROOM_INDEX = set(ROOMS.values())


class Node:
    def __init__(self, state, costs=0):
        self.state = state
        self.costs = costs

    def __repr__(self) -> str:
        return f"{self.state} (costs={self.costs})"

    def __eq__(self, other: "Node") -> bool:
        return self.state == other.state

    def __lt__(self, other: "Node") -> bool:
        # To pop the node with the lowest costs in the heapq
        return self.costs < other.costs


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str) -> int:
    start = parse_data(input_data)
    end = [".", ".", "AA", ".", "BB", ".", "CC", ".", "DD", ".", "."]

    energy = a_star(Node(start), Node(end))
    return energy


def run_b(input_data: str) -> int:
    start = parse_data(input_data, unfold=True)
    end = [".", ".", "AAAA", ".", "BBBB", ".", "CCCC", ".", "DDDD", ".", "."]

    energy = a_star(Node(start), Node(end))
    return energy


def parse_data(input_data: str, unfold: bool = False) -> list[str]:
    lines = input_data.splitlines()

    # Extracting upper burrow pods
    burrows = [lines[2][i] for i in range(3, 10, 2)]

    # Append additional characters for part two
    if unfold:
        burrows = [b + ext for b, ext in zip(burrows, ["DD", "CB", "BA", "AC"])]

    # Adding bottom burrow pods
    burrows = [b + lines[3][i] for b, i in zip(burrows, range(3, 10, 2))]

    # Constructing the state with dots and burrows
    state = [".", "."] + sum([[b, "."] for b in burrows], []) + ["."]

    return state


def a_star(start_node: Node, end_node: Node) -> int:
    queue: list[Node] = []
    visited: dict[str, int] = {tuple(start_node.state): 0}

    heapq.heappush(queue, start_node)

    while queue:
        # Get the current node (lowest f value)
        current_node: Node = heapq.heappop(queue)

        # If we've reached the goal
        if current_node == end_node:
            return current_node.costs

        # Generate possible moves
        state = current_node.state

        for character_index, pod in enumerate(state):
            if get_upper_pod(pod) is None:
                continue

            character_destinations = possible_moves(state, character_index)
            for destination in character_destinations:
                new_state, move_costs = move(state, character_index, destination)
                new_costs = current_node.costs + move_costs
                new_node = Node(new_state, new_costs)

                # check if new state is already visited against lower costs
                best_costs = visited.get(tuple(new_node.state), 999999999)
                if new_costs < best_costs:
                    visited[tuple(new_node.state)] = new_node.costs
                    heapq.heappush(queue, new_node)

    raise ValueError("No solution found")


def can_reach(state: list[str], start_index: int, end_index: int) -> bool:
    """Checks for any pod blocking the path from start index to end index."""

    # Bi-directional check
    a = min(start_index, end_index)
    b = max(start_index, end_index)

    for pos in range(a, b + 1):
        if pos == start_index:
            continue
        if pos in ROOM_INDEX:
            continue
        if state[pos] != ".":
            return False
    return True


def room_only_contains_goal(state: list[str], pod: str, dest_pos: int) -> bool:
    in_room = state[dest_pos]
    return len(in_room) == in_room.count(".") + in_room.count(pod)


def get_upper_pod(room: str) -> str:
    for c in room:
        if c != ".":
            return c


def add_pod_to_room(pod: str, room: str) -> tuple[str, int]:
    room = list(room)
    dist = room.count(".")
    room[dist - 1] = pod

    return "".join(room), dist


def possible_moves(state: list[str], index: int) -> list[int]:
    pod = state[index]

    if index not in ROOM_INDEX:
        if can_reach(state, index, ROOMS[pod]) and room_only_contains_goal(
            state, pod, ROOMS[pod]
        ):
            return [ROOMS[pod]]
        else:
            return []

    moving_pod = get_upper_pod(pod)

    if index == ROOMS[moving_pod] and room_only_contains_goal(
        state, moving_pod, index
    ):
        return []

    possible = []
    for dest in range(len(state)):
        if dest == index:
            continue

        if dest in ROOM_INDEX and ROOMS[moving_pod] != dest:
            continue

        if ROOMS[moving_pod] == dest:
            if not room_only_contains_goal(state, moving_pod, dest):
                continue

        if can_reach(state, index, dest):
            possible.append(dest)

    return possible


def move(state: list[str], index: int, dest: int) -> tuple[list[str], int]:
    new_state = state[:]
    dist = 0
    moving_pod = get_upper_pod(state[index])

    # From the current position
    if len(state[index]) == 1:  # Non-burrow
        new_state[index] = "."
    else:  # Burrow
        new_room = ""
        found = False
        for c in state[index]:
            if c == ".":
                dist += 1
                new_room += c
            elif not found:
                new_room += "."
                dist += 1
                found = True
            else:
                new_room += c
        new_state[index] = new_room

    dist += abs(index - dest)

    # To the destination
    if len(state[dest]) == 1:  # Non-burrow
        new_state[dest] = moving_pod

        return new_state, dist * COSTS[moving_pod]
    else:  # Burrow
        new_state[dest], addl_dist = add_pod_to_room(moving_pod, state[dest])
        dist += addl_dist

        return new_state, dist * COSTS[moving_pod]


if __name__ == "__main__":
    main()
