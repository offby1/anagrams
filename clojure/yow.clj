(ns anagrams
  (:use [clojure.contrib.str-utils])
  (:require [clojure.contrib.str-utils2 :as su])
  (:use [clojure.test]))

(defn contains-vowel? [w]
  (some #(su/contains? w %)
        (list "a" "e" "i" "o" "u" "y")))

(defn word-acceptable? [w]
  (let [w  (su/lower-case w)]
    (and
     (contains-vowel? w)
     (or (= w "i")
         (= w "a")
         (< 1 (count w))
         ))))

(def dict-fn (str (System/getProperty "user.home") "/stray-doodles/anagrams/words.utf8"))
(def in (-> dict-fn java.io.FileReader. java.io.BufferedReader. ))
(def all-english-words  (filter word-acceptable? (re-split #"\n" (slurp dict-fn))))
(printf "all-english-words: %d" (count all-english-words))
(def primes [2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101])
(defn bag [w]
  (apply * (map #(get primes (- (int %) (int \a)) 1) w)))

(with-test
  (defn dict-from-strings [words]
    (loop [h (hash-map)
           words words]
      (if (zero? (count words))
        h
        (recur
         (update-in h (list (bag (first words))) #(clojure.set/union #{(first words)} %))
         (rest words)))
      ))
  (is (= {710 #{"tac" "cat"}, 5593 #{"dog"}} (dict-from-strings (list "dog" "dog" "cat" "tac")))))

(run-tests)
(def dict (dict-from-strings all-english-words))
(printf "Big dict has %d bags" (count dict))
