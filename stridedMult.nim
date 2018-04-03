import strutils, times, random

type
   Matrix = object
      data: seq[float]
      stride: int

proc `$`(m: Matrix): string =
   result = ""
   for e in countup(0, high(m.data), m.stride):
      result.add join(m.data[e ..< e + m.stride], "\t")
      result.add "\n"

proc matrix(data: seq[float], s: int): Matrix =
   result.data = data
   result.stride = s

proc randomMatrix(m, n: int): Matrix =
   const maxVal = 1000
   result.stride = n
   newSeq(result.data, m * n)
   for i in 0 ..< m * n:
      result.data[i] = rand(maxVal).float

proc multiply(a, b: Matrix): Matrix =
   assert(a.stride * b.stride == len(b.data), "Dimensions must agree")
   result.stride = b.stride
   newSeq(result.data, len(a.data) div a.stride * b.stride)
   var m3x = 0
   for m1c0 in countup(0, high(a.data), a.stride):
      for m2r0 in 0 ..< b.stride:
         var m1x = m1c0
         var s = 0.0
         for m2x in countup(m2r0, high(b.data), b.stride):
            s += a.data[m1x] * b.data[m2x]
            m1x.inc
         result.data[m3x] = s
         m3x.inc

#var a = matrix(@[1.0, 2, 3, 4, 5, 6, 7, 8], 4)
#var b = matrix(@[1.0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 3)

#echo multiply(a, b)

proc main() =
   const n = 1000
   let a = randomMatrix(n, n)
   let b = randomMatrix(n, n)
   block:
      # time standard ijk
      let start = epochTime()
      discard multiply(a, b)
      let duration = epochTime() - start
      echo formatFloat(duration, ffDecimal, 3), "us --- standard"

main()
