class SplayNode
  attr_accessor :l, :r, :parent, :key
  def initialize key
    @key = key
  end
end

class SplayTree
  attr_accessor :root

  def initialize(key)
    @root = SplayNode.new key  
  end

  def insert(key)
    current = root
    while current
      node = current
      current = current.key < key ? current.r : current.l
    end
    current = SplayNode.new key
    node.key < key ? node.r = current : node.l = current
    current.parent = node
    splay(current)
  end

  def search(key)
    current = root
    while current
      if current.key > key
        current = current.r
      elsif current.key < key
        current = current.l
      else
        break
      end
    end
    puts "#{current.key == key ? "Found" : "Not found"} key #{key} in tree."
    current
  end

  def delete(key)
    result = search key
    if result
      splay(result)
      if !result.l
        replace(result, result.r) 
      elsif !result.r
        replace(result, result.l)
      else
        sub_min = subtree_minimum result.r
        if sub_min.parent != result
          replace(sub_min, sub_min.r)
          sub_min.r = result.r
          sub_min.r.parent = sub_min
        end
        replace(result, sub_min)
        sub_min.l = result.l
        sub_min.l.parent = result
      end
    end
  end

  def print_tree
    current = root
    while current
      if current.l
        pre = current.l
        pre = pre.r while pre.r && pre.r != current
        
        if pre.r == current
          pre.r = nil
          visit current
          current = current.r
        else
          pre.r = current
          current = current.l
        end
      else
        visit current
        current = current.r
      end
    end
  end

private

  #   x             y
  #  / \           / \
  # t   y    =>   x   k
  #    / \       / \
  #   l   k     t   l
  # move y to top of x, x's right as y's left.
  def left_rotate(node)
    r_child = node.r
    node.r = r_child.l
    r_child.l.parent = node if r_child.l
    r_child.parent = node.parent
    if node.parent 
      node == node.parent.l ? node.parent.l = r_child : node.parent.r = r_child
    else
      @root = r_child
    end
    r_child.l = node
    node.parent = r_child
  end

  #     y            x    
  #    / \          / \   
  #   x   k   =>   t   y  
  #  / \              / \ 
  # t   l            l   k
  # move x to top of y, y's left as x's right.
  def right_rotate(node)
    l_child = node.l
    node.l = l_child.r
    l_child.r.parent = node if l_child.r    
    l_child.parent = node.parent
    if node.parent
      node == node.parent.l ? node.parent.l = l_child : node.parent.r = l_child
    else
      @root = l_child 
    end
    l_child.r = node
    node.parent = l_child
  end

  def replace(node_u, node_v)
    if !node_u.parent
      @root = node_v 
    elsif node_u == node_u.parent.left
      node_u.parent.left = node_v
    else
      node_u.parent.right = node_v
    end  
    node_v.parent = node_u.parent if node_v
  end

  def splay(node)
    while node.parent
      if (!node.parent.parent)
        node.parent.l == node ? right_rotate(node.parent) : left_rotate(node.parent)
      elsif node.parent.l == node && node.parent.parent.l == node.parent
        right_rotate(node.parent.parent)
        right_rotate(node.parent)
      elsif node.parent.r == node && node.parent.parent.r == node.parent
        left_rotate(node.parent.parent)
        left_rotate(node.parent)
      elsif node.parent.l == node && node.parent.parent.r == node.parent
        right_rotate(node.parent)
        left_rotate(node.parent)
      else
        left_rotate(node.parent)
        right_rotate(node.parent)
      end  
    end
  end

  def subtree_minimum(node)
    node = node.l while node.l
    node
  end

  def subtree_maximum(node)
    node = node.r while node.r
    node
  end

  def visit(node)
    p node.key
  end
end