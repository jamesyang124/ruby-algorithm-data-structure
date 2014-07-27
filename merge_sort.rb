ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp = []
ary2 = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp2 = []

def copy(ary, l, m, r, bkp)

  while l <= m
    bkp[l] = ary[l]
    l += 1
  end

  j = m + 1
  while j <= r
    bkp[r + (m+1-j)] = ary[j]
    j += 1
  end
end

def merge(ary, l, r, bkp)
  p bkp
  #require 'pry';binding.pry
  i = l
  k = l
  j = r
  while k <= r
    if (bkp[i] <= bkp[j])
      ary[k] = bkp[i]
      i += 1
    else
      ary[k] = bkp[j]
      j -= 1
    end
    k += 1
  end
end

# top-down merge sort
def merge_sort(ary, l, r, bkp)
  if l < r
    m = (l + r)/2
    merge_sort(ary, l, m, bkp)
    merge_sort(ary, m + 1, r, bkp)
    copy(ary, l, m, r, bkp)
    merge(ary, l, r, bkp)
  end
end

merge_sort(ary, 0, ary.size - 1, bkp)

p ary


puts "Bottom-up version"
def merge(ary, l, r, n, bkp)
  x = l
  y = r
  k = l
  while k < n
    if x < r && (y >= n || ary[x] <= ary[y])
      bkp[k] = ary[x]
      x += 1
    else
      bkp[k] = ary[y]
      y +=1
    end
    k +=1
  end
end

def copy(ary, bkp)
  bkp.each.with_index do |e, i|
    ary[i] = e
  end
end

def bottom_up_merge_sort(ary, bkp)
  w = 1
  n = ary.size
  while w < n
    i = 0
    while i < n
      r = (i + w) < n ? (i + w) : n      # l head
      size = (i + 2*w) < n ? (i + 2*w) : n  # r head
      merge(ary, i, r, size, bkp)
      i = i + 2*w
    end
    copy(ary, bkp)
    w = w*2
  end
  p ary
end

bottom_up_merge_sort(ary2, bkp2)



ary2 = [37, 41, 19, 81, 41, 25, 56, 61, 49]
# merge sort rewrite

def re_copy(ary, bkp)
  bkp.each.with_index { |e, i| ary[i] = e }
end

def re_merge(ary, left, mid, right, bkp)
  l = left
  m = mid
  k = l
  while k < right
    if l < mid && ( m >= right || ary[l] < ary[m])
      bkp[k] = ary[l]
      l += 1
    else
      bkp[k] = ary[m]
      m += 1
    end
    k += 1
  end
end

def re_merge_sort(ary)
  size = ary.size
  width = 1
  bkp = []

  while width < size
    # iteration for each block.
    i = 0
    while i < size
      mid = (i + width) < size ? (i + width) : size
      right = (i + 2 * width) < size ? (i + 2 * width) : size 
      re_merge(ary, i, mid, right, bkp)
      i = i + 2 * width
    end
    re_copy(ary, bkp)
    width = width * 2 
  end
  ary
end

puts "Rewrite"
p re_merge_sort(ary2)