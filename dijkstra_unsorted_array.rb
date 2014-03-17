# build adjacent metrix 
# build DIST 1-dimension array
# build Prior array to track prior node
# build cost array when refresh each node
# Dijkstra only use for positive weight.

# adjacent_matrix, by array, Big-O is |V^2|

adjacent_matrix = \
[ 
  [0, 1, 4, 5, nil, nil, nil], 
  [1, 0, nil, 2, nil, nil, nil], 
  [4, nil, 0, 4, nil, 3, nil], 
  [5, 2, 4, 0, 5, 2, nil], 
  [nil, nil, nil, 5, 0, nil, 6],
  [nil, nil, 3, 2, nil, 0, 4], 
  [nil, nil, nil, nil, 6, 4, 0]
]

distance = []
prior = []
decided = []

adjacent_matrix.size.times { prior << 0 ; decided << 0 }
start_index = 0

# set it start at Vertex 0, index 0 in adjacent_matrix
distance = adjacent_matrix[start_index]
decided[start_index] = 1

def undecided_result(decided)
  decided.each { |d| return true if d == 0}
  false
end

def get_min_index(distance, decided)
  index = -1
  x = 0
  distance.each.with_index do |v, i| 
    if decided[i] == 0 and v and (x > v || x == 0)
      x = v
      index = i
    end 
  end
  index
end

def min(l_value, r_value)
  if l_value.nil?
    return r_value, "r_min"
  end 
  if l_value > r_value 
    return r_value, "r_min"
  else
    return l_value, "l_min"
  end
end

def update_dist(u_index, dist, decided, prior, a_matrix)
  a_matrix[u_index].each.with_index do |v, i|
    if v && decided[i] == 0 
      dist[i], l_or_r = min(dist[i], dist[u_index] + a_matrix[u_index][i])
      #a_matrix[u_index][i] = dist[i]
      prior[i] = u_index if l_or_r == 'r_min'
    end
  end
end

# adjacent_matrix, by array, Big-O is |V^2|

def print_out(distance, prior, decided)
  puts "Next Round: "
  puts sprintf "\t %-10s %s", "Dist:", " #{distance}"
  puts sprintf "\t %-10s %s", "Prior:", " #{prior}"
  puts sprintf "\t %-10s %s", "Decided:", " #{decided}"
end

while undecided_result(decided)    # =>  |V|
  dest_index = get_min_index(distance, decided)
  decided[dest_index] = 1
  update_dist(dest_index, distance, decided, prior, adjacent_matrix) # => |V|
  
  print_out(distance, prior, decided)
end