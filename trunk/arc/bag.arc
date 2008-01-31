;; -*-arc-*-
(= primes-by-letter
   (listtab
    (map
     list
     (with (i nil  letters nil)
           (loop (= i (coerce #\z 'int)) (>= i (coerce #\a 'int))  (-- i)
                 (push (coerce  i 'char) letters))
           letters)
     '(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))))

(def bag (string)
     (apply * (trues [primes-by-letter _] (coerce (downcase string) 'cons))))

(def subtract (top bottom)
     (and (no (positive (mod top bottom)))
          (/ top bottom)))

(prn (bag "Cat"))

