x = Proc.new do |x| 
    x
  end

case "hd"
  when x.call("ld") then puts "yes ld"
  else puts 'not case equality hd'
end


# EACH not change elements content, it does not return new array
decided = [1,2,3,4,5,6]

#each only iterate elements, cannot change element directly inside the block.
#can use each_index or map to alter the elements value inside block.
decided.each do |d|
  d = 1
end # => [1,2,3,4,5,6]

decided.each_index do |i| 
  decided[i] = 1
end # => [1,1,1,1,1,1]

decided = decided.map do |v, i|
  v = 1
end # => [1,1,1,1,1,1]

# and, && always do shorcircuiting comparison.



module Z
  def self.q
    p self
  end

  def l
    p self
  end
end

module G
  class << self
    def z     # G.methods
      p self
    end

    def self.a # G.singleton_class.methods
      p self
    end

    include Z
    # G.singleton_class::Z::q
    # l = >
  end

  def g   # wait include to other class
    p self
  end

  def self.x  # G.methods
    p self
  end
end

class F 
  include Z
  # open F class object, but not F class object's singleton class.
  # F::Z.g or F::Z::g
  # F.new.l
end

class T 
  extend Z
  # open T class object's singleton class.
  # T.singleton_methods => :l
  # T::Z.g
end

class Q
end

class << Q # open Q's singleton class, set self as singleton class
  extend Z
  # Q.singleton_class.methods l
  # Q::Z::g
end

class W
  class << self
    def m
      p self
    end
  end
end

class O
  def self.m 
    p self
  end
end

a = 'puts "Binding passing context to that #{b}"'
b = 321

def bin(a, bind)
  b = 456
  eval(a, bind)
end

bin(a, binding)


def closure
  name = '123'
  lambda { |_| puts name }
end

cls = closure
# closure remains the outside context and keep it for each call.

cls.call("qwe")

name = "qa"
cls.call("rty")



require 'pry'; binding.pry