# http://www.ruanyifeng.com/blog/2013/05/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm.html
# http://computing.dcu.ie/~humphrys/Notes/String/kmp.html
# input:    BBC ABCDB ABCDABCDABDE
# pattern:  ABCDABD
# http://blog.csdn.net/sunnianzhong/article/details/8802559
# p[3] == p[next[2]+1] => p[3] != p[2] => p[3] == [next[next[2]] + 1] => next[3] = 0

# prefix of str => aabaa => aaba, aab, aa, a
# suffix of str => aabaa => abaa, baa, aa, a
# which longest common prefix suffix string => partial match table.
# value start from 0 to table[i]'s value 

# algorithm kmp_table:
#     input:
#         an array of characters, W (the word to be analyzed)
#         an array of integers, T (the table to be filled)
#     output:
#         nothing (but during operation, it populates the table)
# 
#     define variables:
#         an integer, pos ← 2 (the current position we are computing in T)
#         an integer, cnd ← 0 (the zero-based index in W of the next 
# character of the current candidate substring)
# 
#     (the first few values are fixed but different from what the algorithm 
# might suggest)
#     let T[0] ← -1, T[1] ← 0
# 
#     while pos < length(W) do
#         (first case: the substring continues)
#         if W[pos - 1] = W[cnd] then
#             let cnd ← cnd + 1, T[pos] ← cnd, pos ← pos + 1
# 
#         (second case: it doesn't, but we can fall back)
#         else if cnd > 0 then
#             let cnd ← T[cnd]
# 
#         (third case: we have run out of candidates.  Note cnd = 0)
#         else
#             let T[pos] ← 0, pos ← pos + 1
#
# => algorithm kmp_search:
#    input:
#        an array of characters, S (the text to be searched)
#        an array of characters, W (the word sought)
#    output:
#        an integer (the zero-based position in S at which W is found)
#
#    define variables:
#        an integer, m ← 0 (the beginning of the current match in S)
#        an integer, i ← 0 (the position of the current character in W)
#        an array of integers, T (the table, computed elsewhere)
#
#    while m + i < length(S) do
#        if W[i] = S[m + i] then
#            if i = length(W) - 1 then
#                return m
#            let i ← i + 1
#        else
#            if T[i] > -1 then
#                let i ← T[i], m ← m + i - T[i]
#            else
#                let i ← 0, m ← m + 1
#    end        
#    (if we reach here, we have searched all of S unsuccessfully)
#    return the length of S
#    end

def kmp_search(input, pattern)
  table = partial_table pattern
  m = 0
  i = 0

  while (m + i) < input.size
    if pattern[i] == input[m + i]
      return m if i == pattern.size - 1
      i += 1
    else
      if table[i] > -1
        i = table[i]
        m = m + i - table[i]
      else
        i = 0
        m = m + 1
      end
    end
  end
  #(if we reach here, we have searched all of S unsuccessfully)
  "Nothing matched"
end

def partial_table(pattern)
  table = []
  pos = 2
  tmp = 0
  table[0] = -1
  table[1] = 0

  while pos < pattern.size
    #(first case: the substring continues)
    if pattern[pos - 1] == pattern[tmp]
      tmp += 1
      table[pos] = tmp
      pos += 1
    #(second case: it doesn't, but we can fall back)
    elsif tmp > 0
      tmp = table[tmp]
    #(third case: we have run out of candidates.  Note tmp = 0)
    else 
      table[pos] = 0
      pos += 1
    end
  end
  table
end 

pattern = "ABCDABD"
input = "ABC ABCDAB ABCDABCDABDE"


table = partial_table pattern
p table
puts "Match start at index: #{kmp_search(input, pattern)}"
