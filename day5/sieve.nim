import math


proc eratosthenes(n: Natural): seq[int8] =
  result = newSeq[int8](n + 1)
  result[0] = 1
  result[1] = 1

  let slimit = sqrt(n.float).int
  for i in 0 .. slimit:
    if result[i] == 0:
      for j in countup(i * i, n, i):
        result[j] = 1


echo eratosthenes(100)
