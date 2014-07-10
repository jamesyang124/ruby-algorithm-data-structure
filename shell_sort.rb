# find 1, 4, 13 by 3h + 1 number
# each h use insertion sort with h gap
#(3^h - 1) / 2, not greater than (N / 3).ceil seq:  1, 4, 13, 40, 121
# N^2


ary = [37, 41, 19, 81, 41, 25, 56, 61, 49, 1, 8, 4]



h = 1
(h = 3*h + 1) while h <= (ary.size / 3)

while h > 0
  i = h
  while i < ary.size
    j = i
    v = ary[i]
    while j >= h and ary[j - h] > v
      ary[j] = ary[j-h]
      j -= h
    end
    ary[j] = v
    i += 1
  end
  h = h / 3 
end

p ary