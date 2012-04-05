(ns anagrams.test.core
  (:use [anagrams.core])
  (:use [clojure.test]))

(deftest accurate
  (let [d (dict)]
    (is (= 72794 (apply + (map count (vals d)))))
    (is (= 66965 (count d)))
    (is (= 19 (count (aai (bag "ernest") d))))
    ))
