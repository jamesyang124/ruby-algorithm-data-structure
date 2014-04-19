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
    
  end

  def print_list
    current = root
    ary = []
    ary << current
    while current
      printf "Current: %-7s, node_left: %-2s, node_middle: %-2s, node_right: %-2s, parent: %5s\n", "#{current.key_l} / #{current.key_r}", "#{current.nary[0].key_l if current.nary[0]}", "#{current.nary[1].key_l if current.nary[1]}","#{current.nary[2].key_l if current.nary[2]}", "#{current.p.key_l if current.p} / #{current.p.key_r if current.p}"
      ary << current.nary[0] if current.nary[0]
      ary << current.nary[1] if current.nary[1]
      ary << current.nary[2] if current.nary[2]
      ary.shift
      current = ary.first     
    end 
  end

private

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

        # assign links for recursion happens
        assign_links(node, aux, new_node) if aux
        node.key_r = nil
        node.size = 1

        @root = node.p
        @root.nary[0] = node
        @root.nary[1] = new_node
      end
    else
      if node.size < 2
        node.key_l, node.key_r = sort[0], sort[1]
        aux = node.nary
        # !node.nary.empty => is not leaf.
        assign_links(node, aux) if !node.nary.empty?
        node.size += 1
      else
        new_node = BtreeNode.new sort[2]
        new_node.p = node.p
        node.key_r = nil
        node.key_l = sort[0]
        node.size = 1
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