;; -*-arc-*-
(def combine (words ans)
     (mappend (fn (an)
                  (map [cons _ an]
                       words))
              ans))

(def map+cdrs (f xs)
     (if (no xs)
         nil
         (cons (f (car xs)
                  (cdr xs))
               (map+cdrs f (cdr xs)))))

(def mappend+cdrs (f . args)
     (apply + nil (apply map+cdrs f args)))

(def anagrams (bag dict)
     (let dict (keep [subtract bag (car _)] dict)
       ;;(pr bag ", " (car dict) ": ")
       (mappend+cdrs
        (fn (_ subdict)
            (if (is bag (car _))
                (map list (cdr _))
                (let diff (subtract bag (car _))
                  (and diff
                       (combine (cdr _) (anagrams diff subdict))))))
        dict)))
