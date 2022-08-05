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


class Graph:
    """
    Dijkstra’s shortest path algorithm.
    """

    def __init__(self, edges: list[Edge]) -> None:
        self.nodes = sorted({Node(edge.start) for edge in edges})
        self.edges = edges
        self.distances = {
            (edge.start, edge.finish): edge.distance for edge in self.edges
        }

    def calculate(self, node_to: str):

        for node1 in self.nodes:
            for node2 in self.nodes:
                if distance := self.distances.get((node1.name, node2.name)):
                    if not node2.distance:
                        node2.distance = distance


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
print(graph.distances)
graph.calculate("G")
