const s = "Crossbones"


proc decToBin*(num: int): string =
   if num == 0:
      return ""
   else:
      return decToBin(num div 2) & $(num mod 2)

proc strToBin(s: string): string =
   let n = len(s)
   result = decToBin(ord(s[0]))
   for i in 1 .. n - 1:
      result.add(' ' & decToBin(ord(s[i])))


echo strToBin(s)
