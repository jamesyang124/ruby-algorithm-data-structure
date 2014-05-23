# graph by adjacent list
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

