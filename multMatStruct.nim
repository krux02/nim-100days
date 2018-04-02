import random, times, strutils

type Matrix = object
   data: seq[float]
   m, n: int

template newData() =
   newSeq(result.data, result.m * result.n)

proc `[]`(m: Matrix, i, j: int): float {.inline.} =
   m.data[i * m.m + j]

proc `[]=`(m: var Matrix, i, j: int, v: float) {.inline.} =
   m.data[i * m.m + j] = v

proc getRow(m: Matrix, i: int): seq[float] {.inline.} =
   result = newSeq[float](m.m)
   for j in 0 ..< m.m:
      result[j] = m.data[i * m.m + j]

proc randomMatrix(m, n: Natural): Matrix =
   let maxVal = 1000
   result.m = m
   result.n = n
   newData()
   for i in 0 ..< m:
      for j in 0 ..< n:
         result[i, j] = rand(0 .. maxVal).float

proc stdMatrixProduct(a, b: Matrix): Matrix =
   result.m = a.m
   result.n = b.n
   newData()
   for i in 0 ..< b.n:
      for j in 0 ..< a.m:
         var s = 0.0
         for k in 0 ..< a.n:
            s += a[i, k] * b[k, j]
         result[i, j] = s

proc optMatrixProduct(a, b: Matrix): Matrix =
   result.m = a.m
   result.n = b.n
   newData()
   var b_colj = newSeq[float](a.n)
   for j in 0 ..< b.n:
      for k in 0 ..< a.n:
         b_colj[k] = b[k, j]
      for i in 0 ..< a.m:
         var a_rowi = a.getRow(i)
         var s = 0.0
         for k in 0 ..< a.n:
            s += a_rowi[k] * b_colj[k]
         result[i, j] = s

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
