(def bag (string)
     (sort
      <
      (keep   [and (>= _ #\a)
                   (<= _ #\z)]
              (downcase string))))
(prn (bag "Cat"))

