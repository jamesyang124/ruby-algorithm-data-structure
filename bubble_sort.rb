# N^2
# compare two consecutive items and buble up.
# use swapped to optimize, if no swap happen then it sorted.
# best N
ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]

swapped = true
n = ary.size - 1

while swapped
  swapped = false
  (0...n).each do |j|
    if ary[j] > ary[j + 1]
      ary[j], ary[j + 1] = ary[j + 1], ary[j]
      swapped = true
    end
  end
  n -= 1
end

p ary