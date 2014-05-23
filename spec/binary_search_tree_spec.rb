require 'spec_helper'
require_relative '../binary_search_tree'

describe "Binary search tree" do
  it "test result" do
    #BinaryTree.create_tree(7)
    #BinaryTree.insert(8, 9, 2, 1, 5, 3, 6, 4)

    BinaryTree.create_tree(10)
    BinaryTree.insert(20, 39, 42, 45, 8, 9, 100, 300, 200)
    puts ""
    BinaryTree.inorder(BinaryTree.root)
    
    BinaryTree.delete(10)
    BinaryTree.delete(39)
    BinaryTree.delete(45)
    BinaryTree.delete(42)
    BinaryTree.delete(20)
    BinaryTree.delete(200)
    BinaryTree.delete(300)
    BinaryTree.delete(8)
    BinaryTree.delete(9)
    BinaryTree.delete(100)
    BinaryTree.morris_inorder_traversal nil

  end
end