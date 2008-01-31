;; -*-arc-*-
(def combine (short long)
     (mappend (fn (word)
                (map (fn (an)
                       (list word an))
                     short))
              long))
(def anagrams (bag dict)
     (let dict (keep [subtract bag (car _)] dict)
       (prn bag ", " (car dict))
       (mappend
        [if (is bag (car _))
            (cdr _)
            (let diff (subtract bag (car _))
              (and diff
                   (combine (cdr _) (anagrams diff dict))))]
        dict)))