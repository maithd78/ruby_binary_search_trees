require_relative "libs/node"
require_relative "libs/tree"

# bst = Tree.new(Array.new(15) { rand(1..100) })
bst = Tree.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
bst.pretty_print

bst.delete_r(5)
bst.pretty_print
# bst.level_order
# p bst.balanced?
# p bst.level_order
# p bst.preorder
# p bst.postorder
# p bst.inorder

# 100.times do
#   bst.insert(rand(1..100))
# end

# p bst.balanced?
# bst.rebalance
# p bst.balanced?

# p bst.level_order
# p bst.preorder
# p bst.postorder
# p bst.inorder
