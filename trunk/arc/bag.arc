;; -*-arc-*-
(def bag (string)
     (sort
      <
      (keep   [and (>= _ #\a)
                   (<= _ #\z)]
              (downcase string))))

(def subtract (top bottom)
     (catch
      (let difference ""
        (while (isnt bottom "")
               (if (is top "")    (throw nil)
                   (> (top 0) (bottom 0)) (throw nil)
                   (is (top 0) (bottom 0)) (do (= top    (subseq top 1))
                                               (= bottom (subseq bottom 1)))
                   (do
                       (zap [ + _ (string (top 0))] difference)

                       (= top (subseq top 1)))))
        (+ difference top)
        )))

(prn (bag "Cat"))

