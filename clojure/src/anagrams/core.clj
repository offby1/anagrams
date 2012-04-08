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
         (update-in acc (list (bag elt)) #(clojure.set/union #{elt} %)))
       (hash-map)
       words))))

  (is (= '([5593M #{"dog"}] [710M #{"tac" "cat"}]) (dict-from-strings (list "dog" "dog" "cat" "tac"))))
  )
(test #'dict-from-strings)

(defn dict []
  (prof :dict-from-strings
   (dict-from-strings
    (prof :filter
     (filter
      word-acceptable?
      (map clojure.string/lower-case
           (clojure.string/split (prof :slurp (slurp dict-fn))
                                 #"\n")))))))

(defn combine [words anagrams]
  (apply concat (map (fn [word]
                       (map (fn [an]
                              (cons word an))
                            anagrams))
                     words)))

(with-test
  (defn anagrams-internal [bag dict]
    (loop [rv '()
           dict dict]
      (if (not (seq dict))
        rv
        (let [key (first (first dict))
              words (second (first dict))
              smaller-bag (subtract-bags bag key)]
          (recur
           (if (not smaller-bag)
             rv
             (concat
              (if (bag-empty? smaller-bag)
                (map list words)
                (combine
                 words
                 (anagrams-internal
                  smaller-bag
                  (filter
                   (fn [entry]
                     (subtract-bags
                      smaller-bag
                      (first entry)))
                   dict))))
              rv))

           (rest dict))))))
  (is (= '(("GOD") ("dog")) (anagrams-internal (bag "dog") {(bag "dog") #{"dog" "GOD"}}))))
(test #'anagrams-internal)

(defn -main [& args]
  (profile
   (let [result (anagrams-internal (bag (apply str args))  (dict))]
     (printf "%d anagrams of %s\n" (count result) args)
     (doseq [an result]
       [(printf "%s\n" an)]))))
