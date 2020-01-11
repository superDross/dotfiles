"""
Resources:
    - https://www.tutorialspoint.com/data_structures_algorithms/tree_data_structure.htm
"""

from dataclasses import dataclass
from typing import Optional, Tuple


@dataclass
class Node:
    """
    Binary Tree Node
    """

    value: int
    left: Optional["Node"] = None
    right: Optional["Node"] = None

    def values(self) -> Tuple[Optional[int], Optional[int], Optional[int]]:
        left_value = None if not self.left else self.left.value
        right_value = None if not self.right else self.right.value
        return left_value, self.value, right_value

    def print(self) -> None:
        left, value, right = self.values()
        print(f"\nNODE: {value}\nLeft: {left}\nRight: {right}")


class BinaryTree:
    """
    Binary Tree is a special data structure used for data storage purposes
    that have a maximum of two children.
    """

    def __init__(self, value: int) -> None:
        self.root: Node = Node(value)

    def insert(self, value: int, node: Optional[Node] = None) -> None:
        """
        Insert Node into tree
        """
        if not node:
            node = self.root
        if node.value:
            if value < node.value:
                self.insert_left(value, node)
            elif value > node.value:
                self.insert_right(value, node)
        else:
            node.value = value

    def insert_left(self, value: int, node: Node) -> None:
        """
        Insert Node into left branch
        """
        if not node.left:
            node.left = Node(value)
        else:
            self.insert(value, node.left)

    def insert_right(self, value: int, node: Node) -> None:
        """
        Insert Node into right branch
        """
        if not node.right:
            node.right = Node(value)
        else:
            self.insert(value, node.right)

    def print_tree(self, node: Optional["Node"] = None) -> None:
        """
        Prints every Node in the tree
        """
        if not node:
            node = self.root
        if node.left or node.right:
            node.print()
        if node.left:
            self.print_tree(node.left)
        if node.right:
            self.print_tree(node.right)


class BinarySearchTree(BinaryTree):
    """
    A Binary Search Tree (BST) left node must have a value less than its parent,
    while the right node must have a value greater than its parent value.
    """

    def __init__(self, value: int) -> None:
        super().__init__(value)

    def search(self, value: int, node: Optional[Node] = None) -> Optional[Node]:
        """
        Return Node that matches the given value
        """
        if not node:
            node = self.root
        if node.value:
            if value == node.value:
                return node
            elif node.left and value < node.value:
                return self.search(value, node.left)
            elif node.right and value > node.value:
                return self.search(value, node.right)
        return None


def create_tree():
    # bst
    #   10
    #  5  20
    bst = BinarySearchTree(10)

    # bst.left
    #   5
    #  3 8
    bst.insert(5)
    bst.insert(3)
    bst.insert(8)

    # bst.right
    #   20
    # 12  25
    bst.insert(20)
    bst.insert(12)
    bst.insert(25)

    # bst.right.right
    #   25
    # NA  30
    bst.insert(30)
    return bst


# insertion
bst = create_tree()
assert (5, 10, 20) == bst.root.values()
assert (3, 5, 8) == bst.root.left.values()
assert (12, 20, 25) == bst.root.right.values()
assert (None, 25, 30) == bst.root.right.right.values()

# searching
node = bst.search(25)
assert (None, 25, 30) == node.values()
bst.root.print()
