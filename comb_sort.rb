# bubble sort with gap 1

ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp = [170, 45, 75, 90, 802, 2, 24, 66]

# Big O n^2
# Best big O n

SHRINK_FACTOR = 1.3
def comb_sort(ary)
  gap = ary.size
  swapped = false

  while gap != 1 or !swapped
    gap = (gap/SHRINK_FACTOR).to_i
    gap = 1 if gap < 1

    i = 0
    swapped = false
    while i + gap < ary.size
      if ary[i] > ary[i + gap]
        ary[i], ary[i + gap] = ary[i + gap], ary[i]
        swapped = true
      end
      i += 1
    end
  end
end

comb_sort(ary)
p ary
comb_sort(bkp)
p bkp


