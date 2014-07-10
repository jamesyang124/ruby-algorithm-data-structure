def swap(ary, i, j)
  ary[j], ary[i] = ary[i], ary[j]
end

def inplace_partition(ary, left, right, pivot = (left + right)/2)
  swap(ary, right, pivot)
  loc = left
  (left...right).each do |i| 
    if ary[i] <= ary[right]
      swap(ary, loc, i)
      loc += 1
    end
  end
  swap(ary, loc, right)
  loc
end

def quicksort(ary, i, j)
  if i < j
    p = inplace_partition(ary, i, j)
    quicksort(ary, i, p - 1)
    quicksort(ary, p + 1, j)
  end
end

def main
  ary = [3, 7, 8, 5, 2, 1, 9, 5, 4]
  quicksort(ary, 0, ary.size - 1)
  puts ary.inspect
end

main