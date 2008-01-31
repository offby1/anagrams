(with (dictionary nil cache-name "/home/erich/doodles/anagrams/arc/dict")
      (if (file-exists cache-name)
          (= dictionary (readfile1  cache-name))
          (with  (read 0 saved 0
                  anagrams-by-bag (table)
                                  acceptable (fn (word)
                                                 (or (is word "i")
                                                     (is word "a")
                                                     (and (some [in _ #\a #\e #\i #\o #\u] word)
                                                          (all  [and (>= _ #\a)
                                                                     (<= _ #\z)] word)))))
                 (w/infile
                  s
                  "/home/erich/doodles/anagrams/words-short"
                  (readc s) ;;consume initial blank line
                  (time

                   (do
                       (catch
                        (whilet l (readline s)
                                (= l (downcase l))
                                (++ read)
                                (if (is 0 (mod read 2000)) (prn read " read..."))
                                (if (acceptable l)
                                    (do (pushnew l (anagrams-by-bag (bag l)))
                                        (++ saved)
                                      (if (is 0 (mod saved 2000)) (prn saved " saved..."))))))

                       (= dictionary (writefile1 (map cons
                                                      (keys anagrams-by-bag)
                                                      (vals anagrams-by-bag))
                                                 cache-name))
                     (prn "read " read " words, saved " saved " words"))))))
      (prn  (len dictionary) " bags."))

