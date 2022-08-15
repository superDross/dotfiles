"""
Breadth First Search

We search all tree/graphs nodes in a horizontal fashion.

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
    100, 89, 91, 12, 34, 77, 82

The following example demonstrates how to implement the BFS algorithm with a binary tree.
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


def recursive(nodes: list[TreeNode], visiting_order: list[int] = []) -> list[int]:
    """
    Iterate through each node, visit the node, parse its children and repeat
    the process with the child nodes.

    Returns the values of the nodes in the visited order.

    This solution has a O(n) time complexity.
    """
    next_level = []
    for node in nodes:
        visiting_order.append(node.val)
        for child_node in [node.left, node.right]:
            if child_node:
                next_level.append(child_node)
    if next_level:
        return recursive(next_level)

    return visiting_order


def bfs(node):
    return recursive([node])


assert bfs(construct_tree()) == [100, 89, 91, 12, 34, 77, 82]
