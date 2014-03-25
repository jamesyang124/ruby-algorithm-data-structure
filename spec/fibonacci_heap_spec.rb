require 'spec_helper'

describe "FibonacciHeap" do
  it 'initialize new heap with 16' do 
    c = FibonacciHeap.new 16
    expect(c.min.key).to equal 16
    expect(c.root_head.key).to equal 16
    expect(c.root_tail.key).to equal 16
  end

  it "insert new elements" do
    c = FibonacciHeap.new 16
    c.insert! 19
    c.insert! 1
    c.insert! 2 
    expect(c.min.key).to equal 1
    expect(c.min.right.key).to equal 2
    expect(c.min.left.key).to equal 19
  end

  it "union two heaps to a new heap" do
    d = FibonacciHeap.new 5
    d.insert! 4
    d.insert! 0

    c = FibonacciHeap.new 16
    c.insert! 19
    c.insert! 1
    c.insert! 2 

    c.union(c, d)

    expect(c.min.key).to equal 0
    expect(c.min.right).to be_nil
    expect(c.min.left.key).to equal 4

    expect(c.root_head.key).to equal 16
    expect(c.root_head.left).to be_nil
    expect(c.root_head.right.key).to equal 19
    expect(c.root_tail.key).to equal 0
  end

  it "extract min which does not have children" do
    c = FibonacciHeap.new 0
    c.insert! 19
    c.insert! 1
    c.insert! 2 
    c.insert! 4
    c.insert! 16
    c.insert! 3    
    c.insert! 8
    c.insert! 7
  
    c.extract_min
    expect(c.min.key).to equal 1
  end

  it "extract min which has children" do
    c = FibonacciHeap.new 0
    c.insert! 19
    c.insert! 1
    c.insert! 2 
    c.insert! 4
    c.insert! 16
    c.insert! 3    
    c.insert! 8
    c.insert! 7
  
    expect(c.min.key).to equal 0
    c.extract_min
    expect(c.min.key).to equal 1
    c.extract_min
    expect(c.min.key).to equal 2
    c.extract_min
    expect(c.min.key).to equal 3
    c.extract_min
    expect(c.min.key).to equal 4
    c.extract_min
    expect(c.min.key).to equal 7
    c.extract_min
    expect(c.min.key).to equal 8
    c.extract_min
    expect(c.min.key).to equal 16
    c.extract_min
    expect(c.min.key).to equal 19
    c.extract_min
    
    c.insert! 0
    c.insert! 4
    c.insert! 2 
    c.insert! 1
    c.insert! 16
    c.insert! 3    
    c.insert! 8
    c.insert! 7

    expect(c.min.key).to equal 0
    c.extract_min
    expect(c.min.key).to equal 1
    c.extract_min
    expect(c.min.key).to equal 2
    c.extract_min
    expect(c.min.key).to equal 3
    c.extract_min
    expect(c.min.key).to equal 4
    c.extract_min
    expect(c.min.key).to equal 7
    c.extract_min
    expect(c.min.key).to equal 8
    c.extract_min
    expect(c.min.key).to equal 16
    c.extract_min

  end
end