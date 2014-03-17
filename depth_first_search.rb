# graph by adjacent list
#           0      1    2          3       4    5          6          7       8
source = [ [1, 2], [0], [0, 6, 7], [4, 5], [3], [3, 6, 8], [2, 5, 7], [2, 6], [5] ]

source_2= [ [1, 2, 3], [0], [0, 6, 7], [0, 4, 5], [3], [3, 6, 8], [2, 5, 7], [2, 6], [5] ]

# put start vertex into Stack first.
# pop last-in then set it visited and find unvisited adjacent vertices, then put unvisited adjacent vertices to stack.
# time complexity:  O(|V|+|E|)
# space complexity: O(|V|)

class DFS
  attr_accessor :stack

  def initialize(source)
    @source = source
    @stack = []
    @visited = []
    @st_visited = []
    @T = []
  end

  def enstack(e) 
    stack.push(e)
  end

  def destack
    stack.pop
  end

  def insert_visited(e)
    @visited = @visited << e   
  end

  def print
    puts sprintf("%-25s %s", "Stack: #{stack}", "Visited list: #{@visited}")
  end

  def depth_first_search(first)
    puts sprintf("%-25s %s", "Stack: [ bottom - top ]", "Visited list")

    enstack(first)
    print

    while !stack.empty?
      element = destack               # => |V|
      insert_visited(element) unless @visited.include?(element)
      @source.fetch(element).reverse_each do |s| 
        unless @visited.include?(s)   # => |E|  
          enstack(s)
        end
      end
      print
    end
  end

  def depth_spanning_tree(first)
    @st_visited << first unless @st_visited.include?(first)
    
    @source.fetch(first).each do |s| 
      unless @st_visited.include?(s)
        @T.push([first, s])
        depth_spanning_tree(s)
      end
    end
    p @T
  end
end

DFS.new(source).depth_first_search(0)
DFS.new(source_2).instance_eval do 
  x = depth_spanning_tree(0)
  puts "Final spanning tree: #{x}"
end