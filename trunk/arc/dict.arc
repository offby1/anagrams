(= anagrams-by-bag (table))
(w/infile
  s
  "/home/erich/doodles/anagrams/words-short"
  (readc s) ;;consume initial blank line
  (let l (readline s)
    (while l
      (pushnew l (anagrams-by-bag (bag l)))
      (= l (readline s)))))
