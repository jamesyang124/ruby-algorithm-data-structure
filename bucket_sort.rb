# Assume k buckets, n elements
#
# for each bucket in k                  => estimate total running time O(k)
#  for each element x in that buckets   => estimate total running time O(n) [by insertion sort]
#    insert x to out put array (by insertion sort)
# Avg, Best time complexity : O(k + n)
# Worst case: insertion sort worst case take n^2, and assume each bucket only has 1 element. => O(n^2)
# space complexity: possible n elements for each bucket => n * k

