import times, strutils, unidecodeGreek

template bench(name: string, code) =
   proc runBench() {.gensym.} =
      let start = epochTime()
      code
      let elapsed = epochTime() - start
      let timeStr = formatFloat(elapsed, ffDecimal, 3)
      echo name, ": ", timeStr
   runBench()

const
   word = "Ελληνική Δημοκρατία"

   paragraph = "Η Όρνιθα, ή κοινώς κότα, (αρσενικός: αλέκτωρ (καθαρεύουσα), ή κοινώς πετεινός ή κόκκορας, ουδέτερο το κοτόπουλο) (επιστ. Gallus gallus domesticus - Όρνιθα η όρνιθα η οικιακή) είναι ένα εξημερωμένο πτηνό. Είναι ένα από τα πιο κοινά και διαδεδομένα οικόσιτα ζώα, αφού υπολογίζεται ότι το 2003 υπήρχαν γύρω στα 24 δισεκατομμύρια εκπρόσωποι του είδους. Δηλαδή υπάρχουν περισσότερες κότες στον κόσμο από οποιοδήποτε άλλο πουλί, ή και από τους ανθρώπους. Ο άνθρωπος εκτρέφει τις κότες κυρίως ως πηγή τροφίμων, για το κρέας τους και τα αυγά τους."


bench("unideWordBench"):
   for t in 1 .. 10_000: discard unidecode(word)

bench("unideParBench"):
   for t in 1 .. 10_000: discard unidecode(paragraph)

bench("transWordBench"):
   for t in 1 .. 10_000: discard transliterate(word)

bench("transParBench"):
   for t in 1 .. 10_000: discard transliterate(paragraph)
