# Level Order traversal of BST
# with iterative and recursive methods
module LevelOrder
  def level_order_queue(current, queue)
    # helper method for queuing items
    queue << current.left unless current.left.nil?
    queue << current.right unless current.right.nil?
  end

  def level_order(current = @root, queue = [], arr = [], &block)
    return if current.nil?

    level_order_queue(current, queue)

    if block_given?
      yield current.data
    else
      arr << current.data
      return arr if queue.empty?
    end

    level_order(queue.shift, queue, arr, &block)
  end

  def level_order_i(current = @root, queue = [], arr = [])
    while current
      level_order_queue(current, queue)

      if block_given?
        yield current.data
      else
        arr << current.data
        return arr if queue.empty?
      end

      current = queue.shift
    end
  end
end
