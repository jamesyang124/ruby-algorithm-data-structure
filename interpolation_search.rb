# need l == r case happen for convergence.
# get a proportion than multiple back.
def main(ary, l, r, key)
  while l <= r
    proportion = ary[r] - ary[l] != 0 ? (key - ary[l])/(ary[r] - ary[l]).to_f : 0
    m = l + (proportion * (r-l)).to_i

    if ary[m] == key
      break
    elsif ary[m] < key
      l = m + 1
    else
      r = m - 1
    end
  end
  m
end
