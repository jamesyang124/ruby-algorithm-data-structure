require 'spec_helper'
require_relative '../interpolation_search'

describe "Interpolation search" do
  it "test result" do
    ary = [1, 5, 6, 13, 28, 32, 45, 65, 67, 78, 123, 125, 168]
    l, r = 0, ary.size-1
    proportion = 0
    m = 0
    
    puts ary.inspect

    key = 6
    m = main(ary, l, r, key)
    puts "search #{key}, in index: #{m}."

    key = 28
    m = main(ary, l, r, key)
    puts "search #{key}, in index: #{m}."

    key = 168
    m = main(ary, l, r, key)
    puts "search #{key}, in index: #{m}."
  end
end