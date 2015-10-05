
ary = [1,2,3,4,5,6,7,8,9]

def second_largest(ary)
  return nil if ary.empty?
  
  if ary.size > 1
    largest = ary[0] > ary[1] ? ary[0] : ary[1]
    second = largest > ary[0] ? ary[0] : ary[1] 
  
    ary.each { |e| (second, largest = largest, e) if e > largest }
  end
  second
end

p second_largest ary
p second_largest []
p second_largest [1]