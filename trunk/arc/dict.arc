(= anagrams-by-bag (table))
(w/infile
  s
  "/home/erich/doodles/anagrams/words-short"
  (readc s) ;;consume initial blank line
  (whiler l (readline s) nil
    (pushnew l (anagrams-by-bag (bag l)))))
