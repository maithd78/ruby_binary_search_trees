# Inorder traversal of BST
module Inorder
  def inorder(current = @root, arr = [], &block)
    # traverse tree left -> root -> right
    return arr if current.nil? # base case

    inorder(current.left, arr, &block)
    block_given? ? (yield current.data) : arr << current.data
    inorder(current.right, arr, &block)
  end
end
