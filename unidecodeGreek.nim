import unicode, strutils

const
   elotMapping = { # digraphs are on top of their first letter
      ";":  "?",
      "Ά":  "A",
      "·":  ";",
      "Έ":  "E",
      "Ή":  "I",
      "Ί":  "I",
      "Ό":  "O",
      "Ύ":  "Y",
      "Ώ":  "O",
      "ΐ":  "i",
      "Αυ": "Au",
      "Αύ": "Au",
      "Α":  "A",
      "Β":  "V",
      "Γ":  "G",
      "Δ":  "D",
      "Ευ": "Eu",
      "Εύ": "Eu",
      "Ε":  "E",
      "Ζ":  "Z",
      "Η":  "I",
      "Θ":  "Th",
      "Ι":  "I",
      "Κ":  "K",
      "Λ":  "L",
      "Μ":  "M",
      "Ν":  "N",
      "Ξ":  "X",
      "Ου": "Ou",
      "Ού": "Ou",
      "Ο":  "O",
      "Π":  "P",
      "Ρ":  "R",
      "Σ":  "S",
      "Τ":  "T",
      "Υ":  "Y",
      "Φ":  "F",
      "Χ":  "Ch",
      "Ψ":  "Ps",
      "Ω":  "O",
      "Ϊ":  "I",
      "Ϋ":  "Y",
      "ά":  "a",
      "έ":  "e",
      "ή":  "i",
      "ί":  "i",
      "ΰ":  "u",
      "αυ": "au",
      "αύ": "au",
      "α":  "a",
      "β":  "v",
      "γ":  "g",
      "δ":  "d",
      "ευ": "eu",
      "εύ": "eu",
      "ε":  "e",
      "ζ":  "z",
      "η":  "i",
      "θ":  "th",
      "ι":  "i",
      "κ":  "k",
      "λ":  "l",
      "μ":  "m",
      "ν":  "n",
      "ξ":  "x",
      "ου": "ou",
      "ού": "ou",
      "ο":  "o",
      "π":  "p",
      "ρ":  "r",
      "ς":  "s",
      "σ":  "s",
      "τ":  "t",
      "υ":  "y",
      "φ":  "f",
      "χ":  "ch",
      "ψ":  "ps",
      "ω":  "o",
      "ϊ":  "i",
      "ϋ":  "y",
      "ό":  "o",
      "ύ":  "y",
      "ώ":  "o"}

   englishMapping = [
      "?",  # ;
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

proc translitarate*(s: string): string {.inline.} =
   multiReplace(s, elotMapping)

when isMainModule:
   assert unidecode("Ελληνική Δημοκρατία") == "Elliniki Dimokratia"
   assert unidecode("Ελευθερία") == "Eleutheria"
   assert unidecode("Ευαγγέλιο") == "Euaggelio"
   assert unidecode("άυλος") == "aulos"
   assert unidecode("των υιών") == "ton uion"

   assert translitarate("Ελληνική Δημοκρατία") == "Elliniki Dimokratia"
   assert translitarate("Ελευθερία") == "Eleutheria"
   assert translitarate("Ευαγγέλιο") == "Euaggelio"
   assert translitarate("άυλος") == "aylos"
   assert translitarate("των υιών") == "ton yion"
