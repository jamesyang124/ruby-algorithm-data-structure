require "spec_helper"

describe "BinomialHeap" do
  it "insert key 0" do
    x = BinomialHeap.new 18
    x.insert 0
    x.insert 100
    x.insert 20
    x.insert 5
    x.insert -8
    x.insert -9
    x.insert -10
    #expect(x.head.key).to equal 5
  end

end 