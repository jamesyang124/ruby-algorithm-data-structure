require 'spec_helper'
require_relative '../fibonacci_search'

describe "Fibonacci Search" do
  let(:ary) do 
    [1, 5, 6, 13, 28, 32, 45, 65, 67, 78, 123, 125, 168]
  end
  it "test result" do
    x, y = get_fib_number(ary.size, 0, 1, 1)
    l, r, m = 0, ary.size-1, 0

    puts "ary: #{ary}"

    loc = main(13, y, l, r, m)
    expect(ary[loc]).to equal 13
    puts ary[loc] == 13 ? "Value 13 at index #{loc}." : "Value cannot found."

    loc = main(32, y, l, r, m)
    expect(ary[loc]).to equal 32
    puts ary[loc] == 32 ? "Value 32 at index #{loc}." : "Value cannot found."
  end
end