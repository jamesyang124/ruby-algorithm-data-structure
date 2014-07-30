# http://en.wikipedia.org/wiki/A*_search_algorithm
# http://stackoverflow.com/questions/5849667/a-search-algorithm
# f(n) = g(n) + h(n)
# h(n) = 0 => Dijkstra algorithm
# h(n) < dist from n to goal, ensure it will find result. 
# h(n) > dist from n to goal, it may not find result. But faster
# h(n) smaller, Search space larger.

$adjacent_list = Hash.new
$adjacent_list[:s] = { a: 1, b: 2 }
$adjacent_list[:a] = { x: 4, y: 7 }
$adjacent_list[:b] = { c: 7, d: 1 }
$adjacent_list[:c] = { e: 5 }
$adjacent_list[:d] = { e: 12 }
$adjacent_list[:x] = { e: 2 }
$adjacent_list[:y] = { e: 3 }

$heuristic_cost = { s: 8, a: 5, b: 6, c: 4, d: 15, x: 5, y: 8, e: 0 }

def a_star(start, goal)
  closedset = []
  openset = []

  prev = Hash.new

  g_score = Hash.new
  f_score = Hash.new
  
  g_score[start.to_sym] = 0
  f_score[start.to_sym] = g_score[start.to_sym] + $heuristic_cost[start.to_sym]

  openset << start.to_sym

  until openset.empty?
    current = get_min_f_score_node(f_score, openset)
  
    return reconstruct_path(prev, current) if current == goal.to_sym

    openset.delete current
    closedset.push current

    neighbor_nodes(current).each do |ary|
      neighbor = ary.first
      distance = ary.last

      next if closedset.include? neighbor

      tentative_g_score = g_score[current] + distance

      if !openset.include?(neighbor) || tentative_g_score < g_score[neighbor]
        prev[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = g_score[neighbor] + $heuristic_cost[neighbor]
        
        openset.push(neighbor) if !openset.include?(neighbor)
      end
    end
  end
  return false
end   

def neighbor_nodes(node)
  $adjacent_list[node]
end

def get_min_f_score_node(f_score, openset)
  min_score_node = f_score.sort {|x, y| x.last <=> y.last}.last.last + 1
  node = nil
  openset.each do |e|
    if f_score[e] < min_score_node
      min_score_node = f_score[e]
      node = e 
    end
  end
  node
end

def reconstruct_path(prev, current)
  if prev.include? current
    p = reconstruct_path(prev, prev[current])
    [p] << current
  else
    current
  end
end

res = (a_star "s", "e").flatten!
p res


#function A*(start,goal)
#    closedset := the empty set    // The set of nodes already evaluated.
#    openset := {start}    // The set of tentative nodes to be evaluated, initially containing the start node
#    came_from := the empty map    // The map of navigated nodes.
# 
#    g_score[start] := 0    // Cost from start along best known path.
#    // Estimated total cost from start to goal through y.
#    f_score[start] := g_score[start] + heuristic_cost_estimate(start, goal)
# 
#    while openset is not empty
#        current := the node in openset having the lowest f_score[] value
#        if current = goal
#            return reconstruct_path(came_from, goal)
# 
#        remove current from openset
#        add current to closedset
#        for each neighbor in neighbor_nodes(current)
#            if neighbor in closedset
#                continue
#            tentative_g_score := g_score[current] + dist_between(current,neighbor)
# 
#            if neighbor not in openset or tentative_g_score < g_score[neighbor] 
#                came_from[neighbor] := current
#                g_score[neighbor] := tentative_g_score
#                f_score[neighbor] := g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
#                if neighbor not in openset
#                    add neighbor to openset
# 
#    return failure
# 
#function reconstruct_path(came_from, current_node)
#    if current_node in came_from
#        p := reconstruct_path(came_from, came_from[current_node])
#        return (p + current_node)
#    else
#        return current_node