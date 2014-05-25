# fibonacci search
# a[m] => m = l + F[k-1] - 1
# f[k] = f[k-1] + f[k-2] => f[k] -1 = (f[k-1]-1) + (f[k-2]-1) + 1 
# f[k] -1 = (f[k-1]-1) + f[k-2] , iteration each time reduce k => k-1 or k-2 range.
# f[k-1] - 1 < n <= f[k] - 1

($fib_ary ||= []) << 0 << 1

def get_fib_number(n, first, second, counts)
  final = first + second
  counts += 1
  $fib_ary << final
  if n > final - 1
    get_fib_number(n, second, final, counts) 
  else
   return final, counts
  end
end

def main(ary, input, index_ary)
  y, l, r, m = *index_ary
  while (l <= r)
    m = l + $fib_ary[y-1] - 1   # reduce multiple or qutient time from binary or interpolation search
    if input == ary[m]
      break
    elsif input < ary[m] 
      r = m - 1
      y -= 1    # cause fib series will converge to 1, so reduce it to converge to 1
    else
      l = m + 1
      y -= 2
    end
  end
  m  
end