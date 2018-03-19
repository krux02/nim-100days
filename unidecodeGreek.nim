import unicode, sequtils, strutils

const
   greekLetters = mapLiterals([
      0x0386,  # Ά
      0x0388,  # Έ
      0x0389,  # Ή
      0x038a,  # Ί
      0x038c,  # Ό
      0x038e,  # Ύ
      0x038f,  # Ώ
      0x0390,  # ΐ
      0x0391,  # Α
      0x0392,  # Β
      0x0393,  # Γ
      0x0394,  # Δ
      0x0395,  # Ε
      0x0396,  # Ζ
      0x0397,  # Η
      0x0398,  # Θ
      0x0399,  # Ι
      0x039a,  # Κ
      0x039b,  # Λ
      0x039c,  # Μ
      0x039d,  # Ν
      0x039e,  # Ξ
      0x039f,  # Ο
      0x03a0,  # Π
      0x03a1,  # Ρ
      0x03a3,  # Σ
      0x03a4,  # Τ
      0x03a5,  # Υ
      0x03a6,  # Φ
      0x03a7,  # Χ
      0x03a8,  # Ψ
      0x03a9,  # Ω
      0x03aa,  # Ϊ
      0x03ab,  # Ϋ
      0x03ac,  # ά
      0x03ad,  # έ
      0x03ae,  # ή
      0x03af,  # ί
      0x03b1,  # α
      0x03b2,  # β
      0x03b3,  # γ
      0x03b4,  # δ
      0x03b5,  # ε
      0x03b6,  # ζ
      0x03b7,  # η
      0x03b8,  # θ
      0x03b9,  # ι
      0x03ba,  # κ
      0x03bb,  # λ
      0x03bc,  # μ
      0x03bd,  # ν
      0x03be,  # ξ
      0x03bf,  # ο
      0x03c0,  # π
      0x03c1,  # ρ
      0x03c3,  # σ
      0x03c4,  # τ
      0x03c5,  # υ
      0x03c6,  # φ
      0x03c7,  # χ
      0x03c8,  # ψ
      0x03c9,  # ω
      0x03ca,  # ϊ
      0x03cb,  # ϋ
      0x03cc,  # ό
      0x03cd,  # ύ
      0x03ce], Rune) # ώ

   englishMapping = [
      "A",  # Ά
      "E",  # Έ
      "I",  # Ή
      "I",  # Ί
      "O",  # Ό
      "Y",  # Ύ
      "O",  # Ώ
      "i",  # ΐ
      "A",  # Α
      "V",  # Β
      "G",  # Γ
      "D",  # Δ
      "E",  # Ε
      "Z",  # Ζ
      "I",  # Η
      "TH", # Θ
      "I",  # Ι
      "K",  # Κ
      "L",  # Λ
      "M",  # Μ
      "N",  # Ν
      "X",  # Ξ
      "O",  # Ο
      "P",  # Π
      "R",  # Ρ
      "S",  # Σ
      "T",  # Τ
      "Y",  # Υ
      "F",  # Φ
      "CH", # Χ
      "PS", # Ψ
      "O",  # Ω
      "I",  # Ϊ
      "Y",  # Ϋ
      "a",  # ά
      "e",  # έ
      "i",  # ή
      "i",  # ί
      "a",  # α
      "v",  # β
      "g",  # γ
      "d",  # δ
      "e",  # ε
      "z",  # ζ
      "i",  # η
      "th", # θ
      "i",  # ι
      "k",  # κ
      "l",  # λ
      "m",  # μ
      "n",  # ν
      "x",  # ξ
      "o",  # ο
      "p",  # π
      "r",  # ρ
      "s",  # σ
      "t",  # τ
      "u",  # υ
      "f",  # φ
      "ch", # χ
      "ps", # ψ
      "o",  # ω
      "i",  # ϊ
      "u",  # ϋ
      "o",  # ό
      "u",  # ύ
      "o"]  # ώ

proc binaryRuneSearch(a: openArray[Rune], key: Rune): int =
   # binary search for `key` in `a`. Returns -1 if not found.
   var b = len(a)
   while result < b:
      var mid = (result + b) div 2
      if a[mid] <% key:
         result = mid + 1
      else:
         b = mid
   if result >= len(a) or a[result] != key:
      result = -1

proc unidecode*(s: string): string =
   result = newStringOfCap(s.len * 2 div 3) # just a guess
   for r in runes(s):
      var i = binaryRuneSearch(greekLetters, r)
      if i >= 0:
         result.add(englishMapping[i])
      else:
         result.add($r)

when isMainModule:
   assert unidecode("Ελληνική Δημοκρατία") == "Elliniki Dimokratia"
   assert unidecode("Ελευθερία") == "Eleutheria"
   assert unidecode("Ευαγγέλιο") == "Euaggelio"
   assert unidecode("των υιών") == "ton uion"
