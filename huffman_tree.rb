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
      gt = list.index { |x| x[1] > t.value }
      # if gt == nil, then no element greater than t.value so put it to end.
      gt ? list.insert(gt, key_pair) : list << key_pair
    end
  end

  def new_tree(l, r, w)
    tree = Node.new "PNode", w
    tree.l = Node.new *l 
    tree.r = Node.new *r
    tree_set.push tree
    tree
  end

  def char_value(char)
    GIVEN.index do |x|
      x[0] == char
    end
  end

  def encode(str)
    chary = str.chars
    table = code_table
    code = ""
    while char = chary.shift
      e = table.index { |x| x[0].key == char }
      code << table[e][1]
    end
    puts "get code for str #{str}: #{code}"
  end

  def code_table
    ary = [] << [huf_root, ""]
    table = []
    until ary.empty?
      node = ary.shift
      ary.unshift([node[0].r, node[1] + "1"]) if node && node[0].r
      ary.unshift([node[0].l, node[1] + "0"]) if node && node[0].l
      table << node if !node[0].r && !node[0].l
    end
    table
  end

  def decode(input)
    input = input.to_s.chars
    current = huf_root
    str = ""
    while direction = input.shift
      if !current.l && !current.r
        str << current.key
        current = huf_root
      else
        current = direction == 0 ? current.l : current.r
      end
    end
    str
  end

  def find_merged_tree(value, tree_set)
    tree_set.index do |x|
      x.w == value
    end unless tree_set.empty?
  end

  def morris_traversal
    self.class.morris_inorder_traversal huf_root
  end

end