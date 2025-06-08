require_relative "libs/node"
require_relative "libs/tree"

bst = Tree.new(Array.new(15) { rand(1..100) })
bst.pretty_print

p bst.balanced?
p bst.level_order
p bst.preorder
p bst.postorder
p bst.inorder

100.times do
  bst.insert(rand(1..100))
end

p bst.balanced?
bst.rebalance
p bst.balanced?

p bst.level_order
p bst.preorder
p bst.postorder
p bst.inorder
