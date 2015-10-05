# nlogn
# n^2

# partition by pivot
# Find location which all left of poviot is smaller than it.
#   => means all right are larger than pivot.

ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]

def partition(ary, l , r, pivot = (l + r)/2)
  ary[r], ary[pivot] = ary[pivot], ary[r]
  store_index = l

  (l...r).each do |i|
    if ary[i] <= ary[r]
      ary[store_index], ary[i] = ary[i], ary[store_index]
      store_index += 1
    end
  end
  ary[r], ary[store_index] = ary[store_index], ary[r]
  store_index
end

def quick_sort(ary, l, r)
  if l < r
    pivot = partition(ary, l, r)
    quick_sort(ary, l, pivot - 1)
    quick_sort(ary, pivot + 1, r)
  end
end

quick_sort ary, 0, ary.size - 1

p ary