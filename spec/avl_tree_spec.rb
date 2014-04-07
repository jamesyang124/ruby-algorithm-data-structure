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
    puts ""
    expect(a.send(:print_traversal_list)).to include(a.root.key)
  end

  it "#morris_traversal" do
    a = AvlTree.new 8
    a.avl_insert 1
    a.avl_insert 5
    a.avl_insert 9
    a.avl_insert 10
    a.avl_insert 511
    a.avl_insert 11
    a.avl_insert 12
    a.avl_insert 8.5
    puts ""
    a.morris_traversal
    expect(a.root.key).to equal 9
  end

  it "#avl_search" do
    a = AvlTree.new 8
    a.avl_insert 1
    a.avl_insert 5
    a.avl_insert 9
    a.avl_insert 10
    a.avl_insert 511
    a.avl_insert 11
    a.avl_insert 12
    a.avl_insert 8.5
    puts ""
    result = a.search_key 8
    expect(result.key).to equal 8
    puts ""
    result = a.search_key 100
    expect(result).to be_nil
  end

  it "#avl_delete" do
    a = AvlTree.new 8
    a.avl_insert 1
    a.avl_insert 5
    a.avl_insert 9
    a.avl_insert 10
    a.avl_insert 511
    a.avl_insert 11
    a.avl_insert 12
    a.avl_insert 8.5
    puts ""
    a.avl_delete 8
    a.avl_delete 1
    a.avl_delete 5
    a.avl_delete 9
    a.avl_delete 10
    a.avl_delete 511
    a.avl_delete 11
    a.avl_delete 12
    a.avl_delete 8.5
    a.morris_traversal
  end
end