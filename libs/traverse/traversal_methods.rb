require_relative "inorder"
require_relative "level_order"
require_relative "postorder"
require_relative "preorder"

# Wrapper method for traversing BST
# call traverse and give method for args as symbol
module TraversalMethods
  include Inorder
  include LevelOrder
  include Postorder
  include Preorder
end
