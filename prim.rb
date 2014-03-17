# Minimum Spanning Tree
# MST
# Also the same: O(|V|+|E|)log(V) => binary heap and adjacent list
#                O(|V^2|) => adjacent matrix

@tree = []
V = 6

@v_collection = []
@e_collection = []

Source = Struct.new("Source", :Vx, :Vy, :cost) do 
  def initialize(x, y, c, s)
    self.Vx = x
    self.Vy = y
    self.cost = c
  end
end

set_edges ||= [] << Source.new(0, 1, 5, 0) << Source.new(1, 2, 5, 0) \
                 << Source.new(2, 3, 2, 0) << Source.new(0, 3, 6, 0) \
                 << Source.new(0, 4, 8, 0) << Source.new(3, 4, 7, 0) \
                 << Source.new(3, 5, 3, 0) << Source.new(2, 5, 4, 0) \
                 << Source.new(4, 5, 9, 0)

set_edges.sort! do |x, y|
  x.cost <=> y.cost
end

def set_select_edges(edges, u)
  min_edges = []
  edges.each do |e| 
    if u.include?(e.Vx) and !u.include?(e.Vy)
      return min_edges << e
    end
  end
end

@v_collection << 0
while @v_collection.size < V
  a = set_select_edges(set_edges, @v_collection)
  @v_collection << a.first.Vy
  @e_collection << a.first
  set_edges.delete(a.first)
end

puts @v_collection
puts @e_collection
puts "Unselected edges:"
puts set_edges