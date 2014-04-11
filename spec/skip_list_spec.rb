require 'spec_helper'
require_relative '../skip_list'

describe "SkipList" do
  it "create new skipt list" do
    a = SkipList.new 8
    #a.print_list
  end

  it "insert new element" do
    a = SkipList.new 8
    a.insert 1
    a.insert 9
    a.insert 12
    a.insert 100
    a.insert 3
    puts ""
    #a.print_list
  end

  it "search an element" do
    a = SkipList.new 8
    a.insert 1
    a.insert 9
    a.insert 12
    a.insert 100
    a.insert 3
    puts ""
    a.print_list
    puts ""
    a.search 8
    a.search 100
    a.search 9
    a.search 12
    a.search 1
    a.search 111
  end

  it "search an element" do
    a = SkipList.new 8
    a.insert 1
    a.insert 9
    a.insert 12
    a.insert 100
    a.insert 3
    puts "BEFORE DELETION"
    a.print_list
    puts "AFTER DELETION"
    a.delete 3
    a.print_list
  end
end