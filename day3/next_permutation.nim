import algorithm


proc permute(values: openarray[T]): seq[T] =
   let n = len(values) - 1

   # i: position of pivot
   for i in countdown(n, 0):
      if values[i] < values[i + 1]:
         break
   else:
      # very last permutation
      return reversed(values)

   # j: position of the next candidate
   for j in countdown(n, i):
      if values[i] < values[j]:
         # swap pivot and reverse the tail
         values[i], values[j] = values[j], values[i]
         values[i + 1:] = reversed(values[i + 1:])
         break

   return values
