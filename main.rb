require_relative "libs/node"
require_relative "libs/tree"

array = [1, 2, 3, 4, 5, 6, 7]
test = Tree.new(array)

# test.insert(10)
test.pretty_print
p test.find_r(7)

test.pretty_print

# tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# tree.pretty_print
