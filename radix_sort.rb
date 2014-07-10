ary = [37, 41, 19, 81, 41, 25, 56, 61, 49]
bkp = [170, 45, 75, 90, 802, 2, 24, 66]

def optimize(ary)
  ary.group_by {|a| yield a }.sort.map! {|a| a[1]}.flatten!
end

def radix_sort(ary)
  x = 10
  hash = optimize(ary) {|a| a % 10}
  div = 10

  while (hash.last/div) > 0
    hash = optimize(hash) {|a| a/div}
    div = div*10
  end
  p hash
end

radix_sort(ary)
radix_sort(bkp)

