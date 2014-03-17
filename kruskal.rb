# Minimum Spanning Tree

# |V| is 5, |E| is 7
# [edges][4] struct  

V = 5
E = 7
@tree = []
@vertex_set = []
@selected_list = []

V.times do |t| 
  @vertex_set << t
end

Source = Struct.new("Source", :Vx, :Vy, :cost, :selected) do 
  def initialize(x, y, c, s)
    self.Vx = x
    self.Vy = y
    self.cost = c
    self.selected = s
  end
end

edges ||= [] << Source.new(0, 1, 5, 0) << Source.new(0, 4, 3, 0) \
             << Source.new(1, 2, 1, 0) << Source.new(1, 3, 4, 0) \
             << Source.new(2, 3, 5, 0) << Source.new(2, 4, 2, 0) \
             << Source.new(3, 4, 8, 0)

edges.sort! do |x, y|
  x.cost <=> y.cost
end

def select_edge(edges)
  edges.first
end

def find_root(index)
  while @vertex_set[index] != index
    index = @vertex_set[index]
  end 
  index
end

def cycle(edge)
  true if find_root(edge.Vx) == find_root(edge.Vy)
end

def add_edge(edge)
  edge.selected = 1
  x = find_root(edge.Vx)
  y = find_root(edge.Vy)
  @vertex_set[x] = y  # set in same set of Vy dest
end

while (i ||= 0) < V-1         
  min_edge = select_edge(edges)
  if !cycle(min_edge)
    @tree.push min_edge       
    add_edge(min_edge)
    i += 1
  else
    min_edge.selected = 2
  end
  @selected_list.push(min_edge)
  edges.delete(min_edge)  # log(|E|) time by priority queue
end

puts "Spanning tree, by spanning order:"
puts @tree

puts "All selected edges:"
puts @selected_list

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

puts 'Below implement by disjoint data structure for cycle detection.'

@disjoint_sets = []
@set_trees = []

set_edges ||= [] << Source.new(0, 1, 5, 0) << Source.new(1, 2, 4, 0) \
                 << Source.new(2, 3, 2, 0) << Source.new(0, 3, 6, 0) \
                 << Source.new(0, 4, 5, 0) << Source.new(3, 4, 7, 0) \
                 << Source.new(3, 5, 3, 0) << Source.new(2, 5, 3, 0) \
                 << Source.new(4, 5, 4, 0)
     
def find_set(vertex)
  @disjoint_sets.each do |e| 
    return e if e.include?(vertex)
  end
  Set.new
end

def union_set(edge) 
  x = find_set(edge.Vx)
  y = find_set(edge.Vy)
  if x.empty? and y.empty? 
    new_set = Set.new.add(edge.Vx).add(edge.Vy) 
    @disjoint_sets << new_set
  else
    @disjoint_sets.delete y unless y.empty?
    @disjoint_sets.delete x unless x.empty?
    @disjoint_sets<< x.merge(y)
  end
end

def cycle_set(edge)
  (!find_set(edge.Vx).empty?) and (find_set(edge.Vx) == find_set(edge.Vy))
end

set_edges.sort! do |x, y|
  x.cost <=> y.cost
end

def set_select_edges(edges)
  edges.first
end

VS = 6

while (t ||= 0) < VS-1   
  min_edge = set_select_edges(set_edges)
  if !cycle_set(min_edge)
    min_edge.selected = 1
    @set_trees.push(min_edge)
    union_set(min_edge)
    t += 1
    puts min_edge
  else
    min_edge.selected = 2
  end
  set_edges.delete(min_edge)
end