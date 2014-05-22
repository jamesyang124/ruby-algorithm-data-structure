# 2-3 tree => b tree of order 3
# Reference: http://www.cs.princeton.edu/~dpw/courses/cos326-12/ass/2-3-trees.pdf
class BtreeNode
  # key_l => key left, key_r => key right
  # nary[0] => left, nary[1] => mid, nary[2] => right
  # n => size
  # p => parent
  attr_accessor :key_l, :key_r, :nary, :size, :p
  
  def initialize(key)
    @key_l = key
    @size = 1
    @nary = []
  end
end

class Btree 
  attr_accessor :root

  def initialize(key)
    @root = BtreeNode.new key
  end

  def insert(key)
    result = find_leaf key
    if result.key_l == key or result.key_r == key
      puts "Not allowed to insert duplicate key value."
    else
      split(result, key)
    end
  end

  def search(key)
    result = find_leaf key
    if result.key_l == key or result.key_r == key
      puts "Node #{key}, left:s #{result.key_l}, right: #{result.key_r}"
    else
      puts "Find nothing."
    end
  end

  def delete(key)
    # rotate
    # substitution nearest value to that position
    result = find_leaf key
    if result.key_l == key || result.key_r == key
      if result.nary.empty? # result is leaf
        if result.size == 2
          result.key_l = result.key_r if result.key_l == key
          result.key_r = nil
          result.size -= 1 
        else
          result.key_l = nil
          result.size = 0
          handle_hole result if result != root
        end
      else  # result is internel node
        pred = internal_inorder_pred result, key
        if pred.size == 2
          result.key_l == key ? result.key_l = pred.key_r : result.key_r = pred.key_r
          pred.key_r = nil
          pred.size = 1
        else
          result.key_l == key ? result.key_l = pred.key_l : result.key_r = pred.key_l
          pred.key_l = nil
          pred.size = 0
          hole = pred
          handle_hole hole
        end
      end
    else
      puts "Cannot find the deletion for key #{key}."
    end
  end

  def print_list
    current = root
    ary = []
    ary << current
    while current
      printf "Current: %-7s, node_left: %-2s, node_middle: %-2s, node_right: %-2s, parent: %5s, nsize: #{current.nary.size}\n", "#{current.key_l} / #{current.key_r}", "#{current.nary[0].key_l if current.nary[0]}", "#{current.nary[1].key_l if current.nary[1]}","#{current.nary[2].key_l if current.nary[2]}", "#{current.p.key_l if current.p} / #{current.p.key_r if current.p}"
      ary << current.nary[0] if current.nary[0]
      ary << current.nary[1] if current.nary[1]
      ary << current.nary[2] if current.nary[2]
      ary.shift
      current = ary.first     
    end 
  end

private

  # find either prde. or succe., both are fine to replace with.
  def internal_inorder_pred(node, key)
    # internal node
    leaf = (key == node.key_l) ? node.nary[0] : node.nary[1]
    while leaf
      pred = leaf
      leaf = leaf.nary[2] ? leaf.nary[2] : leaf.nary[1]
    end
    pred
  end

  # hole is a special node has only one link because its a combination from sub-leaf node to current node.
  def handle_hole(hole)
    if hole.p && hole.p.size == 1
      loc, sib = sib_of_2nodes_parent hole.p, hole
      
      if sib.size == 1
        if loc == 1
          # if loc == 1, hole has 2-node parent, 2-node right sibling
          sib.key_l, sib.key_r = hole.p.key_l, sib.key_l
          sib.nary.unshift(hole.nary.shift) unless hole.nary.empty?
        else
          # if loc == 0, hole has 2-node parent, 2-node left sibling
          sib.key_r = hole.p.key_l
          sib.nary << hole.nary.shift unless hole.nary.empty?
        end

        sib.nary.each { |e| e.p = sib }
        hole.p.key_l = nil
        hole.p.nary.clear << sib
        sib.size = 2
        hole.p.size = 0
        handle_hole(hole.p)
      else
        if loc == 1
          # hole has 2-node parent, 3-node right sibling, rotation
          hole.key_l, sib.p.key_l, sib.key_l , sib.key_r = sib.p.key_l, sib.key_l, sib.key_r, nil
          hole.nary << sib.nary.shift unless sib.nary.empty? 
        else
          # hole has 2-node parent, 3-node left sibling, rotation
          hole.key_l, sib.p.key_l, sib.key_r = sib.p.key_l, sib.key_r , sib.key_r, nil
          hole.nary << sib.nary.pop unless sib.nary.empty? 
        end

        hole.nary.each { |e| e.p = hole }
        hole.size = 1
        sib.size = 1
      end
    elsif hole.p && hole.p.size == 2
      loc, sib = sib_of_3nodes_parent hole.p, hole

      if sib.size == 1
        if loc == 0
          # hole has 3-node parent, 2-node left sibling, rotation 
          sib.key_r, hole.p.key_r = hole.p.key_r, nil
          sib.nary.concat hole.nary
          hole.p.nary.pop
        elsif loc == 1
          # hole has 3-node parent, 2-node right sibling, rotation
          sib.key_l, sib.key_r, hole.p.key_l, hole.p.key_r = hole.p.key_l, sib.key_l, hole.p.key_r, nil
          sib.nary.unshift(hole.nary.shift) unless hole.nary.empty?
          hole.p.nary.shift
        else
          # hole in middle and has 3-node parent, 2-node sibling.
          sib.key_r, hole.p.key_l, hole.p.key_r = hole.p.key_l, hole.p.key_r, nil
          sib.nary.concat hole.nary
          hole.p.nary.delete_if { |e| e == hole } 
        end

        sib.nary.each { |e| e.p = sib }
        hole.p.size = 1
        sib.size = 2
      else
        if loc == 0
          # hole has 3-node parent, 3-node left sibling, rotation
          hole.key_l, hole.p.key_r, sib.key_r = hole.p.key_r, sib.key_r, nil
          hole.nary.unshift(sib.nary.pop) unless sib.nary.empty?
        elsif loc == 1
          # hole has 3-node parent, 3-node right sibling, rotation  
          hole.key_l, hole.p.key_l, sib.key_l, sib.key_r = hole.p.key_l, sib.key_l, sib.key_r, nil
          hole.nary << sib.nary.shift unless sib.nary.empty?
        else
          # hole in middle and has 3-node parent, 3-node sibling.
          hole.key_l, hole.p.key_l, sib.key_r = hole.p.key_l, sib.key_r, nil
          hole.nary.unshift(sib.nary.pop) unless sib.nary.empty?
        end
        
        hole.nary.each { |e| e.p = hole }
        hole.size = 1
        sib.size = 1  
      end
    else
      # hole in hole.parent. hole in root.
      @root = hole.nary[0]
      hole.nary[0].p = nil
    end
  end

  # node's sibling of 3-node parent 
  def sib_of_3nodes_parent(parent, node)
    if parent.nary[0] == node 
      return 1, parent.nary[1] 
    elsif parent.nary[2] == node
      return 0, parent.nary[1] 
    else
      # In here we prefer take left side sib, take right side sib also fine.
      return 2, parent.nary[0]
    end
  end

  # node's sibling of 2-node parent 
  def sib_of_2nodes_parent(parent, node)
    if parent.nary[0] == node
      # sib in right
      return 1, parent.nary[1]
    else
      # sib in left
      return 0, parent.nary[0]
    end
  end

  # aux is a children list to rearrange new children for parent's children links.
  def split(node, key, aux = nil)
    sort_ary = sort_key(node, key)
    if node == root
      if node.size < 2
        node.key_l, node.key_r = sort_ary[0], sort_ary[1]
        node.size += 1
      else
        node.p = BtreeNode.new sort_ary[1]
        new_node = BtreeNode.new sort_ary[2]
        new_node.p = node.p

        assign_children_links(node, aux, new_node) if aux
        renew_node(node, sort_ary[0])

        @root = node.p
        @root.nary[0] = node
        @root.nary[1] = new_node
      end
    else
      if node.size < 2
        node.key_l, node.key_r = sort_ary[0], sort_ary[1]
        assign_children_links(node, aux) unless node.nary.empty?
        node.size += 1
      else
        new_node = BtreeNode.new sort_ary[2]
        new_node.p = node.p
        renew_node(node, sort_ary[0])

        assign_children_links(node, aux, new_node) unless node.nary.empty?
        aux = get_parent_aux(node, node.p, new_node)
        split(node.p, sort_ary[1], aux) if node.p != nil
      end
    end
  end

  def find_leaf(key)
    c = root
    while c
      node = c
      if c.key_l && c.key_l > key
        c = c.nary[0]
      elsif c.key_r && c.key_r < key
        c = c.nary[2]
      elsif !c.key_r && c.key_l < key
        c = c.nary[1]
      elsif c.key_r && c.key_l && c.key_r > key && c.key_l < key
        c = c.nary[1]
      else
        break
      end
    end
    node
  end

  def sort_key(leaf, key)
    ary ||= [] << leaf.key_l << leaf.key_r << key
    ary.compact.sort!
  end

  # aux's key is split location with tmp children.
  def get_parent_aux(leaf, parent, split_node)
    ary = parent.nary
    if parent.nary[0] == leaf
      ary.insert(1, split_node)
    elsif parent.nary[1] == leaf
      ary.insert(2, split_node)
    else
      ary << split_node
    end
    ary
  end

  def renew_node(node, new_key)
    node.key_l = new_key
    node.key_r = nil
    node.size = 1
  end

  # rearrange children links
  def assign_children_links(exist_node, aux, new_node = nil)
    exist_node.nary = []
    (0..1).each do |e| 
      if aux[e]
        exist_node.nary[e] = aux[e]
        aux[e].p = exist_node 
      end
    end

    if new_node != nil
      exist_node.nary[2] = nil
      if aux[2]
        new_node.nary[0] = aux[2] 
        aux[2].p = new_node
      end
      if aux[3]
        new_node.nary[1] = aux[3]
        aux[3].p = new_node
      end
      # delete right child for existing node.
      exist_node.nary.delete_at(2)
    else
      if aux[2]
        exist_node.nary[2] = aux[2]
        aux[2].p = exist_node
      end
    end
  end

end