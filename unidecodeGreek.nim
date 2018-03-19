import unicode, sequtils, strutils

const
   englishMapping = [
      "?",  # ;
      "",   #
      "",   #
      "",   #
      "",   #
      "",   #
      "",   #
      "",   #
      "A",  # Ά
      ";",  # ·
      "E",  # Έ
      "I",  # Ή
      "I",  # Ί
      "",   #
      "O",  # Ό
      "",   #
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
      "",   #
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
      "u",  # ΰ
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
      "s",  # ς
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

proc unidecode*(s: string): string =
   result = newStringOfCap(s.len * 2 div 3) # just a guess
   for r in runes(s):
      if int32(r) >= 0x037e'i32 and int32(r) <= 0x03ce'i32:
         result.add(englishMapping[int(r) - 0x037e])
      else:
         result.add($r)

when isMainModule:
   assert unidecode("Ελληνική Δημοκρατία") == "Elliniki Dimokratia"
   assert unidecode("Ελευθερία") == "Eleutheria"
   assert unidecode("Ευαγγέλιο") == "Euaggelio"
   assert unidecode("των υιών") == "ton uion"
