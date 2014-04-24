require "spec_helper"
require_relative '../2_3_b_tree'

def hole_test(tree, key)
  leaf = tree.send(:find_leaf, key)
  leaf.key_l == key ? leaf.key_l = nil : leaf.key_r = nil
  tree.send :handle_hole, leaf
end

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
    #a.insert 10.5
    #a.insert 12.5
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
    a = create_tree
    puts ""
    a.print_list
  end

  it "private #inorder_predecessor" do
    tree = create_tree
    pred = tree.send(:internal_inorder_pred, tree.root, 13)
    expect(pred.key_l).to equal 12
    pred = tree.send(:internal_inorder_pred, pred.p, 11)
    expect(pred.key_l).to equal 10
    pred = tree.send(:internal_inorder_pred, pred.p.p, 9)
    expect(pred.key_l).to equal 8
  end

  it "private #handle_hole" do
    tree = create_tree
    puts "delete 17"
    hole_test tree, 17
    tree.print_list
  end

  it "deletion" do
    tree = create_tree

    # test 2-2-left sib
    puts 'delete 17'
    tree.delete 17
    tree.print_list

    # test 3-2-left sib, 2-2-right sib
    puts "delete 11"
    tree.delete 11
    tree.print_list

    puts "delete 8"
    tree.delete 8
    tree.print_list

    puts 'delete 9'
    tree.delete 9
    tree.print_list

    puts 'delete 7'
    tree.delete 7
    tree.print_list

    puts 'delete 10'
    tree.delete 10
    tree.print_list

    puts 'delete 1'
    tree.delete 1
    tree.print_list

    puts 'delete 12'
    tree.delete 12
    tree.print_list
    
    puts 'delete 15'
    tree.delete 15
    tree.print_list
    
    puts 'delete 19'
    tree.delete 19
    tree.print_list

    puts 'delete 20'
    tree.delete 20
    tree.print_list

    puts 'delete 18'
    tree.delete 18
    tree.print_list

    puts 'delete 16'
    tree.delete 16
    tree.print_list

    puts 'delete 21'
    tree.delete 21
    tree.print_list

    puts 'delete 13'
    tree.delete 13
    tree.print_list
  end

end