(= anagrams-by-bag (table))
(def acceptable (word)
     (or (is word "i")
         (is word "a")
         (and (some [in _ #\a #\e #\i #\o #\u] word)
              (all  [and (>= _ #\a)
                         (<= _ #\z)] word))))
(time
 (w/infile
  s
  "/home/erich/doodles/anagrams/words-short"
  (readc s) ;;consume initial blank line
  (whiler l (readline s) nil
          (= l (downcase l))
          (and (acceptable l)
               (pushnew l (anagrams-by-bag (bag l)))))
  (prn (len anagrams-by-bag) " bags.")))
