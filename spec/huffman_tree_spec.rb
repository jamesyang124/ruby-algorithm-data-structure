require 'spec_helper'
require_relative '../huffman_tree'

describe "HuffmanTree" do
  it "create new huffamn tree" do
    tree = HuffmanTree.new
    puts "root is #{tree.root}"
  end

  it "inorder traversal" do
    tree = HuffmanTree.new
    root = tree.huf_root
    puts "root is #{root}, l: #{root.l}, r: #{root.r}"
    tree.morris_traversal
  end

  it "encode" do
    
  end

  it "decode" do
    
  end
end