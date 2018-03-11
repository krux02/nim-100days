import fact

proc isPerm*(arr: openarray[int]): bool =
   result = true
   let n = len(arr)
   var used = newSeq[bool](n)
   for a in arr:
      if a >= 0 and a < n and not used[a]:
         used[a] = true
      else:
         return false

proc rank*(arr: openarray[int]): int =
   assert(isPerm(arr), "arr is not a permutation")
   let h = high(arr)
   for i in 0 .. h - 1:
      let f = fact(h - i)
      for j in i + 1 .. h:
         if arr[j] < arr[i]:
            result += f
