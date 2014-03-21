require "spec_helper"

describe "BinomialHeap" do
  let(:x) { BinomialHeap.new 18 }
  before :each do
    @x = x 
    @x.insert 0
    @x.insert 100
    @x.insert 20
    @x.insert 19
    @x.insert 23
    @x.insert 27
    @x.insert 16
  end

  it "insert key 18, 0, 100, 20, 5" do
    expect(@x.peek_min.key).to equal 0
    expect(@x.head.key).to equal 0
  end

  it "extract min" do
    @x.print_heap
    expect(@x.min.key).to equal 0
    expect(@x.extract_min).to equal 0
  end

  it "decrease key 19" do
    expect((@x.decrease_key 19).key).to be < 19
  end

  it "delete key 23" do
    @x.delete_key 23
    expect(@x.head.key).to equal 18
    @x.polu
  end
end 