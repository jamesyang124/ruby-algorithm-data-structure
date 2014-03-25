# Binomial tree properties:
# 1. N nodes binomial heap at most lg(n) + 1 binomial tree
# 2. each key is the larger or greater than its parent => each root has smallest key in that tree
#     => min-heap-ordered
# 3. For any non-negative integer K, there has at most 1 binomial tree's root degree is K.
# 4. Each tree's node count must be 2^i, i >= 0, i is that tree's degree

# Implementation now support negative key.
class BinomialNode 
  # :next as sibling tree, :key as value
  attr_accessor :degree, :sibling, :child, :parent, :key

  def initialize key
    self.degree = 0
    self.key = key
    #self.child = nil && self.sibling = nil && self.parent = nil
  end

  def < (node)
    self.key < node.key
  end
end

class BinomialHeap 
  attr_reader :min, :head

  # self.head === @head for instance object.
  # "self.head=" expression call object's "head=" method so must declare :head to attr_writer
  # if we have "self.head = something" expression.
  # If local var has same name as instance var, 
  #   then must explictily call that instance var rather than by reader method in that scope.
  # ex: attr_accessor :x 
  #  def get_x                               
  #   @x = 50                                
  #   x = 60                                 
  #   p x == @x  # => f, x is local var.     
  #  end
  # 
  # def get_x                                     
  #  @x = 50
  #  p x == @x  # => t, x is call by reader method in default. 
  #  # above x call self object to find reader method, or it will treat it as a undefined local variable. 
  # end  

  def initialize key
    if key.class != BinomialNode
      @head = BinomialNode.new key 
    else
      @head = key
    end
  end

  # create new heap for insert key, then consolidate/merge to original heap
  def insert key
    head = union(self, BinomialHeap.new(key))
    h_next = head.sibling
    consolidate(head, h_next)
  end

  def min
    peek_min
  end

  # N nodes binomial heap at most lg(n) + 1 binomial tree
  # 13 = 1101(binary representation) => 3 trees.
  # at most lg n + 1 => O(lg(n)) to get or extract min
  def peek_min
    if next_head = self.head.sibling
      current_head = self.head
      while next_head 
        next_head < current_head ? @min = next_head : @min = current_head
        current_head = next_head
        next_head = next_head.sibling  
      end
    else
      @min = self.head
    end
    @min
  end

  # decrease a key than delete a node.
  def delete_key key
    # decrease that key to new minimum, and extract it out.
    decrease_key key, min.key - 1
    extract_min
    print_heap
  end

  # delete min node in root of binomial tree.
  def extract_min
    extract_key = peek_min.key
    min_head = new_heap_from_children
    remove_min_from_heap

    # Union
    @head = union(self, BinomialHeap.new(min_head))
    h_next = head.sibling
    consolidate(head, h_next)
    # get new @min

    extract_key
  end

  def decrease_key(key, new_key = nil)
    if node = search_key(key)
      if new_key && node.key < new_key 
        puts "the new key is greater than the old one, cause error."
      else
        new_key ? node.key = new_key : node.key = get_new_smaller_key(key)
        swap_parent = find_and_swap_parent node
        if swap_parent
          puts "new key is #{swap_parent.key}, swap with #{node.key}"
        else
          puts "new key is #{node.key}, no swap happened."
        end
      end
      node
    else
      puts "Cannot find that key in heap."
    end
  end

  def print_heap
    node = self.head
    while node
      puts "head: #{node.key}, degree: #{node.degree}"
      node_child = node.child
      while node_child
        puts "\t Child: #{print_helper node_child}"
        node_child_sib = node_child.sibling
        while node_child_sib
          puts <<-HERE 
            \t Sibling: #{print_helper node_child_sib}
          HERE
          node_child_sib = node_child_sib.sibling
        end
        node_child = node_child.child
      end
      node = node.sibling
      puts "---------\n\n"
    end
  end

private

  def print_helper node
    "#{node.key}, degree: #{node.degree}, parent: #{node.parent.key}, child: #{node.child ? node.child.key : "none" }"
  end

  def remove_min_from_heap
    # remove @min from current heap
    root = self.head 
    if root == @min
      @head = @min.sibling
    else
      # memoized each first node is three consecutive nodes from root list.
      prev = nil 
      while root
        if root == @min
          prev.sibling = @min.sibling if prev
          break
        end
        prev = root
        root = root.sibling
      end
    end
  end

  def new_heap_from_children
    # create a new heap's root list from the min tree.
    child = @min.child
    root_list = []
    while child
      root_list << child
      child = child.sibling
    end
    min_child_head = root_list.reverse!.shift
    current = min_child_head
    
    # Also reverse the order of min-tree's children to match the strictly increased order.
    until root_list.empty?
      current.sibling = root_list.first
      current = root_list.shift 
    end
    # last children's sibling reset to nil
    current.sibling = nil if current
    min_child_head
  end

  def get_new_smaller_key key
    if key == 0
      gen_key = -(Random.new.rand(key + 2).to_i)
    else
      gen_key = Random.new.rand(key).to_i
      # generate unique key which not exist in heap.
      while (search_key gen_key) != nil
        gen_key = Random.new.rand(key).to_i 
      end
    end
    gen_key
  end

  def find_and_swap_parent node
    current = node
    p = node.parent
    while p && current.key < p.key      
      p.key, current.key = current.key, p.key
      current = p
      p = p.parent
    end
    current
  end

  def search_key key
    node = self.head
    
    while node
      return node if node.key == key
      node_child = node.child    
      while node_child
        return node_child if node_child.key == key
        node_child_sib = node_child.sibling
        while node_child_sib 
          return node_child_sib if node_child_sib.key == key
          node_child_sib = node_child_sib.sibling
        end
        node_child = node_child.child
      end
      node = node.sibling
    end
  end

  # return new head for 2 union heaps
  def union heap_x, heap_y
    return heap_y.head if !heap_x.head
    return heap_x.head if !heap_y.head

    hx_next, hy_next = heap_x.head, heap_y.head

    # initialization for head and tail of new root list
    if hx_next.degree <= hy_next.degree
      @head = hx_next
      hx_next = hx_next.sibling
    else
      @head = hy_next
      hy_next = hy_next.sibling
    end
    tail = self.head

    # recreate new root list for two heaps
    while hx_next && hy_next
      if hx_next.degree <= hy_next.degree
        tail.sibling = hx_next
        hx_next = hx_next.sibling
      else
        tail.sibling = hy_next
        hy_next = hy_next.sibling
      end
      tail = tail.sibling
    end

    if hx_next
      tail.sibling = hx_next
    else
      tail.sibling = hy_next
    end

    return self.head
  end

  def consolidate current_head, next_head
    previous_head = nil
    while next_head 
      # Root list has strictly increse order by degree.
      # In case current_head.degree = next_head.degree = next_head.sibling.degree, 
      # we merge next_head and next_head.sibling in later, and left current_head unchanged. 
      if current_head.degree != next_head.degree \
        || (next_head.sibling && next_head.sibling.degree == current_head.degree) 
        previous_head = current_head
        current_head = next_head
      else
        # compare two head's key value, min will be new root.
        if current_head.key > next_head.key
          # if previous head already exist, then the head of root list will not change any more.
          previous_head ? (previous_head.sibling = next_head) : (@head = next_head)
          merge_link(current_head, next_head)
          current_head = next_head
        else
          current_head.sibling = next_head.sibling
          merge_link(next_head, current_head)
        end
      end
      next_head = current_head.sibling
    end
  end

  def merge_link node_x, node_y
    node_x.parent = node_y
    node_x.sibling = node_y.child
    node_y.child = node_x
    node_y.degree += 1
  end
end