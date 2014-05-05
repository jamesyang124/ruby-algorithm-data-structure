require 'pry'

RED = 0
BLACK = 1

class RBNode
  attr_accessor :color, :l, :r, :p, :key

  # In default, new node is colored as red.
  def initialize(key, color)
    @key = key
    @color = color
  end
end

class RBTree
  attr_reader :root
  
  def initialize(key)
    @root = add_node key, BLACK
  end

  def insert(key)
    node = add_node key, RED
    
    while node != root && node.p.color == RED
      u = uncle node
      if u.color == RED
        node.p.color, u.color = BLACK, BLACK
        grand_parent(node).color = RED
        node = grand_parent(node)
      else
        if node.p == grand_parent(node).l
          # node = node.p.r && node.p == grand_parent.l
          if node == node.p.r
            node = node.p
            left_rotate node 
          end
          node.p.color = BLACK
          grand_parent(node).color = RED
          right_rotate grand_parent(node)
        else
          # node = node.p.l && node.p == grand_parent.r
          if node == node.p.l
            node = node.p
            right_rotate node
          end
          node.p.color = BLACK
          grand_parent(node).color = RED
          left_rotate grand_parent(node)  
        end
      end
    end
    root.color = BLACK
#    binding.pry
  end

  # current is pred or succ, so has at most one child in any case.
  # case 1 current is red leaf
  
  # impossible case 1 : current is red with 1 child
    # => must be black child or violate rb tree propery.
    # => cannot has black child, if so, black count in path not balanced.
  # impossible case 2 : current is black with 1 black child
    # => black count in each path cannot balanced

  # case 2 current is black, has only one red child
  # case 3 cuurent is black, has no children => check siblings
    # sib is red
    # sib is black, sib with two black children
    # sib is black, sib with one or two red children

  # pick either succ or pred are fine. In here we prefer succ. 
  def delete(key)
    node = search key
    if !node.l && !node.r
      # It's leaf, just remove it.
      node.p.l == node ? node.p.l = nil : node.p.r = nil
    elsif has_one_child(node)
      child = node.r || node.l
      # Only color case: child must be red leaf. node must be black.
      node.p.l == node ? node.p.l = child : node.p.r = child
      child.p = node.p
      child.color = node.color # must be black
    else
      succ = find_succ node
      # succ must be in right subtree of node. 
      # succ has at most one child in right branch.

      # succ is right child of node.
      if succ && succ.key
        if succ == node.r
          node.p.l == node ? node.p.l = succ : node.p.r = succ
          succ.l, succ.p = node.l, node.p
          succ.color = node.color
          if succ.r
            succ.r.color = succ.color
            adjust(succ.r)
          end
        else
          node.key, succ.key = succ.key, node.key
          succ.p.l == succ ? succ.p.l = succ.r : succ.p.r = succ.r
          if succ.r
            succ.r.p = succ.p
            succ.r.color = succ.color
            adjust(succ.r)
          end  
        end
      end
    end
  end


  def search(key)
    current = root
    while current && current.key
      if current.key < key
        current = current.r
      elsif current.key > key
        current = current.l
      else
        break
      end
    end
    current
  end

  def print_tree(node = root)
    print_tree node.l if node.l
    puts if node.l && node.l.key
    visit node
    puts if node.r && node.r.key
    print_tree node.r if node.r
  end

  def visit node
    if node.key 
      puts "Node #{node.key}, l: #{node.l && node.l.key ? node.l.key : "leaf" }, r: #{node.r && node.r.key ? node.r.key : "leaf" }, parent: #{node.p.key if node.p }, color: #{node.color == 1 ? "BLACK" : "RED"}"
    else
      puts "Leaf Node, parent: #{node.p.key}, color: #{node.color == 1 ? "BLACK" : "RED"}"
    end
  end

private
  
  def adjust(node)
    if node.p.color == BLACK && node.color == BLACK
      sib  = sibling node
      if sib.color == RED
        sib == node.p.r ? left_rotate(node.p) : right_rotate(node.p)
        sib.color, node.p.color = node.p.color, sib.color
        adjust(node)
      else
        if sib.l.color == BLACK && sib.r.color == BLACK
          sib.color == RED
          adjust(node.p)
        elsif sib.r.color == RED
          left_rotate(node.p)
          sib.color, node.p.color = node.p.color, sib.color
          sib.r.color = BLACK
        elsif sib.l.color == RED && sib.r.color == BLACK
          right_rotate(sib)
          sib.color, sib.p.color = sib.p.color, sib.color
          adjust(node) 
        end
      end
    end
  end

  def has_one_child(node)
    (node.l && !node.r) || (node.r && !node.l)
  end

  def find_pred(node)
    if node.l && node.l.key != nil
      current = node.l
      while current.r && current.r.key
        current = current.r
      end
    else  
      current = node.p
      while current && current.key && node == current.l
        node = current
        current = current.p
      end
    end
    # if current == nil, then node is first inorder traversed node
    current
  end

  def find_succ(node)
    if node.r && node.r.key != nil
      current = node.r
      while current.l && current.l.key
        current = current.l
      end
    else  
      current = node.p
      while current && current.key && node == current.r
        node = current
        current = current.p
      end
    end
    # if current == nil, then node is last inorder traversed node
    current
  end

  def sibling(node)
    if p = node.p
      sib = p.l == node ? p.r : p.l
    end
    sib
  end

  def grand_parent(node)
    node && node.p ? node.p.p : nil
  end

  def uncle(node)
    g = grand_parent node
    return nil unless g
    node.p == g.l ? g.r : g.l
  end

  def left_rotate(node)
    r_child = node.r
    if node.p
      node == node.p.l ? node.p.l = r_child : node.p.r = r_child
    else
      @root = r_child
    end
    node.r = r_child.l
    r_child.l.p = node
    r_child.l = node
    r_child.p = node.p
    node.p = r_child
  end

  #      n     r_rotate    x
  #     / \      ==>      / \
  #    x   c     <==     a   n
  #   / \      l_rotate     / \
  #  a   b                 b   c

  def right_rotate(node)
    l_child = node.l
    if node.p
      node == node.p.l ? node.p.l = l_child : node.p.r = l_child
    else
      @root = l_child
    end
    node.l = l_child.r
    l_child.r.p = node
    l_child.r = node
    l_child.p = node.p
    node.p = l_child
  end

  # bst insert operation
  def add_node(key, color)
    node = RBNode.new key, color
    leaf_l = RBNode.new nil, BLACK
    leaf_r = RBNode.new nil, BLACK
    node.l, node.r = leaf_l, leaf_r
    leaf_l.p, leaf_r.p = node, node

    current = root
    while current && current.key
      pre = current
      if current.key < key
        current = current.r
        loc = 1 
      elsif current.key > key
        current = current.l
        loc = 0
      else
        puts "Key value already exist."
        break
      end
    end

    if pre
      loc == 1 ? pre.r = node : pre.l = node
      node.p = pre
    else
      @root = node
    end
    node
  end
end