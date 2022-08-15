"""
Depth First Search

We search all tree/graphs nodes in a vertical fashion.

Imagine we have this tree:

             100
              |
        ------------
        |          |
       89          91
        |          |
    --------   ---------
    |      |   |       |
   12     34  77     82

We would visit each node in the following order with BFS:
    100, 89, 12, 34, 91, 77, 82

The following example demonstrates how to implement the DFS algorithm with a binary tree.
"""


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def construct_tree():
    root = TreeNode(100)
    root.left = TreeNode(89)
    root.left.left = TreeNode(12)
    root.left.right = TreeNode(34)

    root.right = TreeNode(91)
    root.right.left = TreeNode(77)
    root.right.right = TreeNode(82)
    return root


def recursive(node: list[TreeNode], visiting_order: list[int] = []) -> list[int]:
    """
    Recursively visit left first so all the left hand nodes are given priority.

    In this way, we end up visiting each tree's branch depth before continuing on
    to the next one.

    The solution has an O(n) time complexity.
    """
    if not node:
        return
    visiting_order.append(node.val)
    if node.left:
        recursive(node.left)
    if node.right:
        recursive(node.right)
    return visiting_order


def dfs(node):
    return recursive(node)


assert dfs(construct_tree()) == [100, 89, 12, 34, 91, 77, 82]
