(defpackage anagrams
  (:use :common-lisp))
(in-package :anagrams)
(declaim (optimize speed))

(mapcar #'(lambda (basename)
            (load (concatenate 'string basename
                               #+cmu  ".x86f"
                               #+sbcl ".fasl"
                               #+clisp ".fas"
                               )))
        `("numeric-bag"
          ;"bag"
          "dict"
          "anagrams"))



(anagrams  "Ernest Hemingway")
(format t "Done!~%" )

(in-package :common-lisp-user)
(quit)
