# 2-3 tree => b tree of order 3
class BtreeNode
  # key_l => key left, key_r => key right
  # nary[0] => left, nary[1] => mid, nary[2] => right
  # n => size
  # p => parent
  attr_accessor :key_l, :key_r, :nary, :size, :p, :isLeaf
  
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
    node = find_leaf key
    split(node, key)
  end

  def search(key)
    result = find_leaf key
    if result
      puts "Node #{key}, left:s #{result.key_l}, right: #{result.key_r}"
    else
      puts "Find nothing."
    end
  end

  def delete(key)
    # rotate
    # substitution nearest value to that position
    result = find_leaf key

    if result.nary.empty? # result is leaf
      if result.size == 2
        result.key_l == key ? result.key_l = nil : result.key_r = nil
        result.size -= 1 
      else
        result.key_l = nil
        result.size = 0
        handle_hole result
      end
    else  # result is internel node
      pred = inorder_predecessor result, key
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

  # hole is special node has only one link because its a combination from sub-leaf node to current node.
  def handle_hole(hole)
    if hole.parent.size == 1
      loc, sib = get_2_node_sib hole.parent, hole
      if loc == 1
        if sib.size == 1
          # hole has 2-node parent, 2-node right sibling, rotation
          sib.nary.insert(0, hole.nary[0])
          sib.key_l, sib.key_r = hole.parent.key_l, sib.key_l
          hole.parent.key_l = nil
          hole.parent.nary.clear << sib
          sib.size = 2
          hole.parent.size = 0
          handle_hole(hole.parent)
        else
          # hole has 2-node parent, 3-node right sibling, rotation
          hole.key_l, sib.parent.key_l, sib.key_l , sib.key_r = sib.parent.key_l, sib.key_l , sib.key_r, nil
          hole.nary << sib.nary.shift 
          hole.size = 1
          sib.size = 1
        end
      else
        if sib.size == 1
          # hole has 2-node parent, 2-node left sibling, rotation
          sib.nary << hole.nary[0]
          sib.key_r = hole.parent.key_l
          hole.parent.key_l = nil
          hole.parent.nary.clear << sib
          hole.parent.size = 0
          sib.size = 2
          handle_hole(hole.parent)
        else
          # hole has 2-node parent, 3-node left sibling, rotation
          hole.key_l, sib.parent.key_l, sib.key_r = sib.parent.key_l, sib.key_r , sib.key_r, nil
          hole.nary << sib.nary.pop
          hole.size = 1
          sib.size = 1
        end
      end
    elsif hole.parent.size == 2
      loc, sib = get_3_node_sib hole.parent, hole
      if loc == 0
        if sib.size == 1
          # hole has 3-node parent, 2-node left sibling, rotation  
          sib.key_r, hole.parent.key_r = hole.parent.key_r, nil
          sib.nary.concat hole.nary
          hole.parent.nary.pop
          hole.parent.size = 1
          sib.size = 2
        else
          # hole has 3-node parent, 3-node left sibling, rotation
          hole.key_l, hole.parent.key_r, sib.key_r = hole.parent.key_r, sib.key_r, nil
          hole.nary.insert(0, sib.nary.pop)
          hole.size = 1
          sib.size = 1  
        end
      elsif loc == 1
        # hole has 3-node parent, 2-node right sibling, rotation
        if sib.size == 1 
          sib.nary.insert(0, hole.nary[0])
          sib.key_l, sib.key_r, hole.parent.key_l, hole.parent.key_r = hole.parent.key_l, sib.key_l, hole.parent.key_r, nil
          hole.parent.nary.shift 
          hole.parent.size = 1
          sib.size = 2
        else
          # hole has 3-node parent, 3-node right sibling, rotation  
          hole.key_l, hole.parent.key_l, sib.key_l, sib.key_r = hole.parent.key_l, sib.key_l, sib.key_r, nil
          hole.nary << sib.nary.shift
          hole.size = 1
          sib.size = 1
        end
      else
        # hole in middle, prefer to pick left sib(right is also ok).
        if sib.size == 1
          # hole in middle and has 3-node parent, 2-node sibling.
          sib.key_r, hole.parent.key_l, hole.parent.key_r = hole.parent.key_l, hole.parent.key_r, nil
          sib.nary.concat hole.nary
          hole.parent.nary.delete_if { |e| e == hole }
          hole.parent.size = 1
          sib.size = 2 
        else
          # hole in middle and has 3-node parent, 3-node sibling.
          hole.key_l, hole.parent.key_l, sib.key_r = hole.parent.key_l, sib.key_r, nil
          hole.nary.insert(0, sib.nary.pop)
          hole.size = 1
          sib.size = 1  
        end
      end
    else
      # hole in hole.parent. It should not happened.
    end
  end

  def get_3_node_sib(parent, node)
    if parent.nary[0] == node 
      return 1, parent.nary[1] if parent.nary[1].size == 1
    elsif parent.nary[2] == node
      # In here we prefer take left side sib, take right side sib also fine.
      return 0, parent.nary[1] if parent.nary[1].size == 1
    else
      return 2, parent.nary[0] if parent.nary[0].size == 1
    end
  end

  def get_2_node_sib(parent, node)
    if parent.nary[0] == node
      # sib in right
      return 1, parent.nary[1]
    else
      # sib in left
      return 0, parent.nary[0]
    end
  end

  # aux is a children list for rearranging new children.
  def split(node, key, aux = nil)
    sort = sort_key(node, key)
    if node == root
      if node.size < 2
        node.key_l, node.key_r = sort[0], sort[1]
        node.size += 1
      else
        node.p = BtreeNode.new sort[1]
        new_node = BtreeNode.new sort[2]
        new_node.p = node.p

        # assign links if recursion happens
        assign_links(node, aux, new_node) if aux
        update_node(node, sort[0])

        @root = node.p
        @root.nary[0] = node
        @root.nary[1] = new_node
      end
    else
      if node.size < 2
        node.key_l, node.key_r = sort[0], sort[1]
        # !node.nary.empty => is not leaf.
        assign_links(node, aux) if !node.nary.empty?
        node.size += 1
      else
        new_node = BtreeNode.new sort[2]
        new_node.p = node.p
        update_node(node, sort[0])

        # assign link for current node
        assign_links(node, aux, new_node) if !node.nary.empty?
        aux = get_parent_aux(node, node.p, new_node)
        split(node.p, sort[1], aux) if node.p != nil
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
    ary = [] 
    ary << leaf.key_l if leaf.key_l 
    ary << leaf.key_r if leaf.key_r 
    ary << key
    ary.sort!
  end

  # aux's key is split location with tmp children.
  def get_parent_aux(leaf, parent, split_node)
    ary = []
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

  def update_node(node, new_key)
    node.key_l = new_key
    node.key_r = nil
    node.size = 1
  end

  # rearrange children links
  def assign_links(exist_node, aux, new_node = nil)
    exist_node.nary = []
    (0..1).each do |e| 
      if aux[e]
        exist_node.nary[e] = aux[e]
        aux[e].p = exist_node 
      end
    end

    if new_node != nil
      exist_node.nary[2] = nil
      new_node.nary[0] = aux[2] if aux[2]
      aux[2].p = new_node if aux[2]
      new_node.nary[1] = aux[3] if aux[3]
      aux[3].p = new_node if aux[3]
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