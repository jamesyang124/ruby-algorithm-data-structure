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
    tree = HuffmanTree.new
    text = "DEAF"
    tree.encode text
  end

  it "decode" do
    tree = HuffmanTree.new
    code = "01100010100"
    tree.decode code
    code = "00010101100000"
    tree.decode code
  end
end