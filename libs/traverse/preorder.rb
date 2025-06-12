# Preorder order traversal of BST
module Preorder
  def preorder(current = @root, arr = [], &block)
    # traverse tree root -> left -> right
    return arr if current.nil? # base case

    block_given? ? (yield current.data) : arr << current.data
    preorder(current.left, arr, &block)
    preorder(current.right, arr, &block)
  end
end
