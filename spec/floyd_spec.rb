require 'spec_helper'
require_relative '../floyd'

describe "Floyd STP" do
  it "test result" do

    adjacent = \
    [ 
      [0, 1, 4, 5, nil, nil, nil], 
      [1, 0, nil, 2, nil, nil, nil], 
      [4, nil, 0, 4, nil, 3, nil], 
      [5, 2, 4, 0, 5, 2, nil], 
      [nil, nil, nil, 5, 0, nil, 6],
      [nil, nil, 3, 2, nil, 0, 4], 
      [nil, nil, nil, nil, 6, 4, 0]
    ]
    
    V = adjacent.size

    main adjacent, V
    V.times do |i|
      puts "No correct answer, has negative cycle." if adjacent[i].sort.first < 0
    end

    puts "PATH_MATRIX:"
    $path_matrix.each { |p|  p p }
    puts "ADJACENT_MATRIX:"
    adjacent.each { |a| p a }

    printf "%s \n", "FROM VERTEX 0:"
    printf "%s ", "vertex 0 ->"
    routes($path_matrix, 0, 6)
  end
end