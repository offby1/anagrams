(ns anagrams
  (:use [clojure.contrib.str-utils])
  (:require [clojure.contrib.str-utils2 :as su])
  (:use [clojure.test]))

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

(defn subtract-bags [top bot]
  (and (zero? (rem top bot))
       (quot top bot)))

(defn bag-empty? [b]
  (= b 1))

(with-test
  (defn dict-from-strings [words]
    (reverse
     (sort-by
      first
      (reduce
       (fn [acc elt]
         (update-in acc (list (bag elt)) #(clojure.set/union #{elt} %)))
       (hash-map)
       words))))

  (is (= '([5593 #{"dog"}] [710 #{"tac" "cat"}]) (dict-from-strings (list "dog" "dog" "cat" "tac"))))
  )

(def dict (dict-from-strings all-english-words))

(defn combine [words anagrams]
  (apply concat (map (fn [word]
                       (map (fn [an]
                              (cons word an))
                            anagrams))
                     words)))

(with-test
  (defn aai [bag dict]
    (loop [rv '()
           dict dict]
      (if (not (seq dict))
        rv
        (let [key (first (first dict))
              words (second (first dict))
              smaller-bag (subtract-bags bag key)]
          (recur
           (if smaller-bag
             (let [new-stuff
                   (if (bag-empty? smaller-bag)
                     (map list words)
                     (combine
                      words
                      (aai
                       smaller-bag
                       (filter
                        (fn [entry]
                          (subtract-bags
                           smaller-bag
                           (first entry)))
                        dict))))]
               (concat new-stuff rv))
             rv)

           (rest dict))))))
  (is (= '(("GOD") ("dog")) (aai (bag "dog") {(bag "dog") #{"dog" "GOD"}}))))

(deftest accurate
  (is (= 72794 (apply + (map count (vals dict)))))
  (is (= 66965 (count dict)))
  (is (= 19 (count (aai (bag "ernest") dict)))))

(if (not (seq *command-line-args*))
  (run-tests)
  (let [result (aai (bag (apply str *command-line-args*)) dict)]
    (binding [*out* *err*]
      (printf "%d anagrams of %s\n" (count result) *command-line-args*))
    (doseq [an result]
      [(printf "%s\n" an)])))
