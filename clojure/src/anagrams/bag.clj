(ns anagrams.bag
(:use [clojure.string :only (lower-case)]))

(def primes [2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101])
(defn bag [w]
  (apply * 1N (map #(get primes (- (int %) (int \a)) 1) (clojure.string/lower-case w))))

(defn subtract-bags [top bot]
  (and (zero? (rem top bot))
       (quot top bot)))

(defn bag-empty? [b]
  (== b 1))
