class Graph:
    def __init__(self):
        self.nodes = []
        self.edges = {}

    def add_node(self, node):
        if node not in self.nodes:
            self.nodes.append(node)
            self.edges[node] = []

    def add_edge(self, node1, node2, weight):
        self.edges[node1].append({"node": node2, "weight": weight})
