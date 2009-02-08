;; I dunno.
(use 'clojure.contrib.str-utils)

(def dict-fn (str (System/getProperty "user.home") "/doodles/anagrams/words"))
(def in (-> dict-fn java.io.FileReader. java.io.BufferedReader. ))
(def all-english-words  (re-split #"\n" (slurp dict-fn)))
