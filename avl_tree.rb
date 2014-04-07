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
        current = current.left_node
      elsif current.key < key
        current = current.right_node
      else
        break
      end
    end
    puts "#{current ? "Found" : "Not found"} key #{key}."
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
    result = search_key key
    if result
      # no child or one child
      if !result.left_node || !result.right_node
        tmp = result.right_node ? result.right_node : result.left_node
        if result.parent
          tmp.parent = result.parent if tmp
          if result.parent.left_node == result 
            result.parent.left_node = tmp 
          else
            result.parent.right_node = tmp
          end
          get_height result.parent
          get_balance_factor result.parent
          balance result.parent
        else
          @root = tmp
          tmp.parent = nil if tmp
        end
      else
        # result has 2 children
        # only 1 child for result's children, because AVL tree heights differ only at most 1, so suleaf's child has no children.
        
        successor = result.right_node
        # find inorder successor, and replace, balance.
        # successor at most 1 child. onlt in right, otherwise succesor will not be left-most node. 
        while successor.left_node
          successor = successor.left_node
        end
        suc_parent = successor.parent
        
        if parent = result.parent
          if parent.left_node == result
            parent.left_node = successor 
          else
            parent.right_node = successor 
          end
        else
          @root = successor if parent == nil  
        end
        
        successor.left_node = result.left_node
        successor.left_node.parent = successor 
        
        if suc_parent != result
          suc_parent.left_node = successor.right_node
          successor.right_node = result.right_node
        end        

        successor.right_node.parent = successor if successor.right_node
        successor.parent = parent  
        
        # find successor's parent's deepest then update it.
        deepest_leaf = suc_parent
        while deepest_leaf
          if deepest_leaf.left_node && deepest_leaf.right_node
            if deepest_leaf.left_node.height > deepest_leaf.right_node.height
              deepest_leaf = deepest_leaf.left_node
            else
              deepest_leaf = deepest_leaf.right_node
            end
          else
            if deepest_leaf.left_node
              deepest_leaf = deepest_leaf.left_node
            else
              deepest_leaf.right_node ? deepest_leaf = deepest_leaf.right_node : break
            end
          end
        end

        #require 'pry'; binding.pry
        balance deepest_leaf
      end
      result = nil
    end
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
          puts "current node #{current.key}, bf: #{current.balance_factor}, height: #{current.height}, parent: #{current.parent.key if current.parent} "
          current = current.right_node
        else
          pre.right_node = current
          current = current.left_node
        end
      else
        visit current
          puts "current node #{current.key}, bf: #{current.balance_factor}, height: #{current.height}, parent: #{current.parent.key if current.parent} "
        current = current.right_node
      end
    end
    print_traversal_list
    return nil
  end

  def print_traversal_list
    ary ||= []
    if traverse_list 
      traverse_list.each do |e|
        ary << e.key 
      end
      puts "Traversing order: #{ary.inspect}"
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
    #require 'pry'; binding.pry
    #puts "RL"
    sub_left = child.left_node

    parent.right_node = sub_left.left_node
    child.left_node = sub_left.right_node
    sub_left.left_node = parent
    sub_left.right_node = child

    sub_left.parent = parent.parent
    child.parent = sub_left
    if parent.parent
      parent.parent.left_node == parent ? parent.parent.left_node = sub_left : parent.parent.right_node = sub_left
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
    while node && node.parent
      get_balance_factor node.parent
      node = node.parent
    end
  end

  def update_height(node)
    while node && node.parent
      get_height node.parent
      node = node.parent
    end
  end

  def visit(node)
    self.traverse_list << node
  end
end