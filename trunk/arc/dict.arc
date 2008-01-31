(with  (anagrams-by-bag (table)
                        acceptable (fn (word)
                                       (or (is word "i")
                                           (is word "a")
                                           (and (some [in _ #\a #\e #\i #\o #\u] word)
                                                (all  [and (>= _ #\a)
                                                           (<= _ #\z)] word)))))
       (w/infile
        s
        "/home/erich/doodles/anagrams/words"
        (readc s) ;;consume initial blank line
        (time
         (with (read 0 saved 0 cache-name "/home/erich/doodles/anagrams/arc/dict")
           (if (file-exists cache-name)
               (= anagrams-by-bag (load-table cache-name))
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

                   (save-table anagrams-by-bag cache-name)
                 (prn "read " read " words, saved " saved " words")))
           (prn  (len anagrams-by-bag) " bags.")))))
