# N^2
# Treat j as empty space.
# each time ary[j-1] > ary[j], then swap it so shift space to left, ary[j-1] to right. until ary[j-1] < v. Now ary[i]'s new index determined. swap then done.
ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]

(1...ary.size).each do |i|
  j = i
  v = ary[i]
  while j > 0 and ary[j-1] > v 
    ary[j], ary[j-1] = ary[j-1], ary[j]
    j -= 1
  end
  ary[j] = v
end

p ary