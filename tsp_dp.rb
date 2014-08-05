# http://www.scribd.com/doc/50049931/Final-Report-Solving-Traveling-Salesman-Problem-by-Dynamic-Programming-Approach-in-Java-Program-Aditya-Nugroho-Ht083276e
# https://sites.google.com/site/indy256/algo/dynamic_tsp
# http://gebweb.net/blogpost/2011/06/24/the-dynamic-programming-algorithm-for-the-travelling-salesman-problem/
# http://www.seas.gwu.edu/~simhaweb/champalg/tsp/tsp.html
# http://www.geeksforgeeks.org/travelling-salesman-problem-set-1/
# http://stackoverflow.com/questions/19618938/traveling-salesman-with-held-and-karp-algorithm

# or using Mininmum Spanning Tree instead.

$a_matrix = [ [ 0, 1, 10, 1, 10 ], 
              [ 1, 0, 10, 10, 1 ], 
              [ 10, 10, 0, 1, 1 ], 
              [ 1, 10, 1, 0, 10 ],
              [ 10, 1, 1, 10, 0 ]  ]


def max_a_matrix(a_matrix)
  tmp = -1
  a_matrix.each do |i|
    i.each do |j|
      tmp = j if j > tmp
    end
  end
  tmp + 1  
end

def min(a, b)
  a > b ? b : a
end

def tsp_dp(a_matrix)
  size = a_matrix.size
  # right shift 1 to size bits, each bit represent a city. 0 => unvisited, 1 => visited
  bitmask = 1 << size
  max = max_a_matrix a_matrix
  dp = []

  bitmask.times do |_| 
    j_ary = []
    size.times { j_ary << max }
    dp << j_ary
  end
  dp[1][0] = 0
  # zero is initiali point, not a city.

  #p dp

  # subset S-{i} to j city, then plus distance from j to i city.
  # C(S, i) = min { C(S-{i}, j) + dis(j, i)} where j belongs to S, j != i and j != 1.
  #                    |--> source
  # city : 7 6 5 4 3 2 1 0
  # bmask: 1 0 0 0 0 0 0 0   
  # dp[start_visited_sets][end]
  (1...bitmask).step(2).each do |mask|
    # 2 4 6 8 10 12 14 => 10, 100, 110, 1000, 1010, 1100, 1110
    # this mask always not included initial city(last digit).
    (1...size).step(1).each do |i|
      # cities included => 10 & 10 => 2, 110 & 10 => 2
      # (1 << i) represent a possible un-visited subset
      if (mask & (1 << i)) != 0
        (0...size).step(1).each do |j|
          # speicific bitmask subset to to another city 
          if (mask & 1 << j) != 0
            # [1100][2] = [1100][2], [111][j] + a
            # mask XOR (1 << i) => subset not include i city, but end at j city
            # when j == i , then a_matrix[i][j] => 0
            dp[mask][i] = min(dp[mask][i], dp[mask ^ (1 << i)][j] + a_matrix[j][i])
          end
        end
      end
    end
  end

  # set result
  res = max
  (1...size).each do |i|
    # (1 << size) - 1 => from all subsets but not include source city
    # dp[(1 << size) - 1][i] 
    #   => from visited cities set (1 << size) - 1 {include i city}, end at city i. 
    res = min(res, dp[(1 << size) - 1][i] + a_matrix[i][0])
  end

  cur = (1 << size) - 1
  order = []
  order[0] = "Source"
  last = 0
  (size-1).step(to: 1, by: -1) do |i|
    bj = -1
    (1...size).each do |j|
      bj = j if ((cur & 1 << j) != 0 && (bj == -1 || dp[cur][bj] + a_matrix[bj][last] > dp[cur][j] + a_matrix[j][last]))
    end
    order[i] = bj
    cur ^= 1 << bj
    last = bj
  end
  p order
  p res
end

tsp_dp $a_matrix