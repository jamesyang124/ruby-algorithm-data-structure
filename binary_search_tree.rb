
# Binary search tree. => left child smaller than parent, right child greater than parent.
# There must be no duplicate nodes.
# Binary tree: 
# formal binary tree: 
#           => every internal node has two children.
#           => count: external nodes = internal nodes + 1
# balanced binary tree => 
# with n nodes, the highest height is n, at least is floor((n-1)/2) + 1
# if a tree, but not limited to binary tree, its node as vertex V, edge as E => V = E + 1 

# complete binary tree: if index are sequenced without any gap(empty slot) between.
#           => if height is k, node count is 2^k - 1, min height is 1.
#           => if a node has children, index i from 0, then
#                 its left child index as 2*i + 1, right child index as 2*i + 2
#           => if index start at 0, n > 0, if a node index i, its parent index is floor((i-1) / 2)
#           => if index start at 0, n > 0, its height K is (log n) + 1

# To-do list
# Build binary search rules.
# add
# insert
# deletion

# Target: Binary search thread tree.
class Node
  attr_accessor :left_node, :right_node, :value, :left_td, :right_td

  def initialize(*values)
    self.value = values[0]
    self.left_node = Node.new(values[1]) if values[1]
    self.right_node = Node.new(values[2]) if values[2]
  end 

  def left_append next_node
    self.left_node = Node.new(next_node) if next_node
    self
  end

  def right_append next_node
    self.right_node = Node.new(next_node) if next_node 
    self
  end

end

module Traverse

  #       A 
  #     /   \
  #    B     C
  #   / \   /
  #  D   E H  
  #     /
  #    F   

  def visit(node)
    puts node.value
  end

  # A > B > D > E > F > C > H
  def preorder(node)
    visit node 
    left = preorder node.left_node if node.left_node 
    right = preorder node.right_node if node.right_node
    p left ? left.value : nil 
    p right ? right.value : nil
    p node.value
    puts '----'
    node
  end

  # D > B > F > E > A > H > C
  def inorder(node)
    inorder node.left_node if node.left_node 
    visit node
    build_inorder_traverse_list node
    inorder node.right_node if node.right_node
  end

  # D > F > E > B > H > C > A
  def postorder(node)
    postorder node.left_node if node.left_node 
    postorder node.right_node if node.right_node 
    visit node
  end
end

module InorderStack
  # inorder traverse stack
  def build_inorder_traverse_list node
    self.traverse_list << node
    if self.traverse_list.size >= 3
      self.traverse_list.each_index do |i|
      case i 
        when 0
          self.traverse_list[i].left_td = root
          self.traverse_list[i].right_td = self.traverse_list[i + 1]
        when self.traverse_list.size - 1
          self.traverse_list[i].left_td = self.traverse_list[i - 1]
          self.traverse_list[i].right_td = root
        else    
          self.traverse_list[i].left_td = self.traverse_list[i - 1]
          self.traverse_list[i].right_td = self.traverse_list[i + 1]
        end
      end
    end
  end

  def print_td
    self.traverse_list.each do |t|
      puts "value: #{t.value}, left_td: #{t.left_td.value}, right_td: #{t.right_td.value}"
    end
  end

  def clean_taverse_list
    self.traverse_list = []
  end
end

class BinaryTree
  extend Traverse, InorderStack

  class << self 
    # create two class methods => def root= , def root
    attr_accessor :root, :traverse_list
  end

  Node.class_eval do 
    alias :l :left_node
    alias :r :right_node
    alias :l= :left_node=
    alias :r= :right_node=
  end 

  def self.search value
    current = self.root
    parent ||= self.root
    while current
      degree ||= 0
      if current.value > value
        parent = current
        current = current.left_node
        degree += 1
      elsif current.value < value
        parent = current
        current = current.right_node
        degree ||= 0 and degree += 1
      else
        puts "Found value: #{value} in #{degree} times, at degree #{degree + 1}"
        return current, parent 
      end
    end
    puts "Not Found value in #{degree} times"
  end

  def self.delete value
    node, parent = search value
    if node != self.root
      if !node.l && !node.r
          parent.l == node ? parent.l = nil : parent.r = nil
      elsif node.l && node.r
        prev, pred = self.get_prev_and_rmost node
        if pred
          # The rightmost node must not have right leaf, or it will not be rightmost node.
          # move pred's left sub tree to predecessor's right
          prev.r = pred.l
          pred.r = node.r
          pred.l = node.l  
          parent.l == node ? parent.l = pred : parent.r = pred
        else
          parent.l == node ? parent.l = prev : parent.r = prev
        end
      else
        tmp = node.l || node.r
        parent.l == node ? parent.l = tmp : parent.r = tmp
      end
    elsif node == self.root
      # refactor this part
      self.root = nil if !node.l && !node.r
      self.root = node.r if !node.l && node.r 
      self.root = node.l if node.l && !node.r
      if node.l && node.r
        prev, pred = self.get_prev_and_rmost node
        if pred
          prev.r = pred.l
          pred.l = node.l 
          pred.r = node.r     
          self.root = pred
        else
          self.root = prev
        end
      end
    else 
      puts 'Nothing for deletion.'
    end
    node = nil
  end

# Binary search tree add, always compare from self.root
  def self.insert *list
    until list.empty?
      node = Node.new(*list.shift)
      current = self.root
      while current
        tmp = current 
        if current.value >= node.value  
          direction = 0
          current = current.left_node
        else
          direction = 1
          current = current.right_node
        end
      end
      direction == 1 ? tmp.right_node = node : tmp.left_node = node
    end
  end

# Morris inorder traverse -> available only for written allowed binary tree
# 1. Initialize current as root 
# 2. While current is not NULL
#   If current does not have left child
#      a) Print current’s data
#      b) Go to the right, i.e., current = current->right
#   Else
#      a) Make current as right child of the rightmost node in current's left subtree
#      b) Go to this left child, i.e., current = current->left
#      c) revert (a) when visit, that current node again(has been append to rightmost node) => r_td.
# no recursive, no stack required
  def self.morris_inorder_traversal(node =nil)
    current = node ? node : self.root
    while current
      if current.left_node 
        pre = current.left_node
        while pre.right_node && pre.right_node != current
          pre = pre.right_node
        end
        # revert else condition
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
  end

  def self.create_tree *args
    self.traverse_list = []
    self.root = Node.new *args
  end

private

  def self.get_prev_and_rmost(node)
    previous = node.l
    r_most_leaf = previous.r
    # because left subtree's right most node will point to node by inorder traversal
    # so we have to find the rightmost node, and its predecessor.
    # then mode rightmost node to node, then joint its subtree to predecessor's sub node.
    while r_most_leaf && r_most_leaf.r
      previous = r_most_leaf
      r_most_leaf = r_most_leaf.r
    end
    return previous, r_most_leaf
  end
end

