require "spec_helper"
require_relative "../avl_tree"


describe "AvlTree" do
  it "private #visit" do
    a = AvlTree.new 8
    a.instance_eval do 
      visit a.root
    end
    expect(a.traverse_list).to include(a.root)
  end

  it "#print_traversal_list" do
    a = AvlTree.new 8
    a.send(:visit, a.root)
    expect(a.send(:print_traversal_list)).to include(a.root.key)
  end

  it "#morris_traversal" do
    
  end
end