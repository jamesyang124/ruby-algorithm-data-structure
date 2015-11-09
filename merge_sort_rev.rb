ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp = []
ary2 = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp2 = []


def merge(ary, l, m, r, bkp)
  k = l
  mid = m
  while k < r
    if l < mid && (m >= r || ary[l] < ary[m])
      bkp[k] = ary[l]
      l += 1
    else
      bkp[k] = ary[m]
      m += 1
    end
    k += 1
  end
end

def copy(ary, bkp)
  bkp.each.with_index do |e, i|
    ary[i] = e
  end
end

def merge_sort(ary)
  size = ary.size
  width = 1
  w = width
  bkp = []

  while w < size
    i = 0
    while i < size
      m = i + w < size ? i + w : size
      r = i + 2*w < size ? i + 2*w : size
      merge(ary, i, m, r, bkp)
      i = i + 2*w
    end
    copy(ary, bkp)
    w = w*2
  end

  ary
end

p merge_sort(ary)