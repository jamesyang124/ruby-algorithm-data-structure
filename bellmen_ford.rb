
# v0 - v6
#adjacent_matrix = \
#[ 
#  [0, 1, 4, 5, nil, nil, nil], 
#  [1, 0, nil, 2, nil, nil, nil], 
#  [4, nil, 0, 4, nil, 3, nil], 
#  [5, 2, 4, 0, 5, 2, nil], 
#  [nil, nil, nil, 5, 0, nil, 6],
#  [nil, nil, 3, 2, nil, 0, 4], 
#  [nil, nil, nil, nil, 6, 4, 0]
#]

adjacent_matrix = \
[
  [0, nil, 6, 3, nil],
  [3, 0, nil, nil, nil],
  [nil, nil, 0, 2, nil],
  [nil, 1, 1, 0, nil],
  [nil, 4, nil, 2, 0]
]

distance = []
prior = []
source = []

max_weight = 0
V = adjacent_matrix.size
 
adjacent_matrix.each do |a|
  none_nil = a.reject do |a|
    a == nil
  end
  none_nil = none_nil.sort! { |x, y| -(x <=> y) }.first
  max_weight = (max_weight < none_nil ? none_nil : max_weight)  
end

# Represent infinity from theory.
max_weight += 1

V.times do |add|
  source << false
  distance << max_weight 
  prior << nil
end

# initialization
# assume source start at v0
#source[0] = true
#distance[0] = 0

# v5
source[4] = true
distance[4] = 0

# Big (o) = |V| * |E|
# Unlike Dijkstra's shortest path problem, it check the every edges each iteration.
# each iteration ensures that at least one distance will be detemined. SO we need V-1 times iteration.
# if edges(u,v); distance[v] > distance[u] + weight, then update distance[v], set prior[v] = u

# 6 3 3 2 0
# 1 3 3 4 nil

V.times do                                                    # => |V| 
  adjacent_matrix.each.with_index do |sets, u|  # => total |E| times, |E| <= |V^2|  
    # why |E|? edges can be bidirected so |E| may greater than |V| but must smaller or equal to |V^2|
    sets.each.with_index do |weight, v|  # => edge(u, v)
      if weight != nil and weight + distance[u] < distance[v]
          distance[v] = distance[u] + weight
          prior[v] = u
      end
    end
  end
end

# check negative cycle. if edges(u,v) => distance[v] > distance[u] + w => then negative cycle
# If occurs negative cycle then its a NP-complete case, output unsolvable.  
adjacent_matrix.each.with_index do |set, u|                   # => |E|
  set.each.with_index do |weight, v|
    if weight != nil and weight + distance[u] < distance[v]
      puts "This graph include negative cycle for Shortest pathh problem."
      puts "It cause NP-complete case. So cannot find correct answer."
      return      
    end
  end
end

puts sprintf "%-20s %s", "distance:", "#{distance}"
puts sprintf "%-20s %s", "prior:", "#{prior}"