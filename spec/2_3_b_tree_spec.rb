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

  def hole_test(tree, key)
    leaf = tree.send(:find_leaf, key)
    leaf.key_l == key ? leaf.key_l = nil : leaf.key_r = nil
    tree.send :handle_hole, leaf
  end

  it "create a new b tree" do
    a = Btree.new 8 
    expect(a.root.key_l).to equal 8
  end

  it "insert new element" do
    a = create_tree
    expect(a.search(21)).not_to be_nil 
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
    hole_test tree, 17
    expect(tree.search(17)).to be_nil
  end

  it "deletion" do
    tree = create_tree

    # test 2-2-left sib
    puts 'delete 17'
    tree.delete 17
    tree.print_list
    expect(tree.search(17)).to be_nil

    # test 3-2-left sib, 2-2-right sib
    puts "delete 11"
    tree.delete 11
    expect(tree.search(11)).to be_nil

    puts "delete 8"
    tree.delete 8
    expect(tree.search(8)).to be_nil

    puts 'delete 9'
    tree.delete 9
    expect(tree.search(9)).to be_nil

    puts 'delete 7'
    tree.delete 7
    expect(tree.search(7)).to be_nil

    puts 'delete 10'
    tree.delete 10
    expect(tree.search(10)).to be_nil
    
    puts 'delete 1'
    tree.delete 1
    expect(tree.search(1)).to be_nil

    puts 'delete 12'
    tree.delete 12
    expect(tree.search(12)).to be_nil
    
    puts 'delete 15'
    tree.delete 15
    expect(tree.search(15)).to be_nil
    
    puts 'delete 19'
    tree.delete 19
    expect(tree.search(19)).to be_nil

    puts 'delete 20'
    tree.delete 20
    expect(tree.search(20)).to be_nil

    puts 'delete 18'
    tree.delete 18
    expect(tree.search(18)).to be_nil

    puts 'delete 16'
    tree.delete 16
    expect(tree.search(16)).to be_nil

    puts 'delete 21'
    tree.delete 21
    expect(tree.search(21)).to be_nil

    puts 'delete 13'
    tree.delete 13
    tree.print_list
  end

end