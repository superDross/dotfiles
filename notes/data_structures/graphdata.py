"""
Graphs are a nodes connected together but have less restrictions when compared to trees e.g. can have multiple parents.

Graphs can be used to map out thinks like airline flights, internet connections etc.

Trees can be thought of as specialised graphs.

Graphs store data collections of points called vertices (Nodes) and
edges.


Vertex (Node); a point of interest.

Edge; a path between two nodes.

Weight; cost/distance to traverse two nodes.

Path; sequence of vertices that is calculated by the sum of the weights from the first node to the last node.

Cycle; a path that starts and ends on the same vertex.


A graph with no cycles is called a acyclic graph while a directed graph with no cycles is called a directed acyclic graph (DAG).


In the below example the vertices:
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

Resources:
 - https://runestone.academy/ns/books/published/pythonds3/Graphs/Objectives.html
 - https://www.tutorialspoint.com/graph_theory/graph_theory_introduction.htm
 - https://www.tutorialspoint.com/data_structures_algorithms/graph_data_structure.htm
"""

from typing import Optional

EdgesData = list[tuple[int, int, int]]


class Vertex:
    """
    Represents a single node in a graph.
    """

    def __init__(self, key: int) -> None:
        self.id = key
        self.connected_to: dict["Vertex", int] = {}

    def __str__(self) -> str:
        return f"{self.id} connected to {[x.id for x in self.connected_to]}"

    def add_neighbor(self, neighbor: "Vertex", weight: int = 0) -> None:
        self.connected_to[neighbor] = weight

    def connections(self) -> list["Vertex"]:
        return list(self.connected_to.keys())

    def get_weight(self, neighbor: "Vertex") -> int:
        return self.connected_to[neighbor]


class Graph:
    def __init__(self):
        self.vert_list = {}
        self.number_vertices = 0

    def __contains__(self, vert_key: int) -> bool:
        return vert_key in self.vert_list

    def __iter__(self):
        return iter(self.vert_list.values())

    def get_vertex(self, key_value: int) -> Optional[Vertex]:
        return self.vert_list.get(key_value)

    def get_vertices(self) -> list[int]:
        return self.vert_list.keys()

    def get_connections(self) -> None:
        for vertex in self:
            for other_vertex in vertex.connections():
                print(vertex.id, "->", other_vertex.id)

    def add_vertex(self, key_value: int) -> Vertex:
        self.number_vertices += 1
        vertex = Vertex(key_value)
        self.vert_list[key_value] = vertex
        return vertex

    def add_edge(self, key_value1: int, key_value2: int, weight: int = 0) -> None:
        if key_value1 not in self.vert_list:
            self.add_vertex(key_value1)
        if key_value2 not in self.vert_list:
            self.add_vertex(key_value2)
        self.vert_list[key_value1].add_neighbor(self.vert_list[key_value2], weight)

    def add_edges(self, values: EdgesData) -> None:
        for data in values:
            self.add_edge(*data)


# creates a diamond shape from 1 to 4, with the shortest path as 1 -> 2 -> 4
values = [
    (1, 2, 3),
    (1, 3, 4),
    (2, 4, 1),
    (3, 4, 9),
]
graph = Graph()
graph.add_edges(values)

graph.get_connections()
