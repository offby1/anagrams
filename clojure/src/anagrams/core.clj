(ns anagrams.core
(require [clojure.java.io :as io])
(:use [clojure.set :only (union)])
(:use [clojure.string :only (lower-case split)])
(:use [clojure.test])
(:use [anagrams.bag :only (bag subtract-bags bag-empty?)]))


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

(def dict-fn (io/resource "words.utf8"))

(with-test
  (defn dict-from-strings [words]
      (reduce
       (fn [acc elt]
         (update-in acc (list (bag elt)) #(clojure.set/union #{elt} %)))
       (hash-map)
     words))

  (is (= (set '([5593N #{"dog"}] [710N #{"tac" "cat"}]))
         (set (dict-from-strings (list "dog" "dog" "cat" "tac")))))
  )
(test #'dict-from-strings)

(defn dict []
  (dict-from-strings
   (filter
    word-acceptable?
    (map clojure.string/lower-case
         (clojure.string/split (slurp dict-fn)
                               #"\n")))))

(defn combine [words anagrams]
  (for [word words, anagram anagrams]
    (conj anagram word)))

(with-test
  (defn filter-dict [bag dict]
    (filter
     (fn [entry]
       (subtract-bags
        bag
        (first entry)))
     dict))
  (is (= 25 (count (filter-dict (bag "Ernest") (dict))))))
(test #'filter-dict)

(with-test
  (defn anagrams [bag dict]
    (loop [subdict (filter-dict bag dict)
           return-value '()]
      (if (empty? subdict) return-value
          (let [[key words] (first subdict)
                smaller-bag (subtract-bags bag key)]
            (if (not smaller-bag) (recur (rest subdict) return-value)
                (if (bag-empty? smaller-bag) (recur (rest subdict) (concat return-value (map list words)))
                    (let [from-smaller-bag (anagrams smaller-bag subdict)]
                      (recur (rest subdict)
                             (if (not (seq from-smaller-bag))
                               return-value
                               (concat return-value (combine words from-smaller-bag)))))))
            ))))
  (is (= '(("dog") ("GOD"))
         (anagrams (bag "dog") {(bag "dog") #{"dog" "GOD"}}))))


(test #'anagrams)

(defn -main [& args]

  (let [b (bag (apply str args))]

    (binding [*out* *err*]
      (println "Filtering dictionary."))

    (let [d (filter-dict b (dict))]

      (binding [*out* *err*]
        (println (format "Pruned dictionary now has %s words." (apply + (map count (map second d))))))

      (let [result  (anagrams b d)]
        (binding [*out* *err*]
          (println (format "%s anagrams of '%s'."
            (count result)
                           (apply str args))))
        (doseq [an (sort-by #(format "%02d%s" (count %) %) result)]
          [(println an)])))

    ))
