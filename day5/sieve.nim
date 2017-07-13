proc eratosthenes(n: Natural): int =
   let n = (n + 1) / 2
   
   
   while i < n:
      if p[i] > 0:
         p[j * j / 2] = 0
      i.inc(1)
      j.inc(2)
   
   sum(p)
