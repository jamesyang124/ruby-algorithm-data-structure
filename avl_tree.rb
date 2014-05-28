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

  alias :l :left_node
  alias :l= :left_node=
  alias :r :right_node
  alias :r= :right_node= 
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
      if !result.l || !result.r
        tmp = result.r ? result.r : result.l
        if result.parent
          tmp.parent = result.parent if tmp
          if result.parent.l == result 
            result.parent.l = tmp 
          else
            result.parent.r = tmp
          end
          get_height result.parent
          get_balance_factor result.parent
          balance result.parent
        else
          @root = tmp
          tmp.parent = nil if tmp
        end
      else
        # result HAS 2 CHILDREN
        # only 1 child for result's children, because AVL tree heights differ only at most 1, so leaf's child has no children.
              
        # find inorder succ, and replace, then balance.  
        # succ must be in subleaf becuase result has 2 children.
        succ = find_succ result
        suc_parent = succ.parent
        
        if parent = result.parent
          parent.l == result ? parent.l = succ : parent.r = succ 
        else
          @root = succ if parent == nil  
        end
        
        succ.l, succ.l.parent = result.l, succ 
        
        if suc_parent != result
          suc_parent.l = succ.r
          succ.r = result.r
        end     

        
        succ.r.parent = succ if succ.r
        succ.parent = parent  
        
        # find succ's parent's deepest then update it.
        deepest_leaf = suc_parent
        while deepest_leaf
          if deepest_leaf.l && deepest_leaf.r
            if deepest_leaf.l.height > deepest_leaf.r.height
              deepest_leaf = deepest_leaf.l
            else
              deepest_leaf = deepest_leaf.r
            end
          else
            if deepest_leaf.l
              deepest_leaf = deepest_leaf.l
            else
              deepest_leaf.r ? deepest_leaf = deepest_leaf.r : break
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
      direction = parent.l == child ? 1 : -1
      if sub_tree
        if parent.balance_factor < -1
          if sub_tree == 1
            RLrotate(parent, parent.r)
          else
            RRrotate(parent, parent.r)
          end
        elsif parent.balance_factor > 1
          if sub_tree == 1
            LLrotate(parent, parent.l)
          else
            LRrotate(parent, parent.l)
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
      if current.l
        pre = current.l
        pre = pre.r while pre.r && pre.r != current
        # meet node which insert by traversal.
        if pre.r
          pre.r = nil
          visit current
          puts "current node #{current.key}, bf: #{current.balance_factor}, height: #{current.height}, parent: #{current.parent.key if current.parent} "
          current = current.r
        else
          pre.r = current
          current = current.l
        end
      else
        visit current
          puts "current node #{current.key}, bf: #{current.balance_factor}, height: #{current.height}, parent: #{current.parent.key if current.parent} "
        current = current.r
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
    parent.l = child.r
    child.r.parent = parent if child.r
    child.r = parent

    child.parent = parent.parent
    if parent.parent
      parent.parent.l == parent ? parent.parent.l = child : parent.parent.r = child
    else
      @root = child if parent == root
    end
    parent.parent = child

    get_height parent
    get_height child
    update_height child

    get_balance_factor parent
    update_balance_factor parent
  end

  def LRrotate(parent, child)
    sub_right = child.r

    parent.l = sub_right.r
    child.r = sub_right.l
    sub_right.l = child
    sub_right.r = parent
    
    sub_right.parent = parent.parent
    child.parent = sub_right
    if parent.parent
      parent.parent.l == parent ? parent.parent.l = sub_right : parent.parent.r = sub_right  
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
   
  end

  def RRrotate(parent, child)
    parent.r = child.left_node
    child.l.parent = parent if child.l
    child.l = parent

    child.parent = parent.parent
    
    if parent.parent
      parent.parent.l == parent ? parent.parent.l = child : parent.parent.r = child
    else
      @root = child if parent == root
    end
    parent.parent = child

    get_height parent
    get_height child
    update_height child

    get_balance_factor parent
    update_balance_factor parent

  end

  def RLrotate(parent, child)
    sub_left = child.l

    parent.r = sub_left.l
    child.l = sub_left.r
    sub_left.l = parent
    sub_left.r = child

    sub_left.parent = parent.parent
    child.parent = sub_left
    if parent.parent
      parent.parent.l == parent ? parent.parent.l = sub_left : parent.parent.r = sub_left
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

  def find_succ(node)
    if node.r 
      current = node.r
      while current.l
        current = current.l
      end
    else
      current = node.p
      while current && current.r == node
        node = current
        current = current.p
      end
    end
    current
  end
end