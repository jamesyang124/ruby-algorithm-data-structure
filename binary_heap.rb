# heap usually implemented by array
# the heap: any parent node is larger [max-heaps] equal or smaller equal [min-heap] than its leaf.
# insert new node from left to right
# heap is a binary tree, so can be traverse by inorder, preorder, postorder.
# binary tree => parent = i, then left child = 2i + 1, right child = 2i + 2, i from zero
# min heap usually use to implelemt priority queue. 
# heap not support seach function, but provide sorting ability.

container = [5, 6, 7, 8, 10, 11, 1, 2, 4, 3]

module HeapFunctions 
  attr_accessor :container 
  attr_reader :degree

  def initialize(*values, op)
    self.container = []
    values.flatten!.each do |v| 
      #container.insert(0, v)
      container << v
    end if values.class == Array
    @degree = Math.log2(values.size).to_i + 1
    bt_heapify op
  end

  def top_down_heapify(list, i, op)
    small_index = i
    small_index = 2*i + 1 if (2*i + 1) < list.size and list[2*i + 1].send(op, list[small_index])
    small_index = 2*i + 2 if (2*i + 2) < list.size and list[2*i + 2].send(op, list[small_index])
    if small_index != i
      list[i], list[small_index] = list[small_index], list[i]
      top_down_heapify(list, small_index, op)
    end
  end

  def bottom_up_heapify op
    # i = floor(n / 2) to 1, 2*i + 1, 2*i + 2 
    (container.size / 2).downto(1) do |i|
      top_down_heapify(container, i - 1, op)
    end 
  end

  def get_max op
    container.shift
    bt_heapify op
    puts "container #{container}"
  end

  def inorder_traversal i
    inorder_traversal 2*i + 1 if 2*i + 1 < container.size
    p container[i]
    inorder_traversal 2*i + 2 if 2*i + 2 < container.size
  end

  def insert(value, op)
    container << value
    top_down_heapify container, 0, op
    degree = Math.log2(container.size).to_i + 1
  end

  def deletion(op)
    container[0], container[-1] = container.last, container.first
    min = container.pop
    top_down_heapify container, 0, op
  end

  # MinHeap instance's get_max method will call bottom_up_heapify, but is MinHeap's version with no args.
  # We need to alias this method after defined block, then get_max will not use instance method from MinHeap. 
  # So HeapFunctions' bottom_up_heapify can be called instead.
  alias_method :bt_heapify, :bottom_up_heapify
end

class MinHeap 
  include HeapFunctions


  def initialize(*values)
    super(*values, "<")
  end
  
  def insert(value)
    # look class ancetsors. including module.
    super(value, "<")
  end

  # pop the min
  def deletion
    super "<"
  end

  def bottom_up_heapify
    super "<"
  end

  def get_max 
    super "<"
  end
end 

min_h = MinHeap.new container
min_h.insert 100
min_h.insert 0
min_h.deletion
#min_h.inorder_traversal 0
min_h.get_max

class MaxHeap
  include HeapFunctions

  def initialize(*values)
    super(*values, ">")
  end
  
  def insert(value)
    super(value, ">")
  end

  def deletion
    super(">")
  end

  def bottom_up_heapify
    super "<"
  end
end

#max_h = MaxHeap.new container
#max_h.insert 100
#max_h.insert 0
#max_h.deletion

class BinomialHeap 

end