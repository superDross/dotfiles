"""
Given a graph and a source vertex in the graph find the shortest paths
from source to all vertices in the given graph.

Explanation of the algo: https://www.youtube.com/watch?v=gdmfOwyQlcI
"""
from dataclasses import dataclass
from typing import Optional


@dataclass
class Edge:
    start: str
    finish: str
    distance: int


@dataclass(unsafe_hash=True, order=True)
class Node:
    name: str
    distance: Optional[int] = None
    previous_node: Optional["Node"] = None


class Graph:
    """
    Dijkstra’s shortest path algorithm.
    """

    def __init__(self, edges: list[Edge]) -> None:
        self.nodes = {Node(edge.start) for edge in edges}
        self.edges = edges
        self.distances = {
            (edge.start, edge.finish): edge.distance for edge in self.edges
        }

    def calculate(self, starting_node: str) -> list[Node]:
        shortest_path = None
        visited = []
        starting_node = Node(starting_node, 0)

        # get initial distances
        for node in self.nodes:
            if distance := self.distances.get((starting_node.name, node.name)):
                if not node.distance:
                    node.distance = distance
                    node.previous_node = starting_node

                    if not shortest_path:
                        node = shortest_path







graph = Graph(
    [
        Edge("A", "B", 2),
        Edge("A", "C", 1),
        Edge("B", "C", 11),
        Edge("B", "D", 1),
        Edge("B", "E", 3),
        Edge("C", "F", 8),
        Edge("D", "E", 4),
        Edge("E", "G", 9),
        Edge("F", "G", 10),
    ]
)

# Shortest: A, B, E, G (14)
graph.calculate("A")
