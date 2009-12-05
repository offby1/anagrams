;; -*-lisp-*-

(use 'clojure.contrib.str-utils2)
(use 'clojure.set)

(defn contains-vowel? [w]
  (some #(clojure.contrib.str-utils2/contains? w %)
         (list "a" "e" "i" "o" "u" "y")))

(defn word-acceptable? [w]
  (let [w  (clojure.contrib.str-utils2/lower-case w)]
       (and
        (contains-vowel? w)
        (or (= w "i")
            (= w "a")
            (< 1 (count w))
            ))))

(def dict-fn (str (System/getProperty "user.home") "/stray-doodles/anagrams/words.utf8"))
(def in (-> dict-fn java.io.FileReader. java.io.BufferedReader. ))
(def all-english-words  (filter word-acceptable? (re-split #"\n" (slurp dict-fn))))

(def primes [2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101])
(defn bag [w]
  (apply * (map #(get primes (- (int %) (int \a)) 1) w)))

(def dict
     (let [h (hash-map)]
          (map (fn [word]
                   (update-in h (list word) #(clojure.set/union #{(bag word)} %)))
               all-english-words)))
