# tail-recursion add, multiple, parenthesis calculator

input = ARGV[0]

stack = []

input.each_char { |chr| stack << chr }

def op(total, current, instructs)
  s = instructs.pop
  #puts "current: #{current}, total: #{total}, instructs #{instructs}"
  case s
  when '+'
    pop = instructs.pop
    if pop != ')'
      op(total + current, pop.to_i, instructs)
    else
      op(total + current, op(0, 0,instructs), instructs)
    end
  when '-'
    pop = instructs.pop
    if pop != ')'
      op(total - current, pop.to_i, instructs)
    else
      op(total - current, op(0, 0,instructs), instructs)
    end
  when 'x'
    pop = instructs.pop
    if pop != ')'
      op(total, current * pop.to_i, instructs) 
    else
      op(total, current * op(0, 0, instructs), instructs) 
    end
  when nil
    return total += current
  when ')'
    op(total, op(0, 0, instructs), instructs)   
  when '('
    return total += current
  else
    op(total, s.to_i, instructs)
  end
end

p op(0, 0, stack)

#def ak(stack, s)
#  require "pry"; binding.pry
#  ak( ak(s.pop, s), s) # => inner first, then call outside.
#  require "pry"; binding.pry
#end

#ak(0, stack)