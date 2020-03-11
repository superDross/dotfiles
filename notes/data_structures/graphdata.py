"""
Resources:
 - https://www.tutorialspoint.com/graph_theory/graph_theory_introduction.htm

 - https://www.tutorialspoint.com/data_structures_algorithms/graph_data_structure.htm

Graphs store data collections of points called vertices (Nodes) and
edges.

A vertex/node is a point of interest while an edge represents a path between two nodes.

In the below example the verices:
  V = [0, 1, 2, 3, 4]

The edges:
  E = [(0, 1), (1, 2), (2, 3), (3, 4), (0, 4), (1, 4), (1, 3)]

       0 ---- 1
       |     /| \
       |    / |  \
       |   /  |   2
       |  /   |  /
       | /    | /
       4 ---- 3
"""
from dataclasses import dataclass
from typing import List, Optional, Set, Dict


@dataclass
class Vertex:
    value: int
    adjacents: Set["Vertex"] = set()

    def __str__(self) -> str:
        if not self.adjacents:
            return super().__str__()
        return " ".join([f"{self.value} - {x.value}" for x in self.adjacents])

    def add_neighbour(self, vertex: "Vertex") -> None:
        self.adjacents.add(vertex)


class Graph:
    def __init__(self) -> None:
        self.vertices: Dict[Vertex] = {}

    def add_vertex(self, value: int) -> None:
        vertex = Vertex(value)
        self.vertices[value] = vertex

    def add_edge(self, frm: int, to: int) -> None:
        vertex = self.vertices[frm]
        adjacent_vertex = self.vertices[to]
        vertex.add_neighbour(adjacent_vertex)
