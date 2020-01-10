"""
Binary Tree is a special datastructure used for data storage purposes.

There must be a maxmimum of two children.

A Binary Search Tree (BST) left node must have a value less than its parent,
while the right node must have a value greater than its parent value.

This is a basic BST implementation.


https://www.tutorialspoint.com/data_structures_algorithms/tree_data_structure.htm
"""
from typing import Optional

# TODO:
#  - return instead of printing (issues with multiple


class Node:
    """
    Represents a BST node
    """

    def __init__(self, data: int) -> None:
        self.left: Optional[Node] = None
        self.right: Optional[Node] = None
        self.data: int = data

    def search(self, data: int, node: Optional["Node"] = None) -> Optional["Node"]:
        """
        Print Node that matches the given data
        """
        if not node:
            node = self
        if node.data:
            if data == node.data:
                return node
            elif node.left and data < node.data:
                return self.search(data, node.left)
            elif node.right and data > node.data:
                return self.search(data, node.right)
        return None

    def insert(self, data: int) -> None:
        """
        Insert Node into tree
        """
        if self.data:
            if data < self.data:
                self.insert_left(data)
            elif data > self.data:
                self.insert_right(data)
        else:
            self.data = data

    def insert_left(self, data: int) -> None:
        """
        Insert Node into left branch
        """
        if not self.left:
            self.left = Node(data)
        else:
            self.left.insert(data)

    def insert_right(self, data: int) -> None:
        """
        Insert Node into right branch
        """
        if not self.right:
            self.right = Node(data)
        else:
            self.right.insert(data)

    def print(self) -> None:
        """
        Print this Node
        """
        print(f"\nNODE: {self.data}")
        if self.left:
            print(f"Left: {self.left.data}")
        if self.right:
            print(f"Right: {self.right.data}")

    def print_tree(self, node: Optional["Node"] = None) -> None:
        """
        Prints every Node in the tree
        """
        if not node:
            node = self
        if node.left or node.right:
            node.print()
        if node.left:
            node.print_tree(node.left)
        if node.right:
            node.print_tree(node.right)


def create_test_case():
    # root
    #   10
    #  5  20
    root = Node(10)

    # root.left
    #   5
    #  3 8
    root.insert(5)
    root.insert(3)
    root.insert(8)

    # root.right
    #   20
    # 12  25
    root.insert(20)
    root.insert(12)
    root.insert(25)

    # root.right.right
    #   25
    # NA  30
    root.insert(30)
    return root


# insertion
root = create_test_case()
assert (5, 10, 20) == (root.left.data, root.data, root.right.data)
assert (3, 5, 8) == (root.left.left.data, root.left.data, root.left.right.data)
assert (12, 20, 25) == (root.right.left.data, root.right.data, root.right.right.data)
assert (None, 25, 30) == (
    root.right.right.left,
    root.right.right.data,
    root.right.right.right.data,
)

# searching
node = root.search(25)
assert (None, 25, 30) == (node.left, node.data, node.right.data)
