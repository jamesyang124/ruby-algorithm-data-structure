require 'spec_helper'
require_relative "../treap"

describe "Treap" do
  let(:tree) do 
    a = Treap.new 45
    a.insert 6
    a.insert 19
    a.insert 1
    a.insert 0
    a.insert 7
    a.insert 8
    a.insert 69
    a.insert 10
    a
  end

  def delete_helper(key)
    puts "DELETE #{key}"
    tree.delete key
    expect(tree.search(key)).to be_nil
    tree.send :print_tree
  end

  def insert_helper(key)
    puts "INSERT #{key}"
    tree.insert key
    expect(tree.search(key).key).to equal(key)
    tree.send :print_tree
  end

  it "create a new Treap" do
    a = Treap.new 5
    expect(a.root.key).to equal 5
    expect(a.get_min_value).to equal 5
  end

  it "insert a new element" do
    a = Treap.new 45
    a.insert 6
    a.insert 19
    a.insert 1
    a.insert 0
    a.insert 7
    a.insert 8
    a.insert 69
    a.insert 10
    expect(a.root.pri).to equal(a.get_min_pri)
  end

  it "search an existing element" do
    a = Treap.new 45
    a.insert 6
    a.insert 19
    a.insert 1
    a.insert 0
    a.insert 7
    a.insert 8
    a.insert 69
    a.insert 10

    expect(a.search(6).key).to equal 6
  end

  it "delete an element" do
    puts "\nTree:"
    tree.send :print_tree

    delete_helper 10
    delete_helper 69
    delete_helper 8
    delete_helper 1
    delete_helper 0
    delete_helper 7
    delete_helper 6
    delete_helper 19
    delete_helper 45

    insert_helper 1
  end
end