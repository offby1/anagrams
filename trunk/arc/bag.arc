;; -*-arc-*-
(= primes '(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))

(let a (coerce #\a 'int)
  (def bag (string)
       (apply * (trues [primes (- (coerce _ 'int) a)]
                       (coerce (downcase string) 'cons)))))

(def subtract (top bottom)
     (and (no (positive (mod top bottom)))
          (/ top bottom)))

(prn (bag "Cat"))

