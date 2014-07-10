# bubble sort with back and forth

ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]

swapped= true
start = 0
last = ary.size - 2

while swapped
  swapped = false
  #start += 1
  (start..last).each do |i|
    if ary[i + 1] < ary[i]
      swapped = true
      ary[i + 1], ary[i] = ary[i], ary[i + 1]
    end
  end
  unless swapped
    break
  end
  swapped = false
  last -= 1
  last.downto(start).each do |i|
    if ary[i + 1] < ary[i]
      swapped = true
      ary[i + 1], ary[i] = ary[i], ary[i + 1]
    end  
  end
  start += 1
end

p ary