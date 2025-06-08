require_relative "node"
require "pry-byebug"

# Class for tree
class Tree # rubocop:disable Metrics/ClassLength
  include Enumerable
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

  def delete_r(val, current = @root) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
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

  def delete_i(val, current = @root) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
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
    # byebug
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

  def level_order(current = @root, queue = [], arr = [], &block)
    return arr if current.nil?

    queue << current.left unless current.left.nil?
    queue << current.right unless current.right.nil?

    if block_given?
      yield current.data
    else
      arr << current.data
    end

    level_order(queue.shift, queue, arr, &block)
  end

  def level_order_i(current = @root, queue = [], arr = []) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    while current
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?

      if block_given?
        yield current.data
      else
        arr << current.data
        p arr if queue.empty?
      end
      current = queue.shift
    end
  end

  def inorder(current = @root, arr = [], &block)
    # traverse tree left -> root -> right
    return arr if current.nil? # base case

    inorder(current.left, arr, &block)
    block_given? ? (yield current.data) : arr << current.data
    inorder(current.right, arr, &block)
  end

  def preorder(current = @root, arr = [], &block)
    # traverse tree root -> left -> right
    return arr if current.nil? # base case

    block_given? ? (yield current.data) : arr << current.data
    preorder(current.left, arr, &block)
    preorder(current.right, arr, &block)
  end

  def postorder(current = @root, arr = [], &block)
    # traverse tree left -> right -> root
    return arr if current.nil? # base case

    postorder(current.left, arr, &block)
    postorder(current.right, arr, &block)
    block_given? ? (yield current.data) : arr << current.data
  end

  def height(val, current = @root, first_call = 1)
    current = find_r(val) if first_call
    return -1 if current.nil?

    left_height = height(val, current.left, false)
    right_height = height(val, current.right, false)
    [left_height, right_height].max + 1
  end

  def depth(val, current = @root)
    count = 0

    until current.nil? || current.data == val
      current = current.data > val ? current.left : current.right
      count += 1
    end
    count unless current.nil?
  end

  def balanced?(current = @root)
    return true if current.nil?

    left_height = height(current.data, current.left, false)
    right_height = height(current.data, current.right, false)

    return false if left_height - right_height > 1

    balanced?(current.left) && balanced?(current.right)
  end

  def rebalance
    @root = build_tree(inorder)
  end

  def pretty_print(node = @root, prefix = "", is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
