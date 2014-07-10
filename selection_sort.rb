# find max, swap to last, or find min swap to first.
# reduce iteration size to ary.size - 1
# N^2

ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]

(0...ary.size).each do |j|
  min_id = j
  (j...ary.size).each do |i|
    min_id = i if ary[min_id] > ary[i]
  end
  ary[j], ary[min_id] = ary[min_id], ary[j]
end

p ary