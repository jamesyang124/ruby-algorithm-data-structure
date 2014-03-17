# graph by adjacent list
#           0         1    2          3          4    5          6          7       8
source = [ [1, 2, 3], [0], [0, 6, 7], [0, 4, 5], [3], [3, 6, 8], [2, 5, 7], [2, 6], [5] ]

# set visited first then push into Queue.
# pop first-in then find unvisited adjacent vertices, then set them to visited and put it to queue
# time complexity:  O(|V|+|E|)
# space complexity: O(|V|)

class BFS
  attr_accessor :queue

  def initialize(source)
    @source = source
    @queue = []
    @visited = []
    @T = []
  end

  def enqueue(e) 
    queue.push(e)
  end

  def dequeue
    queue.shift
  end

  def insert_visited(e)
    @visited = @visited << e   
  end

  def print
    puts sprintf("%-25s %s", "Queue: #{queue}", "Visited list: #{@visited}")
  end

  def bread_first_search(first)
    puts sprintf("%-25s %s", "Queue: [ bottom - top ]", "Visited list")
    enqueue(first)
    insert_visited(first)
    print

    while !queue.empty?
      element = dequeue                   # => |V|
      @source.fetch(element).each do |s|  
        unless @visited.include?(s)       # => |E|
          enqueue(s)
          @T.push([element,s])                
          insert_visited(s) 
        end
      end
      print
    end
    # spanning tree
    p @T
  end
end

BFS.new(source).bread_first_search(0)