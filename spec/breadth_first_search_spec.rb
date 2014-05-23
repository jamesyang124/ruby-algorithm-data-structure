require 'spec_helper'
require_relative '../breadth_first_search'

describe "Breadth first search" do
  let(:source) do  
    source = [ [1, 2, 3], [0], [0, 6, 7], [0, 4, 5], [3], [3, 6, 8], [2, 5, 7], [2, 6], [5] ]
  end 

  it "test result" do
    BFS.new(source).bread_first_search(0)
  end
end