

# http://en.wikipedia.org/wiki/Sieve_of_eratosthenes

# why i <= Math.sqrt(n) ?
# assume i is a prime except 2, so i must be an odd tumber => i = 2t + 1
# think about i*(i+1) => i*(2t+1 +1) => (2t+1)*(2t+2) can divide by 2 
# think about i*(i+2) => i*(2t+1 +2) => (2t+1)*(2(t+1)+1) can divide by some prime if (2t + 1)*(2t + 3) < t
# think 5 * 7 => because 5 * 7 < 7 * 7, so it will be examine it later. 
# 2t + 3 , 2t + 5 , 2t + 7 .... all are plus a prime. => prime(odd) + even => even be divided, or still prime.
# (2t + 1)*(2t + 3) -> 3*5, 5*7, 7*9 , 9*11, 11*13 ....
# We assume (A * B <= n, max(odd(A,B) if odd exist in A or B)^2 >= n), A is odd number (2t + 1):
#       => if A nonprime, 
#             then some prime which greater than 2 can divide A. Any A*B will be devided, before we check A.
#       => if A prime, then consider B:
#          => if B prime, B > A, then A*B will at least divide by A when we further check B prime.
#          => if B prime, B < A, then A*B will divide by B before we check A prime.
#          => if B prime, B = A, then A*B = A*A will divide by A when we check A prime.
#          => if B nonprime, then smaller prime < B can divide A*B.
# so it will only need to check i <= Math.sqrt(n)  
# if 49 <= N < 121, 1 2 3 5 7, dont need 11 => 11*2, 11*3, 11*5, 11*7, all divide by previous prime.
# Only 11*11 will absolutely to need 11 to divided it. 

class PrimeList
  attr_accessor :ary
  attr_reader :n

  def initialize(n) 
    (@ary ||= []) << false << false
    (1..n-2).each { |e| @ary << true }
    @n = n
  end

  def prime_number_list
    ary.each_index do |i| 
      if ary[i] and i <= Math.sqrt(n) 
        ary.each_index do |a|  
          ary[a] = false if a.modulo(i) == 0 and a != i
        end
      end
    end
    self
  end

  def print
    x ||= []
    ary.map.with_index do |v, i|
      x << i if v
    end
    puts x  
  end
end

PrimeList.new(30).prime_number_list.print