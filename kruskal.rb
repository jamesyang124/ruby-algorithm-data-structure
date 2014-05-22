# Minimum Spanning Tree
# http://www.personal.kent.edu/~rmuhamma/Algorithms/MyAlgorithms/GraphAlgor/kruskalAlgor.htm
# for each vertex v in V[G] 
#      do define set S(v) ← {v}
# Initialize priority queue Q that contains all edges of G, using the weights as keys
#
# A ← { }  A will ultimately contains the edges of the MST
# n = number of vertices
# 
# while A has less than n − 1 edges 
#     do Let set S(v) contains v and S(u) contain u
#       if S(v) != S(u)
#         then Add edge (u, v) to A
#            Merge S(v) and S(u) into one set i.e., union
# return A

# each vertices of edge are in the same set will cause cycle. 
# Priority queue stores edges, assume initialization time: |E|*log(|E|)
# Each iteration in while loop, remove a minimum edge. |V|*log(|E|), 
# for indirected complete graph: |E| = V*(V-1)/2, hence |E| <= |V^2| 
# Above imply log|E| <= 2log|V| which deduct to log|E| <= log|V|
# |V|*log(|E|) + |E|*log(|E|) = O(|V| + |E|)*log(|E|) ~ worst case time complexity
require 'set'


Source = Struct.new("Source", :Vx, :Vy, :cost, :selected) do 
  def initialize(x, y, c, s)
    self.Vx = x
    self.Vy = y
    self.cost = c
    self.selected = s
  end
end

puts 'Below implement by disjoint data structure for cycle detection.'

$V = 8
$disjoint_sets = []
$set_trees = []
$selected_list = []

$set_edges ||= [] << Source.new(0, 1, 5, 0) << Source.new(1, 2, 4, 0) \
                 << Source.new(2, 3, 2, 0) << Source.new(0, 3, 6, 0) \
                 << Source.new(0, 4, 5, 0) << Source.new(3, 4, 7, 0) \
                 << Source.new(3, 5, 3, 0) << Source.new(2, 5, 3, 0) \
                 << Source.new(4, 5, 4, 0) << Source.new(8, 9, 3, 0) \
                 << Source.new(0, 9, 3, 0)


$set_edges.sort! do |x, y|
  x.cost <=> y.cost
end
     
def find_set(vertex)
  $disjoint_sets.each do |e| 
    return e if e.include?(vertex)
  end
  Set.new
end

def union_sets(edge) 
  x = find_set(edge.Vx)
  y = find_set(edge.Vy)
  if x.empty? and y.empty? 
    new_set = Set.new.add(edge.Vx).add(edge.Vy) 
    $disjoint_sets << new_set
  else
    $disjoint_sets.delete y unless y.empty?
    $disjoint_sets.delete x unless x.empty?
    if x.empty?
      $disjoint_sets << y.merge([edge.Vx])
    else
      $disjoint_sets << (y.empty? ? x.merge([edge.Vy]) : x.merge(y))  
    end
  end
end

def cycle_test(edge)
  (!find_set(edge.Vx).empty?) and (find_set(edge.Vx) == find_set(edge.Vy))
end

def get_min_edge(edges)
  edges.first
end

def main
  while (t ||= 0) < $V-1   
    min_edge = get_min_edge($set_edges)
    if !cycle_test(min_edge)
      min_edge.selected = 1
      $set_trees.push(min_edge)
      union_sets(min_edge)
      t += 1
      $selected_list.push(min_edge)
    else
      min_edge.selected = 2
    end
    $set_edges.delete(min_edge)
  end

  puts "Spanning tree set:"
  $disjoint_sets.each do |e|
    puts "#{e.inspect}"
  end
  
  puts "All selected edges:"
  puts $selected_list
end