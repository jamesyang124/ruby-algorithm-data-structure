def quicksort_iterative(ary)
  stack = []
  stack.push([0, ary.size - 1])

  while !stack.empty?
    l, r = *(stack.pop)
    if l < r
      i = l + 1
      j = r
      while true
        i += 1 while i <= r && ary[i] < ary[l]
        j -= 1 while j >= 0 && ary[j] > ary[l]
        break if i >= j

        ary[i], ary[j] = ary[j], ary[i]
      end
      ary[l], ary[j] = ary[j], ary[l]
      stack.push [l, j - 1]
      stack.push [j + 1, r]
    end
  end
  p ary
end

quicksort_iterative [0, 4, 5, 9, 3, 8, 7, 1]
quicksort_iterative [40, 41, 19, 81, 41, 25, 56, 21, 61, 49]
quicksort_iterative [25, 81, 25, 61, 81]
quicksort_iterative [25, 25, 23, 41]
quicksort_iterative [9, 7, 5, 11, 12, 2, 14, 3, 10, 6]

# another approach

def quicksort_way2(ary, l = 0, h = ary.size - 1)
  if l < h
    pivot_value = ary[h]
    store_idx = l

    (l...h).each do |i|
      if ary[i] <= pivot_value
        ary[store_idx], ary[i] = ary[i], ary[store_idx]
        store_idx += 1
      end
    end

    ary[store_idx], ary[h] = ary[h], ary[store_idx]
    pivot = store_idx

    quicksort_way2(ary, l, pivot - 1)
    quicksort_way2(ary, pivot + 1, h)
  end
end

ary = [0, 4, 5, 9, 3, 8, 7, 1]
quicksort_way2 ary
p ary

ary = [40, 41, 19, 81, 41, 25, 56, 21, 61, 49]
quicksort_way2 ary
p ary

ary = [25, 81, 25, 61, 81]
quicksort_way2 ary
p ary

ary = [25, 25, 23, 41]
quicksort_way2 ary
p ary

ary = [9, 7, 5, 11, 12, 2, 14, 3, 10, 6]
quicksort_way2 ary
p ary