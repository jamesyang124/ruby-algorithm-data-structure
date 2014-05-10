require_relative './binary_search_tree'

require 'pry'

GIVEN = [['A', '15'], ['B', '8'], ['C', '30'], ['D', '27'], ['E', '5'], ['F', '15']]

class HuffmanTree < BinaryTree
  attr_accessor :root, :tree_set
  Node.class_eval do
    attr_reader :key
    alias :l :left_node
    alias :r :right_node
    alias :w :value
    alias :init :initialize

    def initialize(*key_pair)
      @key = key_pair[0]
      init key_pair[1]
    end
  end

  def initialize()
    # splat operator
    # b, c = *[1, 2] => b = 1, c = 2
    # *d = 1, 2, 3 => d = [1, 2, 3]
    @tree_set = []
    build_tree
  end

  def insert(pair)
    self.class.root = @root
    self.class.insert pair
  end

  def build_tree
    while GIVEN.size > 1
      l = GIVEN.shift
      r = GIVEN.shift
      w = l[1] + r[1]
      t = new_tree l, r
      
      get_l_tree = tree_set.index do |x|
        x.w == l[1]
      end

      get_r_tree = tree_set.index do |x|
        x.w == r[1]
      end
      
      t.l = tree_set[get_l_tree] if get_l_tree
      t.r = tree_set[get_r_tree] if get_r_tree
      @root = t
      self.class.root = @root
      key_pair = [@root.key, @root.value]
      GIVEN.add(key_pair).sort!
    end
  end

  def new_tree(l, r)
    tree = Node.new "P", w
    tree.l = Node.new *l 
    tree.r = NOde.new *r
    tree_set.add tree
    tree
  end

  def morris_traversal
    self.class.root = @root
    self.class.morris_inorder_traversal
  end

end
binding.pry