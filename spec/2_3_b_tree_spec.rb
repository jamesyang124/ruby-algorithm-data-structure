require "spec_helper"
require_relative '../2_3_b_tree'

describe "Btree" do
  let(:create_tree) do 
    a = Btree.new 8
    a.insert 15
    a.insert 9
    a.insert 1
    a.insert 7
    a.insert 10
    a.insert 13
    a.insert 11
    a.insert 12
    a.insert 10.5
    a.insert 12.5
    a.insert 16
    a.insert 17
    a.insert 18
    a.insert 19
    a.insert 20
    a.insert 21
    a
  end

  it "create a new b tree" do
    a = Btree.new 8 
    expect(a.root.key_l).to equal 8
  end

  it "insert new element" do
    a = Btree.new 8
    a.insert 15
    a.insert 9
    a.insert 1
    a.insert 7
    a.insert 10
    a.insert 13
    a.insert 11
    a.insert 12
    a.insert 10.5
    a.insert 12.5
    a.insert 16
    a.insert 17
    a.insert 18
    a.insert 19
    a.insert 20
    a.insert 21
    puts ""
    a.print_list
  end

  it "private #inorder_predecessor" do
    tree = create_tree
    pred = tree.send(:internal_inorder_pred, tree.root, 13)
    expect(pred.key_r).to equal 12.5
    pred = tree.send(:internal_inorder_pred, pred.p, 11)
    expect(pred.key_r).to equal 10.5
  end
end