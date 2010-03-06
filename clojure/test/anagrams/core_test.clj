(ns anagrams.core-test
  (:use [anagrams.core] :reload-all)
  (:use [clojure.test]))

(deftest accurate
  (is (= 72794 (apply + (map count (vals dict)))))
  (is (= 66965 (count dict)))
  (is (= 19 (count (aai (bag "ernest") dict)))))