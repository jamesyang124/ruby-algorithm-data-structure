class BinarySearchNode
  attr_accessor :left_node, :right_node, :key, :parent

  def initialize(*values)
    self.key = values[0]
    self.left_node = Node.new(values[1]) if values[1]
    self.right_node = Node.new(values[2]) if values[2]
    self.parent = nil
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

  def avl_insert(new_node)
    
  end

  def avl_delete(key)
    
  end

  def morris_traversal
    self.traverse_list.clear
    current = root
    while current
      if current.left_node
        pre = current.left_node
        pre = pre.left_node while pre.right_node && pre.right_node != current
        # meet node which insert by traversal.
        if pre.right_node
          pre.right_node = nil
          visit current
          current = current.right_node
        else
          pre.right_node = current
          current = current.left_node
        end
      else
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

  def visit(node)
    self.traverse_list << node
  end
end