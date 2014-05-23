require 'spec_helper'
require_relative '../depth_first_search'

describe "Depth first search" do
  # index node x to a lst of dest nodes.
  let(:source) do 
    [ [1, 2], [0], [0, 6, 7], [4, 5], [3], [3, 6, 8], [2, 5, 7], [2, 6], [5] ]
  end

  let(:source_2) do 
    [ [1, 2, 3], [0], [0, 6, 7], [0, 4, 5], [3], [3, 6, 8], [2, 5, 7], [2, 6], [5] ]
  end

  it "test result" do
    DFS.new(source).depth_first_search(0)
    DFS.new(source_2).instance_eval do 
      x = depth_spanning_tree(0)
      puts "Final spanning tree: #{x}"
    end
  end
end