(ns anagrams
  (:use [clojure.contrib.str-utils])
  (:require [clojure.contrib.str-utils2 :as su])
  (:use [clojure.test]))

(set! *warn-on-reflection* true)

(defn contains-vowel? [w]
  (re-find #"[aeiouy]" w))

(defn contains-non-letter? [w]
  (re-find #"[^a-z]" w))

(defn word-acceptable? [w]
  (and
   (contains-vowel? w)
   (not (contains-non-letter? w))
   (or (= w "i")
       (= w "a")
       (< 1 (count w))
       )))

(def dict-fn (str (System/getProperty "user.home") "/stray-doodles/anagrams/words.utf8"))
(def in (-> dict-fn java.io.FileReader. java.io.BufferedReader. ))
(def all-english-words  (filter word-acceptable? (map su/lower-case (re-split #"\n" (slurp dict-fn)))))

(def primes [2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101])
(defn bag [w]
  (apply * (map #(get primes (- (int %) (int \a)) 1) w)))

(with-test
  (defn dict-from-strings [words]
    (reduce
     (fn [acc elt]
       (update-in acc (list (bag elt)) #(clojure.set/union #{elt} %)))
     (hash-map)
     words))

  (is (= {710 #{"tac" "cat"}, 5593 #{"dog"}} (dict-from-strings (list "dog" "dog" "cat" "tac"))))
  )

(def dict (dict-from-strings all-english-words))
(deftest accurate
  (is (= 72794 (apply + (map count (vals dict)))))
  (is (= 66965 (count dict))))
(run-tests)

