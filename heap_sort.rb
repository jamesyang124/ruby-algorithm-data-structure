
ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp = [170, 45, 75, 90, 802, 2, 24, 66]

heap = []

# i's left child  = i*2+1
# i's right child = i*2+2 
# p = (i-1)/2
# last parent node = (n / 2) - 1
# swap by way of insertion sort.

# upheap condition: k is index, 
  # (k-1/2) >= 0 and ary[(k-1)/2] < ary[initial_k]
  # finally swap ary[initial_k]'s value to last k

# downheap condintion: k start from 0, n is size
  # k <= (n/2) - 1, min(ary[2*k+1], ary[2*k+2]) swap with ary[k]
  # k = 2*k + 1
  # last k swap with ary[init_k], init_k is 0.

# build max_heap, swap max to last than down heap again to find largest to root.

def up_heap(ary, k)
  p = (k - 1)/2
  down = ary[k]
  while (k-1)/2 >= 0 and ary[(k-1)/2] < down
    ary[k] = ary[(k-1)/2]
    k = (k-1).abs/2
    break if k == 0 
  end
  ary[k] = down
end

def down_heap(ary, k, n)
  j = k
  up = ary[k]
  while k <= (n/2 - 1)
    j = 2*k + 1
    if j + 1 < n && ary[j] < ary[j+1]
      j += 1
    end
    break if up >= ary[j]
    ary[k] = ary[j] 
    k = j
  end
  ary[k] = up
end

def adjust_to_heap(ary)
  k = (ary.size - 1) / 2 
  k.down_to(0) do |i|
    down_heap(ary, k, ary.size)
  end
end

# insert
def construct_by_up_heap(ary)
  n = ary.size
  (1..(n-1)).each do |i|
    up_heap(ary, i)
  end
end

# check from last parent node
def construct_by_down_heap(ary)
  n = ary.size
  k = n/2 - 1
  k.downto(0).each do |k|
    down_heap(ary, k, n)
  end
end

def heap_sort(ary)
  #construct_by_up_heap ary
  construct_by_down_heap(ary)
  p ary
  n = ary.size
  while n > 1
    ary[0], ary[n-1] = ary[n-1], ary[0]
    n -= 1
    down_heap(ary, 0, n)
  end
  p ary
end

heap_sort(ary)
heap_sort(bkp)