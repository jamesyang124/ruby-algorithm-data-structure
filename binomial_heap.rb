# Copyright (c) 2014 James Yang

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# Binomial tree properties:
# 1. N nodes binomial heap at most lg(n) + 1 binomial tree
# 2. each key is the larger or greater than its parent => each root has smallest key in that tree
#     => min-heap-ordered
# 3. For any non-negative integer K, there has at most 1 binomial tree's root degree is K.
# 4. Each tree's node count must be 2^i, i >= 0, i is that tree's degree

class BinomialNode 
  # :next as sibling tree, :key as value
  attr_accessor :degree, :sibling, :child, :parent, :key

  def initialize key
    self.degree = 0
    self.key = key
    self.child = nil && self.sibling = nil && self.parent = nil
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
  def initialize key
    if key.class != BinomialNode
      @head = BinomialNode.new key 
    else
      @head = key
    end
  end

  # create new heap for insert key, then merge to original heap
  def insert key
    head = merge_root_list(self, BinomialHeap.new(key))
    h_next = head.sibling
    merge(head, h_next)
  end

  def min
    get_min
  end

  # N nodes binomial heap at most lg(n) + 1 binomial tree
  # 13 = 1101(binary representation) => 3 trees.
  # at most lg n + 1 => O(lg(n))
  def get_min
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
  def delete_key
    
  end

  # delete min node in root of binomial tree.
  def extract_min
    extract_key = get_min.key

    # create a new heap's root list from the min tree.
    # Also reverse the order of min-tree's children to match the strictly increased order.
    child = @min.child
    root_list = []
    while child
      root_list << child
      child = child.sibling
    end
    min_head = root_list.reverse!.shift
    current = min_head
    
    until root_list.empty?
      current.sibling = root_list.first
      current = root_list.shift 
    end
    current.sibling = nil

    # remove @min from current heap
    root = self.head 
    if root == @min
      self.head = @min.sibling
    else
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

    # Union
    head = merge_root_list(self, BinomialHeap.new(min_head))
    h_next = head.sibling
    merge(head, h_next)
    # get new @min

    extract_key
  end

  def print_siblings
    node = self.head
    while node
      puts "head: #{node.key}, degree: #{node.degree}"
      node_child = node.child
      while node_child
        puts "\t Child: #{node_child.key}, degree: #{node_child.degree}"
        node_child_sib = node_child.sibling
        while node_child_sib
          puts "\t\t Sibling: #{node_child_sib.key}, degree: #{node_child_sib.degree}, parent: #{node_child_sib.parent.key}"
          node_child_sib = node_child_sib.sibling
        end
        node_child = node_child.child
      end
      node = node.sibling
      puts "---------\n\n"
    end
  end

private

  # return new head for 2 merge heaps
  def merge_root_list heap_x, heap_y
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

  def merge current_head, next_head
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
          merge_trees(current_head, next_head)
          current_head = next_head
        else
          current_head.sibling = next_head.sibling
          merge_trees(next_head, current_head)
        end
      end
      next_head = current_head.sibling
    end
  end

  def merge_trees node_x, node_y
    node_x.parent = node_y
    node_x.sibling = node_y.child
    node_y.child = node_x
    node_y.degree += 1
  end
end

#@size = 13.to_s(2).split(//).map do |s|
#      s.to_i
#end.reverse!