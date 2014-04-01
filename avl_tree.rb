class BinarySearchNode
  attr_accessor :left_node, :right_node, :key, :parent, :height

  def initialize(*values)
    self.key = values[0]
    self.left_node = Node.new(values[1]) if values[1]
    self.right_node = Node.new(values[2]) if values[2]
    self.parent = nil
    self.height = 0
  end
  

  def update_hegiht
    l_h = left_node ? left_node.height : 0
    r_h = right_node ? right_node.height : 0
    @height = 1 + (l_h > r_h ? l_h : r_h)
  end
end

class AvlTree
  attr_accessor :root, :traverse_list 
  def initialize(key)
    @root = BinarySearchNode.new key
    @traverse_list = []
  end

  def search_key(key)
    current = root
    while current
      if current.key > key
        current = current.left
      elsif current.key < key
        current = current.right
      else
        break
      end
    end
    puts "#{current ? "Not found" : "Found"} key #{key}."
    current
  end

  def avl_insert(new_key)
    node = BinarySearchNode.new new_key
    current = self.root
    while current
      if current.key >= new_key
        direction = 0
        current.left_node ? current = current.left_node : break
      else
        direction = 1
        current.right_node ? current = current.right_node : break
      end
    end
    direction == 1 ? current.right_node = node : current.left_node = node
    node.parent = current
    balance node    
  end

  def avl_delete(key)
    
  end

  def balance(node)
    update_height node
  end

  def morris_traversal
    self.traverse_list.clear
    current = root
    while current
      if current.left_node
        pre = current.left_node
        pre = pre.right_node while pre.right_node && pre.right_node != current
        # meet node which insert by traversal.
        if pre.right_node
          pre.right_node = nil
          visit current
          puts "current node: #{current.key}, height: #{current.height}"
          current = current.right_node
        else
          pre.right_node = current
          current = current.left_node
        end
      else
          puts "current node: #{current.key}, height: #{current.height}"
        visit current
        current = current.right_node
      end
    end
    print_traversal_list
  end

  def print_traversal_list
    ary ||= []
    if traverse_list 
      traverse_list.each do |e|
        ary << e.key 
      end
      puts ary.inspect
    else
      puts "No traverse made."
    end
    ary
  end

private

  def rotate
    
  end

  def update_height node
    while node.parent
      node.height >= node.parent.height ? node.parent.height += 1 : break
      node = node.parent
    end
  end

  def visit(node)
    self.traverse_list << node
  end
end