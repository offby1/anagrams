;; -*-arc-*-
(with (cache-name "/home/erich/doodles/anagrams/arc/dict")
      (if (file-exists cache-name)
          (= dictionary* (readfile1  cache-name))
          (with  (read 0 saved 0
                       anagrams-by-bag (table)
                       acceptable (fn (word)
                                      (or (is word "i")
                                          (is word "a")
                                          (and (< 1 (len word))
                                               (some [in _ #\a #\e #\i #\o #\u] word)
                                               (all  [and (>= _ #\a)
                                                          (<= _ #\z)] word)))))
            (prn "Gaah, the cached dictionary doesn't exist; gotta regenerate it.")
            (prn "This'll take a while.  Chill.")
            (w/infile
             s
             "/home/erich/doodles/anagrams/words"
             (readc s) ;;consume initial blank line
             (time

              (do
                (catch
                 (whilet l (readline s)
                         (= l (downcase l))
                         (when (multiple (++ read) 2000)(prn read " read..."))
                         (if (acceptable l)
                             (do (pushnew l (anagrams-by-bag (bag l)))
                                 (when (multiple (++ saved) 2000) (prn saved " saved..."))))))

                (= dictionary* (writefile1 (map cons
                                                (keys anagrams-by-bag)
                                                (vals anagrams-by-bag))
                                           cache-name))
                (prn "read " read " words, saved " saved " words"))))))
      (prn  (len dictionary*) " bags."))
