from loguru import logger

from adventofcode import utils
from adventofcode.exercises.helpers.graph import Graph

EXERCISE = 12


def main():
    input_data = utils.load_data(EXERCISE)
    logger.info(f"Exercise {EXERCISE}A: {run_a(input_data)}")
    logger.info(f"Exercise {EXERCISE}B: {run_b(input_data)}")


def run_a(input_data: str):
    graph = parse_data(input_data)
    start_node = "start"
    target_node = "end"

    final_paths = []

    # Depth-first search
    def dfs(node, path):
        if node == target_node:
            final_paths.append(path)
            return path

        for edge in graph.edges[node]:
            other_node = edge["node"]
            if (other_node == other_node.upper()) or (other_node not in path):
                dfs(other_node, path + [other_node])

        return

    dfs(start_node, [start_node])

    return len(final_paths)


def run_b(input_data: str):
    graph = parse_data(input_data)
    start_node = "start"
    target_node = "end"

    final_paths = []

    # Depth-first search
    def dfs(node, path):
        if node == target_node:
            final_paths.append(path)
            return path

        for edge in graph.edges[node]:
            other_node = edge["node"]

            if other_node == "start":
                continue

            # check if path does not contain two lowercase letters
            if (
                (other_node == other_node.upper())
                or (other_node not in path)
                or (other_node in path and max_lowercase_value_counts(path) == 1)
            ):
                dfs(other_node, path + [other_node])

        return

    dfs(start_node, [start_node])

    return len(final_paths)


def max_lowercase_value_counts(path: list[str]) -> int:
    lowercase_counts = [path.count(c) for c in path if c.islower()]
    if len(lowercase_counts) == 0:
        return 0
    return max(lowercase_counts)


def parse_data(input_data: str) -> Graph:
    graph = Graph()
    for line in input_data.strip().split("\n"):
        start_node, end_node = line.split("-")
        graph.add_node(start_node)
        graph.add_node(end_node)
        graph.add_edge(start_node, end_node, 1)
        graph.add_edge(end_node, start_node, 1)
    return graph


if __name__ == "__main__":
    main()
