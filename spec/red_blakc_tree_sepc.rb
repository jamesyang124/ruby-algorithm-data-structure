require 'spec_helper'
require_relative '../red_black_tree'

describe "Red Black Tree" do
  it "create a new tree" do
    a = RBTree.new 5
    expect(a.root.key).to equal 5
    expect(a.root.l.key).to be_nil
    expect(a.root.r.key).to be_nil  
  end

  it "insert a new element" do
    a = RBTree.new 5
    a.insert 7
    a.insert 8
    a.insert 4
    a.insert 1
    a.insert 0
    a.insert 2
    # node == node.p.r && node.p == grand_parent.l
    a.insert 1.5    
    a.insert 9
    # node == node.p.l && node.p == grand_parent.r
    a.insert 8.5    
    #a.print_tree
    expect(a.root.key).to equal 4
  end

  it "search a element" do
    a= RBTree.new 5
    a.insert 7
    a.insert 8
    a.insert 4
    a.insert 1
    a.insert 0
    a.insert 2
    a.insert 1.5
    k = a.search 5
    expect(k.key).to equal 5
    expect(a.search(1.5).key).to equal 1.5 
  end

  it "delete a sequence of elements" do
    a = RBTree.new 5
    a.insert 7
    a.insert 8
    a.insert 4
    a.insert 1
    a.insert 0
    a.insert 2
    a.insert 1.5    
    a.insert 9
    a.insert 8.5

    #ra.print_tree
    puts "\n DELETE 0"
    # !(node.l && node.l.key) && !(node.r && node.l.key)
    a.delete 0 
    expect(a.search(0)).to be_nil 
    puts " DELETE 1.5"
    a.delete 1.5
    puts " DELETE 4"
    expect(a.search(1.5)).to be_nil 
    a.delete 4
    expect(a.search(4)).to be_nil
    expect(a.root.key).to equal 5
    puts " DELETE 7"
    a.delete 7
    puts " DELETE 9"
    a.delete 9
    puts " DELETE 8.5"
    a.delete 8.5
    puts " DELETE 8"
    a.delete 8
    puts " DELETE 2"
    a.delete 2
    puts " DELETE 1"
    a.delete 1
    puts " DELETE 5\n\n"
    a.delete 5
    a.print_tree 
  end

  it "print the tree" do
    a= RBTree.new 5
    a.insert 7
    a.insert 8
    a.insert 4
    a.insert 1
    puts
    #a.print_tree
  end
end