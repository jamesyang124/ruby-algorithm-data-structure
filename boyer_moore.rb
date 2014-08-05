# http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm
# http://www.ruanyifeng.com/blog/2013/05/boyer-moore_string_search_algorithm.html
# http://www.geeksforgeeks.org/pattern-searching-set-7-boyer-moore-algorithm-bad-character-heuristic/
# http://stackoverflow.com/questions/19345263/boyer-moore-good-suffix-heuristics

# Search pattern whether in input string.

def bad_char_heuristic(pattern)
  bad_char_hash = {}

  (0...pattern.size).each do |i|
    bad_char_hash[pattern[i]] = i
  end
  bad_char_hash
end

def good_suffix_heuristic(pattern)

  # preprocess I
  i = pattern.size
  j = pattern.size + 1 
  f = []
  # suffix shift array
  s = []
  j.times { |_| s << 0 }

  f[i] = j

  while (i > 0)
    while (j <= pattern.size && pattern[i-1] != pattern[j-1])
      s[j] = j - i if s[j] == 0
      j = f[j]
      # puts "j now is: #{j}"
    end
    i -= 1
    j -= 1 
    f[i]=j
    # puts "F[#{i}] now is: #{j}, #{s}"
  end
  # preprocess II
  j = 0
  j = f[0]
  (0..pattern.size).step(1).each do |i|
    s[i] = j if s[i] == 0
    j = f[j] if i == j
  end
  s
end

def max(a, b)
  a > b ? a : b 
end

def boyer_moore(string, pattern)
  m = pattern.size
  n = string.size

  bad_char_hash = bad_char_heuristic pattern
  good_suffix = good_suffix_heuristic pattern
  # if char not in bad_char_hash -> -1

  shift = 0 
  while shift <= n - m
    j = m - 1
    j -= 1 while j >= 0 && pattern[j] == string[shift + j] 

    if (j < 0)
      puts "pattern occurs at shift #{shift}"
      bad_char_hash[string[shift + m]] = -1 unless bad_char_hash[string[shift + m]]
      shift += (shift + m < n) ? (m - bad_char_hash[string[shift + m]]) : 1
    else
      bad_char_hash[string[shift + j]] = -1 unless bad_char_hash[string[shift + j]]
      shift += max(good_suffix[j + 1], j - bad_char_hash[string[shift + j]])
    end
  end
end

str = "ABAAABCD"
pattern = 'ABC'
boyer_moore str, pattern