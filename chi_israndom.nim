import math, random

const
   n = 100_000
   count = 100

proc isRandom(freqs: openarray[int]; n: int): bool =
   ## Calculates the chi-square value for N positive integers less than r
   ## Source: "Algorithms in C" - Robert Sedgewick - pp. 517
   ## NB: Sedgewick recommends: "...to be sure, the test should be tried a few times,
   ## since it could be wrong in about one out of ten times."
   let r = freqs.len
   let n_r = n/r
   # This is valid if N is greater than about 10r
   assert(n > 10 * r)
   # Calculate chi-square
   var chiSquare = 0.0
   for v in freqs:
      let f = float(v) - n_r
      chiSquare += pow(f, 2.0)
   chiSquare = chiSquare / n_r
   # The statistic should be within 2(r)^1/2 of r
   abs(chiSquare - float(r)) <= 2.0 * sqrt(float(r))

proc main =
   # Get frequency of randoms
   var freqs: array[count, int]
   for i in 1 .. n:
      freqs[int(rand(1.0) * float(count))].inc
   doAssert isRandom(freqs, n)

main()
