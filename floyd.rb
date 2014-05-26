# shortest path for finding each vertex to other vertices' shortest path in directed/undirected path.

# Big(O) = |V^3|

$path_matrix = []

7.times { |_| $path_matrix << [] }

$path_matrix.each_index do |i|
  7.times { |d| $path_matrix[i] << d } 
end
# [ [0, 1, 2, 3, .. 6]*7 ]


# create a driected matrix ?
# if u direct to v weight as 5 -> a[u][v] = 5 , a[v][u] = -5
# Floyd-Warshell algorithm can cmopute the negative cycle with directed graph.
# if negative cycle exists, there is no way to find the correct routes from source to dest.


$max_weight = 0
 
#adjacent.each do |a|
#  none_nil = a.reject do |a|
#    a == nil
#  end
#  none_nil = none_nil.sort! { |x, y| -(x <=> y) }.first
#  max_weight = (max_weight < none_nil ? none_nil : max_weight)  
#end
#
## set infinity(nil) value to max_weight + 1
#adjacent.each.with_index do |v, a|
#  v.each.with_index do |v, i|
#    adjacent[a][i] = max_weight + 1 unless adjacent[a][i]
#  end
#end

def update_values(adjacent, path, i, j, k)
  adjacent[j][k] = adjacent[j][i] + adjacent[i][k]
  #require "pry"; binding.pry 
  path[j][k] = path[j][i]
end

def update_matrixs(adjacent, path, i, j, k)
  if adjacent[j][i] and adjacent[i][k]
    update_values(adjacent, path, i, j, k) if adjacent[j][k] > adjacent[j][i] + adjacent[i][k]
  end
end

def main adjacent, v
  v.times do |i|  # => |V|
    adjacent.each_index do |j|  # => |V|
      adjacent.each_index do |k|  # => |V|
        if adjacent[j][k]  
          update_matrixs(adjacent, $path_matrix, i, j, k) 
        else
          update_values(adjacent, $path_matrix, i, j, k) if adjacent[j][i] and adjacent[i][k]
        end
      end
    end
  end
end

#Compute whether there has a existence of negative cycle.

def routes(path_matrix, u, v)
  if path_matrix[u][v] != v
    printf "%s ", "vertex #{path_matrix[u][v]} ->"
    routes(path_matrix, path_matrix[u][v], v)
  else
    puts sprintf "%s", "vertex #{path_matrix[u][v]}."
  end
end


