"""
The left node must ALWAYS have a value less than it's parents value.

Resources:
    - https://www.tutorialspoint.com/data_structures_algorithms/tree_data_structure.htm
"""

from dataclasses import dataclass
from typing import List, Optional, Tuple


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

    def print(self, ascii_img: bool =False) -> None:
        left, value, right = self.values()
        if ascii_img:
            print(f"\n  {value}\n / \ \n{left}  {right}")
        else:
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

    def preorder_traversal(
        self, node: Optional[Node] = None, nodes: List[int] = []
    ) -> List[int]:
        """
        A list showing traversal from root and down the left subtree and
        then down the right subtree.

        Traversal Notes:
         https://www.tutorialspoint.com/data_structures_algorithms/tree_traversal.htm
        """
        if node:
            nodes.append(node.value)
            self.preorder_traversal(node.left, nodes)
            self.preorder_traversal(node.right, nodes)
        return nodes

    def postorder_traversal(
        self, node: Optional[Node] = None, nodes: List[int] = []
    ) -> List[int]:
        """
        A list showing traversal from the bottom of the left subtree, then
        the right subtree and finally the root.
        """
        if node:
            self.postorder_traversal(node.left, nodes)
            self.postorder_traversal(node.right, nodes)
            nodes.append(node.value)
        return nodes

    def inorder_traversal(
        self, node: Optional[Node] = None, nodes: List[int] = []
    ) -> List[int]:
        """
        Returns a list of values in sorted order by visiting the
        left subtree, the root, then the right subtree.
        """
        if node:
            self.inorder_traversal(node.left, nodes)
            nodes.append(node.value)
            self.inorder_traversal(node.right, nodes)
        return nodes


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
    """
            10
            / \
           /   \
          /     \
         6      20
        / \     / \
       4   8  12  25
      / \           \
     1   5          30

    """
    # bst
    #   10
    #  6  20
    bst = BinarySearchTree(10)

    # bst.left
    #   6
    #  4 8
    bst.insert(6)
    bst.insert(4)
    bst.insert(8)

    # bst.left.left
    #   4
    #  1 5
    bst.insert(4)
    bst.insert(1)
    bst.insert(5)

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
    bst.insert(23)
    return bst


# insertion
bst = create_tree()
assert (6, 10, 20) == bst.root.values()
assert (4, 6, 8) == bst.root.left.values()
assert (12, 20, 25) == bst.root.right.values()
assert (23, 25, 30) == bst.root.right.right.values()

# searching
node = bst.search(25)
assert (23, 25, 30) == node.values()

# traversal
preorder_traversal = bst.preorder_traversal(bst.root)
assert [10, 6, 4, 1, 5, 8, 20, 12, 25, 23, 30] == preorder_traversal
postorder_traversal = bst.postorder_traversal(bst.root)
assert [1, 5, 4, 8, 6, 12, 23, 30, 25, 20, 10] == postorder_traversal
inorder_traversal = bst.inorder_traversal(bst.root)
assert [1, 4, 5, 6, 8, 10, 12, 20, 23, 25, 30] == inorder_traversal
