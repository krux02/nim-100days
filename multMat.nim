import random, times, strutils

type Matrix = object
   data: seq[seq[float]]
   m, n: int

template newData() =
   newSeq(result.data, result.m)
   for i in 0 ..< result.m:
      newSeq(result.data[i], result.n)

proc randomMatrix(m, n: Natural): Matrix =
   let maxVal = 1000
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result.data[i][j] = rand(0 .. maxVal).float

proc stdMatrixProduct(a, b: Matrix): Matrix =
   result.m = a.m
   result.n = b.n
   newData()
   for i in 0 ..< b.n:
      for j in 0 ..< a.m:
         for k in 0 ..< a.n:
            result.data[i][j] += a.data[i][k] * b.data[k][j]

proc optMatrixProduct(a, b: Matrix): Matrix =
   result.m = a.m
   result.n = b.n
   newData()
   var b_colj = newSeq[float](a.n)
   for j in 0 ..< b.n:
      for k in 0 ..< a.n:
         b_colj[k] = b.data[k][j]
      for i in 0 ..< a.m:
         var a_rowi = unsafeAddr a.data[i]
         var s = 0.0
         for k in 0 ..< a.n:
            s += a_rowi[k] * b_colj[k]
         result.data[i][j] = s

proc main() =
   const n = 1000
   let A = randomMatrix(n, n)
   let B = randomMatrix(n, n)
   block:
      # time standard ijk
      let start = epochTime()
      discard stdMatrixProduct(A, B)
      let duration = epochTime() - start
      echo formatFloat(duration, ffDecimal, 3), "us --- standard"
   block:
      # time Jama version
      let start = epochTime()
      discard optMatrixProduct(A, B)
      let duration = epochTime() - start
      echo formatFloat(duration, ffDecimal, 3), "us --- optimized"

main()
