# set degree for each vertex. degree += 1 if the vertex get a inbound from other vertex.
# Assume all vertices are to do list. Topo sort try to find sequence to finish these tasks in order. 

# find selected[u] and degree[u] = 0, set u selected, go check adjacent_matrix[u] array.
# If adjacent_matrix[u][v] == 1, set it to zero, degree[v] -= 1

# Big(O) = |V^2|
# 1 means outbound to another vertex.
adjacent_matrix = \
[ 
  [ 0, 1, 1, nil, nil, nil, nil, nil, nil],
  [ -1, 0, nil, 1, nil, nil, nil, nil, nil],
  [ -1, nil, 0, 1, nil, nil, nil, nil, nil], 
  [ nil, -1, -1, 0, 1, nil, nil, 1, nil], 
  [ nil, nil, nil, -1, 0, 1, 1, 1, nil],
  [ nil, nil, nil, nil, -1, 0, nil, nil, 1],  
  [ nil, nil, nil, nil, -1, nil, 0, nil, 1],
  [ nil, nil, nil, -1, -1, nil, nil, 0, 1],
  [ nil, nil, nil, nil, nil, -1, -1, -1, 0]
]

V = adjacent_matrix.size
degree = Array.new(V)
@selected = Array.new(V, 0)

degree[0] = 0



adjacent_matrix.each do |u| 
  u.each.with_index do |v, i|
    (degree[i] = degree[i] ? degree[i] + 1 : 1) if v == 1
  end
end

def pick_next(degree)
  value = 0
  V.times do |i|
    if @selected[i] == 0 and degree[i] == 0
      @selected[i] = 1 
      value = i
      break
    end
  end
  value
end

V.times do # => |V|
  index = pick_next(degree)
  if degree.sort { |x, y| y<=>x }.first != 0
    printf "%s ", "vertex #{index} ->"
  else
    puts sprintf "%s ", "vertex #{index}."
  end
  V.times do |i| # => |V|
    if adjacent_matrix[index][i] == 1
      degree[i] -= 1
      adjacent_matrix[index][i] = 0
    end
  end
end

puts "adjacent_matrix:"
adjacent_matrix.each {|ary| p ary}