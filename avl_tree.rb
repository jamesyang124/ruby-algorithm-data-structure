class BinarySearchNode
  # height increase from bottom-up
  attr_accessor :left_node, :right_node, :key, :parent, :height, :balance_factor

  def initialize(*values)
    self.key = values[0]
    self.left_node = Node.new(values[1]) if values[1]
    self.right_node = Node.new(values[2]) if values[2]
    self.parent = nil
    self.height = 1
    self.balance_factor = 0
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
    morris_traversal   
  end

  def avl_delete(key)
    
  end

  # direction determine new node in left or right child.
  # Ex: LR => left child's right subtree
  def balance(node)
    update_height node
    update_balance_factor node

    parent = node.parent
    child = node
    sub_tree = nil
    while parent
      direction = parent.left_node == child ? 1 : -1
      if sub_tree
        if parent.balance_factor < -1
          if sub_tree == 1
            RLrotate(parent, parent.right_node)
          else
            RRrotate(parent, parent.right_node)
          end
        elsif parent.balance_factor > 1
          if sub_tree == 1
            LLrotate(parent, parent.left_node)
          else
            LRrotate(parent, parent.left_node)
          end
        end
      end
      sub_tree = direction
      child = parent
      parent = parent.parent
    end
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
          puts "current node: #{current.key}, height: #{current.height}, balance_factor: #{current.balance_factor}"
          current = current.right_node
        else
          pre.right_node = current
          current = current.left_node
        end
      else
          puts "current node: #{current.key}, height: #{current.height}, balance_factor: #{current.balance_factor}"
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

  def LLrotate(parent, child)
    parent.left_node = child.right_node
    child.right_node.parent = parent if child.right_node
    child.right_node = parent

    child.parent = parent.parent
    if parent.parent
      parent.parent.left_node == parent ? parent.parent.left_node = child : parent.parent.right_node = child
    else
      @root = child if parent == root
    end
    parent.parent = child

    get_height parent
    get_height child
    update_height child

    get_balance_factor parent
    update_balance_factor parent
    
    #puts "LL"
    #require 'pry'; binding.pry
  end

  def LRrotate(parent, child)
    sub_right = child.right_node

    parent.left_node = sub_right.right_node
    child.right_node = sub_right.left_node
    sub_right.left_node = child
    sub_right.right_node = parent
    
    sub_right.parent = parent.parent
    child.parent = sub_right
    if parent.parent
      parent.parent.left_node == parent ? parent.parent.left_node = sub_right : parent.parent.right_node = sub_right  
    else
      @root = sub_right if parent == root
    end
    parent.parent = sub_right

    get_height parent
    get_height child
    get_height sub_right
    update_height sub_right

    get_balance_factor parent
    get_balance_factor child
    update_balance_factor parent
   
    #puts "LR"
    #require 'pry'; binding.pry
  end

  def RRrotate(parent, child)
    parent.right_node = child.left_node
    child.left_node.parent = parent if child.left_node
    child.left_node = parent

    child.parent = parent.parent
    
    if parent.parent
      parent.parent.left_node == parent ? parent.parent.left_node = child : parent.parent.right_node = child
    else
      @root = child if parent == root
    end
    parent.parent = child

    get_height parent
    get_height child
    update_height child

    get_balance_factor parent
    update_balance_factor parent

    #puts "RR"
    #require 'pry'; binding.pry
  end

  def RLrotate(parent, child)
    sub_left = child.left_node

    parent.right_node = sub_left.left_node
    child.left_node = sub_left.right_node
    sub_left.left_node = parent
    sub_left.right_node = child

    sub_left.parent = parent.parent
    child.parent = sub_left
    if parent.parent
      parent.parent && parent.parent.left_node == parent ? parent.parent.left_node = sub_left : parent.parent.right_node = sub_left
    else
      @root = sub_left if parent == root
    end
    parent.parent = sub_left

    get_height parent
    get_height child
    get_height sub_left
    update_height sub_left

    get_balance_factor parent
    get_balance_factor child
    update_balance_factor parent

    #puts "RL"
    #require 'pry'; binding.pry
  end

  def get_height(node)
    n_l = node.left_node
    n_r = node.right_node
    n_h = node.height

    n_h = 0 if !n_l && !n_r
    n_h = n_l.height if n_l && !n_r
    n_h = n_r.height if !n_l && n_r
    if n_l and n_r
      n_h = n_r.height >= n_l.height ? n_r.height : n_l.height
    end
    n_h += 1
    node.height = n_h
  end

  def get_balance_factor(node)
    n_l = node.left_node
    n_r = node.right_node
    n_b = node.balance_factor
    
    n_b = n_l.height - n_r.height if n_l && n_r
    n_b = n_l.height if !n_r && n_l
    n_b = - n_r.height if n_r && !n_l
    n_b = 0 if !n_r && !n_l
    node.balance_factor = n_b
  end

  def update_balance_factor(node)
    while node.parent
      get_balance_factor node.parent
      node = node.parent
    end
  end

  def update_height(node)
    while node.parent
      get_height node.parent
      node = node.parent
    end
  end

  def visit(node)
    self.traverse_list << node
  end
end