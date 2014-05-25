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

  alias :r :right
  alias :l :left
  alias :l= :left=
  alias :r= :right=
end

# http://staff.ustc.edu.cn/~csli/graduate/algorithms/book6/chap21.htm
# We shall assume that a unit of potential can pay for a constant amount of work,
# where the constant is sufficiently large to cover the cost of any of the specific constant-time pieces of work that we might encounter.

# Potential function to analysis performance of Fibonacci heap operations. [amortized analysis]
# P(H) = t(H) + 2*m(H), H is heap, t is tree counts, m is makred node
# The potential is nonnegative at all subsequent times.

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
      node = node.r
    end
    @min
  end

  # Unlike binomial heap, fib heap does not try to consolidate the heap for insertion.
  # For heap h, current tree count t, and marked node,
  # the increase in potential for insertion operation:
  # ((t + 1) + 2*m) - (t + 2*m) = 1
  # Since the actual cost is O(1), the amortized cost is O(1) + 1 = O(1)
  def insert!(key)
    if self.min == nil
      @root_head = FibonacciNode.new key
      @min = @root_head
      @root_tail = @root_head
    else
      new_node = FibonacciNode.new key
      @root_tail = get_root_tail
      @root_tail.r = new_node
      new_node.l = @root_tail
      @root_tail = new_node
      self.min = new_node if min.key > new_node.key
    end
    @size += 1 
  end

  # The change in potential is
  # (H) - ((H1) + (H2)) = (t(H) + 2m(H)) - ((t(H1) + 2 m(H1)) + (t(H2) + 2m(H2))) = 0
  # Because t(H) = t(H1) + t(H2) and m(H) = m(H1) + m(H2).
  # => The amortized cost is the same as insertion => O(1)
  # Only when we need to union two heaps, but still build an unordered binomial trees, not consolidate yet.
  def union(heap_x, heap_y)
    return heap_y if !heap_x.root_head
    return heap_x if !heap_y.root_head

    y_head = heap_y.root_head
    heap_x.root_tail.r = y_head
    y_head.l = heap_x.root_tail
    heap_x.root_tail = heap_y.root_tail
    heap_x.min = heap_y.min if heap_x.min.key > heap_y.min.key
    heap_x.size = heap_x.size + heap_y.size 
    return heap_x 
  end

  # D(n) is at most D(n) children in minimum root node.
  # O(D(n) + t(H)) + ((D(n) + 1) + 2m(H)) - (t(H) + 2m(H))
  # = O(D(n)) + O(t(H)) - t(H)
  # = O(D(n)) ~= O(log n)
  def extract_min
    prev = min.l
    post = min.r 
    
    # concat children to root list
    # min_child_head = min_child_tail = min.child
    mch = mct = min.child
    if mch
      mch.parent = nil
      # link prev to min's first child
      # if prev = nil, then root_head == min so set root_head to next root. 
      if prev
        prev.right = mch 
        mch.left = prev
      else
        @root_head = mch
      end
    else
      # if prev = nil, then root_head == min so set root_head to next root.
      prev ? prev.right = post : @root_head = root_head.right
    end  

    # link post to min's rightmost child.
    # if post does not exist, child list have been linked to root list so do nothing.
    if mct
      mct = mct.r while mct.r && mct.r.parent == min
      mct.parent = nil
      if post
        post.left = mct
        mct.right = post
      end
    else
      post.left = prev if post
    end

    consolidate
    @min = nil
    @size -= 1
    get_min
  end

  # c => cut trees count.
  # ((t(H) + c) + 2(m(H) - c + 2)) - (t(H) + 2m(H)) = 4 - c
  # O(c) + 4 - c ~= O(1)
  def decrease_key(key, new_key = nil)
    if node = search_key(key)
      if new_key && node.key < new_key 
        puts "the new key is greater than the old one, cause error."
      else
        new_key ? node.key = new_key : node.key = get_new_smaller_key(key)
        parent = node.parent
        if parent && node.key < parent.key
          cut(self, node, parent)
          cascading_cut(parent)
        end
        @min = node if node.key < min.key
      end
      node
    else
      puts "Cannot find that key in heap."
    end
  end

  # O(D(n)) ~= O(log(n))
  def delete_key(key)
    decrease_key(key, get_smallest_key)
    extract_min
  end

  def print_heap
    mark = []
    node = self.root_head
    puts "############### START"
    while node
      puts "head: #{node.key}, degree: #{node.degree}"
      mark << node.key if node.mark
      node_child = node.child
      while node_child
        puts "\t Child: #{print_helper node_child}"
        mark << node_child.key if node_child.mark
        node_child_sib = node_child.right
        while node_child_sib
          puts <<-HERE 
            \t Right: #{print_helper node_child_sib}
          HERE
          mark << node_child_sib.key if node_child_sib.mark
          node_child_sib = node_child_sib.right
        end
        node_child = node_child.child
      end
      node = node.right
    end
    puts "marked: #{mark.inspect}"
    puts "############### END"
  end

private 

  def get_root_tail
    @root_tail = root_head
    while root_tail.right
      @root_tail = root_tail.right
    end
    root_tail
  end

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



  def cascading_cut(parent)
    ancestor = parent.parent
    if ancestor
      if parent.mark == false
        parent.mark = true
      else
        cut(self, parent, ancestor)
        cascading_cut(ancestor)
      end
    end
  end

  # Assumptions for cut: 
  # 1. at some time, x was a root,
  # 2. then x was linked to another node(a child),
  # 3. then two children of x were removed by cuts.
  # The field mark[x] is TRUE if steps 1 and 2 have occurred and one child of x has been cut.
  # Because x might be the second child cut from its parent y since the time that y was linked to its children.
  # So #cascading_cut(parent) will perform recursively in #decrease_key.
  def cut(heap, node, parent)
    if node.left
      node.left.right = node.right ? node.right : nil
    end

    if node.right
      node.right.left = node.left ? node.left : nil
    end
    
    # if parent marked, set parent's child to nil, otherwise set it to left or right children in precednce if exist.
    if !parent.mark && parent.child == node
      new_child = node.left || node.right
      parent.child = new_child && new_child.parent == parent ? new_child : nil
    end
    parent.child = nil if parent.mark

    parent.degree -= 1
    node.parent, node.mark = nil, false

    root_parent = parent
    root_parent = root_parent.parent while root_parent.parent
    node.left, node.right = root_parent.left, root_parent
    root_parent.left.right = node if root_parent.left
    root_parent.left = node
    @root_head = node if @root_head == root_parent
  end 

  def search_key(key)
    node = self.root_head
    while node
      return node if node.key == key
      node_child = node.child    
      while node_child 
        return node_child if node_child.key == key
        node_child_sib = node_child.right
        while node_child_sib 
          return node_child_sib if node_child_sib.key == key
          node_child_sib = node_child_sib.right
        end
        node_child = node_child.child
      end
      node = node.right
    end
  end

  def get_new_smaller_key(key)
    gen_key = -Random.new.rand(key + 2).to_i
    # generate unique key which not exist in heap.
    while (search_key gen_key) != nil
      gen_key = -Random.new.rand(key + 2).to_i 
    end
    gen_key
  end

  def get_smallest_key
    gen_key = -Random.new.rand(min.key + 2).to_i
    # generate unique key which not exist in heap.
    while (search_key gen_key) != nil && gen_key < min
      gen_key = -Random.new.rand(min.key + 2).to_i 
    end
    gen_key
  end

  def print_helper(node)
    "#{node.key}, degree: #{node.degree}, parent: #{node.parent ? node.parent.key : "none" }, child: #{node.child ? node.child.key : "none" }"
  end
end