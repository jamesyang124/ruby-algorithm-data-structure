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

  it "search key" do
    c = FibonacciHeap.new 0
    c.insert! 19
    c.insert! 1
    c.insert! 2 
    c.insert! 4
    c.insert! 16
    c.insert! 3    
    c.insert! 8
    c.insert! 7
    
    expect(c.search_key(19).key).to equal 19
    expect(c.search_key(1).key).to equal 1 
    expect(c.search_key(2).key).to equal 2 
    expect(c.search_key(3).key).to equal 3 
    expect(c.search_key(4).key).to equal 4
    expect(c.search_key(7).key).to equal 7 
    expect(c.search_key(8).key).to equal 8
    expect(c.search_key(16).key).to equal 16      
    expect(c.search_key(119)).to be_nil 
  end

  it "generate new smallest key" do
    c = FibonacciHeap.new 0
    c.insert! 19
    c.insert! 1
    c.insert! 2 
    c.insert! 4
    c.insert! 16
    c.insert! 3    
    c.insert! 8
    c.insert! 7
    require 'benchmark'
    puts ''
    elapsed_time = Benchmark.bmbm(40) do |x|
      x.report("generate new key smaller than 1, 0, and 16") do
        10000.times do 
          expect(c.get_new_smaller_key 1).to be < 1
          expect(c.get_new_smaller_key 0).to be < 0
          expect(c.get_new_smaller_key 16).to be < 16
        end
      end
    end

    elapsed_time = Benchmark.realtime do 
      10000.times do 
          expect(c.get_new_smaller_key 1).to be < 1
          expect(c.get_new_smaller_key 0).to be < 0
          expect(c.get_new_smaller_key 16).to be < 16
      end
    end
    puts "Third time benchmark: Elapsed time: #{elapsed_time}"
  end
end