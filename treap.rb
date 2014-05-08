require './binary_search_tree'
require 'set'

# Think it like a skip list.

class TreapNode < Node
  # :pri => priority
  attr_accessor :l, :r, :p, :key, :pri
  alias :left_node :l
  alias :right_node :r
  
  def initialize(key)
    @key = key
  end
end


class Treap
  # we create a set to avoid collison of priority value.
  attr_reader :root, :pri_set, :rand_size

  def initialize(key)
    @root = TreapNode.new key
    @root.pri = get_uniq_random
  end
    
  def insert(key)
    node = TreapNode.new key
    node.pri = get_uniq_random
    pre = comparison key
    if pre
      pre.key < key ? pre.r = node : pre.l = node
      node.p = pre
      # need assign random priority value
      bubble_up(node)
    else
      @root = node
    end
  end

  def delete(key)
    result = search key
    if result
      # do trickle down, made deleted node to the leaf.
      # then remove it.
      if result == root 
        @root = nil
      else
        trickle_down result
      end
    end
  end

  def search(key)
    result = comparison key
    if result && result.key == key 
      result
    else
      nil
    end
  end

  def get_min_pri
    @root.pri
  end

  def get_min_value
    @root.key
  end

private

  def output_str(n)
    puts "n #{n.key}, priority: #{n.pri}, parent: #{n.p.key if n.p}, left: #{n.l.key if n.l}, right: #{n.r.key if n.r}"
  end

  # We can't use morris traversal.
  # Becasue in here we want to output left and right subtree. In right sub tree, it may print its successor instead real right node. 
  def print_tree(node = root)
    if node
      print_tree node.l if node.l
      output_str node
      print_tree node.r if node.r
    end
  end

  def get_uniq_random
    @pri_set ||= Set.new
    @rand_size ||= 10
    @rand_size *= 2 if @rand_size < @pri_set.size + @rand_size / 3 
    new_pri = Random.rand(@rand_size).to_i
    if @pri_set.include? new_pri
      new_pri = get_uniq_random
    else
      @pri_set << new_pri
    end
    new_pri
  end

  def trickle_down(node)
    if node.l.nil? && node.r.nil?
      node.p.l == node ? node.p.l = nil : node.p.r = nil
      @pri_set.delete node.pri
    elsif node.l.nil? ^ node.r.nil?
      sub = node.l || node.r
      sub == node.l ? right_rotate(node) : left_rotate(node)
      trickle_down node
    else
      # node.l and node.r both exist
      # no equal case, because each pri value is uniq.
      node.l.pri < node.r.pri ? right_rotate(node) : left_rotate(node)
      trickle_down node
    end
  end 

  def bubble_up(node)
    while node.p && node.p.pri > node.pri
      node.p.r == node ? left_rotate(node.p) : right_rotate(node.p)
    end
  end

  def left_rotate(node)
    r_child = node.r
    node.r = r_child.l
    node.r.p = node if node.r
    r_child.p = node.p
    if node.p
      node.p.l == node ? node.p.l = r_child : node.p.r = r_child
    end
    r_child.l = node
    node.p = r_child
    @root = r_child if node == root
  end

  def right_rotate(node)
    l_child = node.l
    node.l = l_child.r
    node.l.p = node if node.l
    l_child.p = node.p
    if node.p
      node.p.l == node ? node.p.l = l_child : node.p.r = l_child
    end
    l_child.r = node
    node.p = l_child
    @root = l_child if node == root
  end

  def comparison(key)
    current = root
    while current
      pre = current
      if current.key < key
        current = current.r
      elsif current.key > key
        current = current.l
      else
        break
      end
    end
    pre
  end
end