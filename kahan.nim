proc sumKahan[T: SomeReal](input: openarray[T]): T =
   var sum = T(0)
   var c = T(0)               # A running compensation for lost low-order bits.
   for i in 0 ..< input.len:
      let y = input[i] - c    # So far, so good: c is zero.
      let t = sum + y         # Alas, sum is big, y small, so low-order digits of y are lost.
      c = (t - sum) - y       # (t - sum) cancels the high-order part of y; subtracting y recovers negative (low part of y)
      sum = t                 # Algebraically, c should always be zero. Beware overly-aggressive optimizing compilers!
   result = sum               # Next time around, the lost low part will be added to y in a fresh attempt.

proc sumKbn[T: SomeReal](v: openarray[T]): T =
   # Kahan (compensated) summation: O(1) error growth, at the expense
   # of a considerable increase in computational expense.
   if len(v) == 0: return
   var sum = v[low(v)]
   var c = T(0)
   for i in low(v).succ .. high(v):
      let vi = v[i]
      let t = sum + vi
      if abs(sum) >= abs(vi):
         c += (sum - t) + vi
      else:
         c += (vi - t) + sum
      sum = t
   result = sum + c

import math

proc msum[T: SomeReal](v: openarray[T]): T =
   assert len(v) != 0
   var partials = newSeq[T]()
   for x in v:
      var x = x
      var i = 0
      for y in partials:
         var y = y
         if abs(x) < abs(y):
            swap(x, y)
         let hi = x + y
         let lo = y - (hi - x)
         if lo != T(0):
            partials[i] = lo
            inc(i)
         x = hi
      setLen(partials, i+1)
      partials[i] = x
   result = sum(partials)

var epsilon = 1.0
while 1.0 + epsilon != 1.0:
    epsilon /= 2.0

let data = [1.0, epsilon, -epsilon]
assert sumKbn(data) == 1.0
assert msum(data) == 1.0
assert (1.0 + epsilon) - epsilon != 1.0
