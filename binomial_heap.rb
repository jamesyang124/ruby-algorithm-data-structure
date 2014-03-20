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

class BinomialNode 
  # :next as sibling tree, :key as value
  attr_accessor :degree, :sibling, :child, :parent, :key

  def initialize key
    self.degree = 0
    self.key = key
    self.child = nil && self.sibling = nil && self.parent = nil
  end
end

class BinomialHeap 
  attr_accessor :size, :min, :head
  def initialize key
    @head = BinomialNode.new key
  end

  # create new heap for insert key, then merge to original heap
  def insert key
    head = merge_root_list(self, BinomialHeap.new(key))
    h_next = head.sibling
    merge(head, h_next)
    #print_siblings
  end

  def delete
    
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
    tail = @head

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

    return @head
  end

  def merge current_head, next_head
    previous_head = nil
    while next_head 
      # Root list has strictly increse order by degree.
      if current_head.degree != next_head.degree \
        || (next_head.sibling && next_head.sibling.degree == current_head.degree) 
        previous_head = current_head
        current_head = next_head
      else
        # compare two head's key value, min will be new head.
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