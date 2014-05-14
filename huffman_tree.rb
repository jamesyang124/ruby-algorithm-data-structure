require_relative './binary_search_tree'

require 'pry'

GIVEN = [['A', 15], ['B', 8], ['C', 30], ['D', 27], ['E', 5], ['F', 15]].sort! do |x, y|
  x[1] <=> y[1]
end


class HuffmanTree < BinaryTree
  attr_accessor :huf_root, :tree_set
  Node.class_eval do
    attr_reader :key
    alias :l :left_node
    alias :r :right_node
    alias :l= :left_node=
    alias :r= :right_node=
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
    @huf_root = nil
    list ||= [].concat GIVEN
    build_tree list
  end

  def insert(pair)
    self.class.root = @root
    self.class.insert pair
  end

  def build_tree(list)
    while list.size > 1
      l = list.shift
      r = list.shift
      w = l[1] + r[1]
      t = new_tree l, r, w

      get_l_tree = find_merged_tree l[1], tree_set
      get_r_tree = find_merged_tree r[1], tree_set

      if get_l_tree
        t.l = tree_set[get_l_tree]
        tree_set.delete_at(find_merged_tree l[1], tree_set)
      end

      if get_r_tree
        # previous deletion change index now.
        new_index = find_merged_tree r[1], tree_set
        t.r = tree_set[new_index]     
        tree_set.delete_at(new_index)
      end

      @huf_root = t

      key_pair = [t.key, t.value]
      puts "#Key Pair: #{key_pair}"
      list.push(key_pair).sort! do |x, y|
        x[1] <=> y[1] 
      end
    end
  end

  def new_tree(l, r, w)
    tree = Node.new "P", w
    tree.l = Node.new *l 
    tree.r = Node.new *r
    tree_set.push tree
    tree
  end

  def encode(key)
    current = huf_root
    code = ""
    while current
      if current.w > key
        current = current.l
        code << '0'
      elsif current.w < key
        current = current.r
        code << '1'
      else
        break
      end
    end
    puts "get code for key #{key}: #{code}"
  end

  def decode(input)
    current = huf_root
    str = ""
    while input
      if !current.l && !current.r
        str << current.key
        current = huf_root
      else
        direction = input.shift
        current = direction == 0 ? current.l : current.r
      end
    end
    str
  end

  def find_merged_tree(value, tree_set)
    return tree_set.index do |x|
        x.w == value
      end unless tree_set.empty?
  end

  def morris_traversal
    self.class.morris_inorder_traversal huf_root
  end

end