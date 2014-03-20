require "spec_helper"

describe "BinomialHeap" do
  let(:x) { BinomialHeap.new 18 }
  before :each do
    @x = x 
    @x.insert 0
    @x.insert 100
    @x.insert 20
    @x.insert 5
  end

  it "insert key 18, 0, 100, 20, 5" do
    expect(@x.get_min.key).to equal 0
    expect(@x.head.key).to equal 5
  end

  it "extract min" do
    expect(@x.min.key).to equal 0
    expect(@x.extract_min).to equal 0
  end
end 