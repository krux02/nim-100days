import math


proc eratosthenes(n: Natural): int =
   var p = newSeq[int8](n + 1)
   p[0] = 1
   p[1] = 1

   let slimit = sqrt(n.float).int
   for i in 0 .. slimit:
      if p[i] == 0:
         for j in countup(i * i, n, i):
            p[j] = 1

   for i in p:
      result.inc i

echo eratosthenes(1_000_000)
