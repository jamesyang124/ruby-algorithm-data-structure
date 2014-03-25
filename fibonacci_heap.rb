require 'set'

class FibonacciNode 
  # :next as sibling tree, :key as value
  attr_accessor :degree, :child, :parent, :key, :mark, :left, :right

  def initialize(key = nil)
    self.degree = 0
    self.key = key
    self.mark = false
  end

  def < (node)
    self.key < node.key
  end
end

class FibonacciHeap
  attr_accessor :root_head, :min, :size, :root_tail

  def initialize(key = nil)
    @root_head = FibonacciNode.new key
    @root_tail = root_head
    @min = @root_head
    @size = 1
  end

  def get_min
    node = @min = root_head
    while node 
      @min = node if node.key < min.key
      node = node.right
    end
    @min
  end

  # Unlike binomial heap, fib heap does not try to consolidate the heap for insertion.
  def insert! key
    if self.min == nil
      @root_head = FibonacciNode.new key
      @min = @root_head
      @root_tail = @root_head
    else
      new_node = FibonacciNode.new key
      @root_tail.right = new_node
      new_node.left = @root_tail
      @root_tail = new_node
      self.min = new_node if min.key > new_node.key
    end
    self.size += 1 
  end

  # Only when we need to union two heaps, but still build an unordered binomial trees, not consolidate yet.
  def union heap_x, heap_y
    return heap_y if !heap_x.root_head
    return heap_x if !heap_y.root_head

    y_head = heap_y.root_head
    heap_x.root_tail.right = y_head
    y_head.left = heap_x.root_tail
    heap_x.root_tail = heap_y.root_tail
    heap_x.min = heap_y.min if heap_x.min.key > heap_y.min.key
    heap_x.size = heap_x.size + heap_y.size 
    return heap_x 
  end

  def extract_min
    prev = min.left
    post = min.right 
    
    # concat children to root list
    min_child_head = min_child_tail = min.child
    if min_child_tail
      while min_child_tail.right && min_child_tail.right.parent == min
        min_child_tail = min_child_tail.right 
      end
    end

    # link prev to min's first child
    # if prev = nil, then root_head == min so set root_head to next root.
    if prev
      prev.right = min_child_head ? min_child_head : post   
      min_child_head.left = prev if min_child_head
    else
      @root_head = min_child_head ? min_child_head : root_head.right
    end

    # link post to min's rightmost child
    if post
      post.left = min_child_tail ? min_child_tail : prev
      min_child_tail.right = post if min_child_tail
    end
    #require 'pry'; binding.pry

    consolidate
    @min = nil
    @size -= 1
    get_min
  end

  def decrease_key
    
  end

  def delete_key
    
  end

  def print_heap
    node = self.root_head
    while node
      puts "head: #{node.key}, degree: #{node.degree}"
      node_child = node.child
      while node_child
        puts "\t Child: #{print_helper node_child}"
        node_child_sib = node_child.right
        while node_child_sib
          puts <<-HERE 
            \t Right: #{print_helper node_child_sib}
          HERE
          node_child_sib = node_child_sib.right
        end
        node_child = node_child.child
      end
      node = node.right
      puts "---------\n\n"
    end
  end

private 

  def consolidate
    set, peek = Set.new([]), root_head
    while peek
      set.add peek.degree
      peek = peek.right
    end
    degree_list = Hash.new
    set.each { |e| degree_list[e] = nil }

    node = root_head
    while node
      x = node.degree
      while degree_list.has_key?(x) && degree_list[x] && degree_list[x] != node
        degree_list[x], node = node, degree_list[x] if degree_list[x].key < node.key
        
        merge_link(self, degree_list[x], node)
        degree_list[x] = nil
        x += 1 
      end
      degree_list[x] = node
      node = node.right
    end
  end

  def merge_link(heap, sub, base)
    sub.left.right = sub.right if sub.left
    sub.right.left = sub.left if sub.right

    sub.right = base.child
    sub.left = nil
    sub.mark = false
    sub.parent = base
    
    sub_child, base_child = sub.child, base.child.child if base.child

    # link children starting from sub's first level child to base's second level child.
    while sub_child && base_child
      # need parenthesis, x ||= 5 === x = x || 5 => || return none-nil value if possible
      sub_child_next = sub_child_next.right while (sub_child_next ||= sub_child) && sub_child_next.right
      
      sub_child_next.right, base_child.left = base_child, sub_child_next
      sub_child, base_child = sub_child.child, base_child.child
    end

    base.child.left = sub if base.child
    base.child = sub
    base.degree += 1

    # define root_head
    if root_head == sub
      find_root_head = base
      find_root_head = find_root_head.left while find_root_head.left
      @root_head = find_root_head
    end
  end

  def print_helper node
    "#{node.key}, degree: #{node.degree}, parent: #{node.parent.key}, child: #{node.child ? node.child.key : "none" }"
  end
end