;; -*-arc-*-
(withs
    (combine (fn (words ans)
                 (mappend (fn (an)
                              (map [cons _ an]
                                   words))
                          ans))

             map+cdrs (afn (f xs)
                          (if (no xs)
                              nil
                              (cons (f (car xs)
                                       (cdr xs))
                                    (self f (cdr xs)))))

             mappend+cdrs (fn (f . args)
                              (apply + nil (apply map+cdrs f args))))
  

  (def anagrams (bag dict)
    (let dict (keep [subtract bag (car _)] dict)
      ;;(pr bag ", " (car dict) ": ")
      (mappend+cdrs
       (fn (_ subdict)
           (if (is bag (car _))
               (map list (cdr _))
               (aif (subtract bag (car _))
                    (combine (cdr _) (anagrams it subdict)))))
       dict))))
