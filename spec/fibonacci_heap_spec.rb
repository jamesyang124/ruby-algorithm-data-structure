require 'spec_helper'
require_relative "../fibonacci_heap"

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

  it "test private method #search_key" do
    c = FibonacciHeap.new 0
    c.insert! 19
    c.insert! 1
    c.insert! 2 
    c.insert! 4
    c.insert! 16
    c.insert! 3    
    c.insert! 8
    c.insert! 7
    
    expect(c.send(:search_key, 19).key).to equal 19
    expect(c.send(:search_key, 1).key).to equal 1 
    expect(c.send(:search_key, 2).key).to equal 2 
    expect(c.send(:search_key, 3).key).to equal 3 
    expect(c.send(:search_key, 4).key).to equal 4
    expect(c.send(:search_key, 7).key).to equal 7 
    expect(c.send(:search_key, 8).key).to equal 8
    expect(c.send(:search_key, 16).key).to equal 16      
    expect(c.send(:search_key, 119)).to be_nil 
  end

  it "test private method #get_new_smaller_key: new smallest key" do
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
          expect(c.send(:get_new_smaller_key, 1)).to be < 1
          expect(c.send(:get_new_smaller_key, 0)).to be < 0
          expect(c.send(:get_new_smaller_key, 16)).to be < 16
        end
      end
    end

    elapsed_time = Benchmark.realtime do 
      10000.times do 
          expect(c.send(:get_new_smaller_key, 1)).to be < 1
          expect(c.send(:get_new_smaller_key, 0)).to be < 0
          expect(c.send(:get_new_smaller_key, 16)).to be < 16
      end
    end
    puts "", "Third time benchmark elapsed time: #{elapsed_time}"
  end

  it "#decrease_key" do
    c = FibonacciHeap.new 7
    c.insert! 23
    c.insert! 17
    c.insert! 30
    c.insert! 5
    c.extract_min
    c.insert! 24
    c.insert! 46
    c.insert! 26
    c.insert! 35
    c.insert! 1
    c.extract_min
    c.instance_eval do 
      search_key(26).mark = true
    end

    #puts "", "ORIGINAL HEAP:", ""
    #c.print_heap 
    #puts "", "DECREASE KEY 46 TO 15:", <<-HERE 
    #
    #HERE
    c.decrease_key(46, 15)
    expect(c.send(:search_key, 24).mark).to be_true
    #c.print_heap

    #puts "", "DECREASE KEY 35 TO 5:", <<-HERE 
    #
    #HERE
    c.decrease_key(35, 5)
    expect(c.send(:search_key, 24).mark).to be_false
    expect(c.send(:search_key, 26).mark).to be_false
    #c.print_heap
  end

  it "#delete_key" do
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

    c.delete_key 16
    expect(c.send(:search_key, 3).mark).to be_true
    
    c.delete_key 4
    expect(c.send(:search_key, 2).mark).to be_true
    
    c.delete_key 8
    expect(c.send(:search_key, 7).mark).to be_true
    
    c.delete_key 7
    expect(c.send(:search_key, 3).mark).to be_false
    expect(c.send(:search_key, 2).mark).to be_true
    expect(c.send(:search_key, 7)).to be_nil
    
    c.delete_key 1
    expect(c.send(:search_key, 2).mark).to be_true
    
    c.delete_key 2
    expect(c.send(:search_key, 2)).to be_nil
    expect(c.root_head.key).to equal 3
    
    c.delete_key 3
    expect(c.root_head.key).to equal 19
    
    c.delete_key 19
    expect(c.root_head).to be_nil
  end
end