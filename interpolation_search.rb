ary = [1, 5, 6, 13, 28, 32, 45, 65, 67, 78, 123, 125, 168]

l, r = 0, ary.size-1
proportion = 0
m = 0
key = ARGV[0].to_i

# need l == r case happen for convergence.
# get a proportion than multiple back.
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

puts m