import unicode, strutils

const
   specialVowels = [ # treated as such
      0x0391'i32, # Α
      0x0395,  # Ε
      0x039f,  # Ο
      0x03b1,  # α
      0x03b5,  # ε
      0x03bf]  # ο

   elotRules = {
      "Αυ": "Au",
      "Αύ": "Au",
      "Ευ": "Eu",
      "Εύ": "Eu",
      "Ου": "Ou",
      "Ού": "Ou",
      "αυ": "au",
      "αύ": "au",
      "ευ": "eu",
      "εύ": "eu",
      "ου": "ou",
      "ού": "ou"}

   englishMapping = [
      "?",  # ;
      "",   #
      "",   #
      "",   #
      "",   #
      "",   #
      "",   # ΄
      "",   # ΅
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
      "y",  # ΰ
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
      "y",  # υ
      "f",  # φ
      "ch", # χ
      "ps", # ψ
      "o",  # ω
      "i",  # ϊ
      "y",  # ϋ
      "o",  # ό
      "y",  # ύ
      "o"]  # ώ

proc unidecode*(s: string): string =
   result = newStringOfCap(s.len * 2 div 3) # just a guess
   for r in runes(s):
      if int32(r) >= 0x037e'i32 and int32(r) <= 0x03ce'i32:
         result.add(englishMapping[int(r) - 0x037e])
      else:
         result.add($r)

proc transliterate*(s: string): string =
   result = newStringOfCap(s.len * 2 div 3)
   var
      i = 0
      p = 0
      r: Rune
   while i < len(s):
      p = i
      fastRuneAt(s, i, r)
      block sIteration:
         if int32(r) >= 0x037e'i32 and int32(r) <= 0x03ce'i32:
            if int32(r) in specialVowels:
               for tup in elotRules:
                  if s.continuesWith(tup[0], p):
                     result.add(tup[1])
                     inc(p, tup[0].len)
                     i = p
                     break sIteration
            result.add(englishMapping[int(r) - 0x037e])
         else:
            result.add($r)

when isMainModule:
   assert unidecode("Ελληνική Δημοκρατία") == "Elliniki Dimokratia"
   assert unidecode("Ελευθερία") == "Eleytheria"
   assert unidecode("Ευαγγέλιο") == "Eyaggelio"
   assert unidecode("άυλος") == "aylos"
   assert unidecode("των υιών") == "ton yion"

   assert transliterate("Ελληνική Δημοκρατία") == "Elliniki Dimokratia"
   assert transliterate("Ελευθερία") == "Eleutheria"
   assert transliterate("Ευαγγέλιο") == "Euaggelio"
   assert transliterate("άυλος") == "aylos"
   assert transliterate("των υιών") == "ton yion"
