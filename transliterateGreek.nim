import unicode

let mapping = {
   " ": "_",
   "Ά": "A",
   "Έ": "E",
   "Ή": "I",
   "Ί": "I",
   "Ό": "O",
   "Ύ": "Y",
   "Ώ": "OY",
   "Α": "A",
   "Β": "V",
   "Γ": "G",
   "Δ": "D",
   "Ε": "E",
   "Ζ": "Z",
   "Η": "I",
   "Θ": "TH",
   "Ι": "I",
   "Κ": "K",
   "Λ": "L",
   "Μ": "M",
   "Ν": "N",
   "Ξ": "X",
   "Ο": "O",
   "Π": "P",
   "Ρ": "R",
   "Σ": "S",
   "Τ": "T",
   "Υ": "Y",
   "Φ": "F",
   "Χ": "CH",
   "Ψ": "PS",
   "Ω": "OY",
   "Ϊ": "I",
   "Ϋ": "Y",
   "ΐ": "i",
   "ά": "a",
   "έ": "e",
   "ή": "i",
   "ί": "i",
   "α": "a",
   "β": "v",
   "γ": "g",
   "δ": "d",
   "ε": "e",
   "ζ": "z",
   "η": "i",
   "θ": "th",
   "ι": "i",
   "κ": "k",
   "λ": "l",
   "μ": "m",
   "ν": "n",
   "ξ": "x",
   "ο": "o",
   "π": "p",
   "ρ": "r",
   "σ": "s",
   "τ": "t",
   "υ": "u",
   "φ": "f",
   "χ": "ch",
   "ψ": "ps",
   "ω": "oy",
   "ϊ": "i",
   "ϋ": "u",
   "ό": "o",
   "ύ": "u",
   "ώ": "ou"
}

proc binaryStrSearch(x: openArray[tuple[uni, lit: string]], y: string): int =
   var a = 0
   var b = len(x) - 1
   while a <= b:
      var mid = (a + b) div 2
      var c = cmp(x[mid].uni, y)
      if c < 0:
         a = mid + 1
      elif c > 0:
         b = mid - 1
      else:
         return mid
   result = - 1

proc swap*(c: string): string =
   var i = binaryStrSearch(mapping, c)
   if i < 0: return c
   result = mapping[i][1]

proc transliterate*(s: string): string =
   result = newStringOfCap(s.len)
   for r in runes(s):
      let c = toUTF8(r)
      result.add(swap(c))

proc transcribe*(s: string): string =
   discard

when isMainModule:
   assert transliterate("καθυστέρηση") == "kathusterisi"
