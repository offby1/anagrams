(ns anagrams.core
(:use [clojure.set :only (union)])
(:use [clojure.string :only (lower-case split)])
(:use [clojure.test])
(:use [anagrams.bag :only (bag subtract-bags bag-empty?)])
(:use [anagrams.profile :only (profile prof)]))

(defn contains-vowel? [w]
  (re-find #"[aeiouy]" w))

(defn contains-non-letter? [w]
  (re-find #"[^a-z]" w))

(defn word-acceptable? [w]
  (prof :word-acceptable?
        (and
         (contains-vowel? w)
         (not (contains-non-letter? w))
         (or (= w "i")
             (= w "a")
             (< 1 (count w))
             ))))

;; FIXME -- make this a resource bundled into the uberjar
(def dict-fn (str "/usr/share/dict/words"))

(with-test
  (defn dict-from-strings [words]
    (reverse
     (sort-by
      first
      (reduce
       (fn [acc elt]
         (prof :update-in (update-in acc (list (bag elt)) #(clojure.set/union #{elt} %))))
       (hash-map)
       words))))

  (is (= '([5593M #{"dog"}] [710M #{"tac" "cat"}]) (dict-from-strings (list "dog" "dog" "cat" "tac"))))
  )
(test #'dict-from-strings)

(defn dict []
  (dict-from-strings
   (filter
    word-acceptable?
    (map clojure.string/lower-case
         (clojure.string/split (slurp dict-fn)
                               #"\n")))))

;; Suggested by "amalloy", April 2012
(defn combine [words anagrams]
  (for [word words, anagram anagrams]
    (cons word anagram)))

(defn filter-dict [bag dict]
  (filter
   (fn [entry]
     (subtract-bags
      bag
      (first entry)))
   dict))

(with-test
  (defn anagrams [bag dict]
    (if (bag-empty? bag) [[]]
        (let [filtered-dict (filter-dict bag dict)]
          (if (empty? filtered-dict) :no-result
              (for [[key words] filtered-dict
                    :let [smaller-bag (subtract-bags bag key),
                          anagrams-remainder (anagrams smaller-bag filtered-dict)]
                    :when (not= anagrams-remainder :no-result)
                    word words,
                    an anagrams-remainder]
                (cons word an))))))
  (is (= '(("GOD") ("dog")) (anagrams (bag "dog") {(bag "dog") #{"dog" "GOD"}}))))

(test #'anagrams)

(defn -main [& args]
  (profile
   (let [d (dict)
         result (anagrams (bag (apply str args)) d)]

     (doseq [an (take 15 result)]
       [(printf "%s\n" an)])

     (printf "Just reading in the dictionary is slow!\n"))))
