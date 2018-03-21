import unicode, strutils

const
   fastCheck = { # ΑΕΟαεο
      0x0391, 0x0395, 0x039f, 0x03b1, 0x03b5, 0x03bf}

   elotRules = [
      "Αυ", "Au",
      "Αύ", "Au",
      "Ευ", "Eu",
      "Εύ", "Eu",
      "Ου", "Ou",
      "Ού", "Ou",
      "αυ", "au",
      "αύ", "au",
      "ευ", "eu",
      "εύ", "eu",
      "ου", "ou",
      "ού", "ou"]

   englishMapping: array[0x037e..0x03ce, string] = [
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

template addMappedAscii(r) =
   if int32(r) >= 0x037e and int32(r) <= 0x03ce:
      result.add(englishMapping[int(r)])
   else:
      result.add($r)

proc unidecode*(s: string): string =
   result = newStringOfCap(s.len * 2 div 3) # just a guess
   for r in runes(s):
      addMappedAscii(r)

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
         if int32(r) <= 0x07ff and int16(r) in fastCheck:
            for j in countup(0, high(elotRules), 2):
               if s.continuesWith(elotRules[j], p):
                  result.add(elotRules[j + 1])
                  inc(p, elotRules[j].len)
                  i = p
                  break sIteration
         addMappedAscii(r)

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
