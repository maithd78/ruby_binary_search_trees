# Postorder traversal of BST
module Postorder
  def postorder(current = @root, arr = [], &block)
    # traverse tree left -> right -> root
    return arr if current.nil? # base case

    postorder(current.left, arr, &block)
    postorder(current.right, arr, &block)
    block_given? ? (yield current.data) : arr << current.data
  end
end
