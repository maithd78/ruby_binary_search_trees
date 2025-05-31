require_relative "node"
require "pry-byebug"

# Class for tree
class Tree
  attr_accessor :root

  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end

  # array is sorted when the class is initialized
  def build_tree(array, start = array.index(array.first), last = array.index(array.last))
    return if start > last

    mid = (start + last) / 2
    node = Node.new(array[mid])

    node.left = build_tree(array, start, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    node
  end

  def insert(val, current = @root)
    return Node.new(val) if current.nil?

    return current if val == current.data

    if val < current.data
      current.left = insert(val, current.left)
    elsif val > current.data
      current.right = insert(val, current.right)
    end
    current
  end

  def insert_i(val, current = @root) # rubocop:disable Metrics/MethodLength
    while current
      parent = current
      if current.data > val
        current = current.left
      elsif current.data < val
        current = current.right
      else
        return current
      end
    end
    parent.data > val ? parent.left = Node.new(val) : parent.right = Node.new(val)
  end

  def get_successor(current)
    current = current.right
    current = current.left while !current.nil? && !current.left.nil?
    current
  end

  def delete_r(val, current = @root)
    # base case
    return current if current.nil?

    # search for key
    if current.data > val
      current.left = delete_r(val, current.left)
    elsif current.data < val
      current.right = delete_r(val, current.right)
    else
      # delete node if no children or only right child
      return current.right if current.left.nil?
      # delete node if only left child
      return current.left if current.right.nil?

      # when both children are present
      succ = get_successor(current)
      current.data = succ.data
      current.right = delete_r(succ.data, current.right)
    end
    current
  end

  def delete_i(val, current = @root)
    # create a pointer that iterates over the tree until the val is found or until there are no more sub trees.
    until current.data == val || current.nil?
      prev = current
      if current.data > val
        current = current.left
      elsif current.data < val
        current = current.right
      else
        return current
      end
    end
    # check if the node is a leaf or has a left or right branch
    if current.left.nil? || current.right.nil?
      new_curr = current.left.nil? ? current.right : current.left
      if current == prev.left
        prev.left = new_curr
      else
        prev.right = new_curr
      end
    else
      current
    end
  end

  def find_r(val, current = @root.dup)
    # base case returns if no more childern or if data is found
    return current if current.nil? || current.data == val

    # # val is less than curr data, go Left
    # if current.data > val
    #   find_r(val, current.left)
    # # val is more than curr data, go right
    # elsif current.data < val
    #   find_r(val, current.right)
    # end
    current.data > val ? find_r(val, current.left) : find_r(val, current.right)
  end

  def find_i(val, current = @root.dup)
    # until current.nil? || current.data == val
    #   if current.data > val
    #     current = current.left
    #   elsif current.data < val
    #     current = current.right
    #   end
    # end
    current = current.data > val ? current.left : current.right until current.nil? || current.data == val
    current
  end

  def pretty_print(node = @root, prefix = "", is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
