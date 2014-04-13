require "spec_helper"
require_relative "../splay_tree.rb"

describe "SplayTree" do 
  it "create a new splay tree" do
    a = SplayTree.new 8
    expect(a.root.key).to equal 8
  end

  it "insert new elements" do
    a = SplayTree.new 8
    a.insert 1
    a.insert 5
    a.insert 9
    a.insert 10
    a.insert 511
    a.insert 11
    a.insert 12
    a.insert 8.5
    expect(a.root.key).to equal 8.5
  end

  it "search the key" do
    a = SplayTree.new 8
    a.insert 1
    a.insert 5
    a.insert 9
    a.insert 10
    a.insert 511
    a.insert 11
    a.insert 12
    a.insert 8.5
    puts ""
    result = a.search 8.5
    expect(result.key).to equal 8.5
  end

  it "get subtree minimum" do
    a = SplayTree.new 8
    a.insert 1
    a.insert 5
    a.insert 9
    a.insert 10
    a.insert 511
    a.insert 11
    a.insert 12
    a.insert 8.5
    result = a.send(:subtree_minimum, a.root)
    expect(result.key).to equal 1
  end

  it "get subtree maximum" do
    a = SplayTree.new 8
    a.insert 1
    a.insert 5
    a.insert 9
    a.insert 10
    a.insert 511
    a.insert 11
    a.insert 12
    a.insert 8.5
    result = a.send(:subtree_maximum, a.root)
    expect(result.key).to equal 511
  end

  it "delete a key" do
    
  end
end