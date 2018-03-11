# Factorials

proc createFactTable[n: static[int]]: array[0 .. n, int] =
   result[0] = 1
   for i in 1 .. n:
      result[i] = result[i - 1] * i

when sizeof(int) == 4:
   const factTable = createFactTable[12]()
else:
   const factTable = createFactTable[20]()

proc fact*(n: int): int =
   assert(n > 0, $n & " must not be negative.")
   assert(n < factTable.len, $n & " is too large to look up in the table")
   factTable[n]
