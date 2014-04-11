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
      current = current.key > key ? current.r : current.l
    end
    current = SplayNode.new key
    node.key > key ? node.r = current : node.l = current
    current.parent = node
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
    if resulst
      # no or 1 child only
      if !result.l || !result.r
        child = result.l || result.r
        if result.parent
          result.parent.l == result ? result.parent.l = child : result.parent.r = child
          child.parent = result.parent
        else
          child.parent = nil
          @root = child
        end
      else
        # two children
      end
    end
  end

  def print_tree
    current = root
    while current
      if current.l
        pre = current.l
        while pre.r && pre.r != current
          pre = pre.r
        end
        
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

  def left_rotate
    
  end

  def right_rotate
    
  end

  def replace
    
  end

  def splay
    
  end

  def subtree_minimum(node)
    
  end

  def subtree_maximum(node)
    
  end
end