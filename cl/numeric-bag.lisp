(in-package :anagrams)
;; I tried arranging these in order of frequency, so that the most
;; frequent letters (i.e., `e') have the smallest primes (like Morse
;; code).  Turned out it didn't make the program any faster.
(defparameter *primes* #(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))
(declaim (type (simple-array  fixnum (26))  *primes*))
(defun char_to_index (c)
  (declare  (type character c))
  (- (char-code c)
     (char-code #\a)))

(defun index_to_char (i)
  (declare (type fixnum i))
  (code-char (+ i (char-code #\a))))

(defun bag (s)
  (declare (type simple-string s))
  (let ((return-value 1))
    (dotimes (chars-processed (length s) return-value)
      (let ((this-char (char-downcase (aref s chars-processed))))
        (when (and
               (alpha-char-p this-char)
               (<= (char-code #\a)
                   (char-code this-char)
                   (char-code #\z)))
          (setf return-value 
                (* (the integer return-value)
                   (the (unsigned-byte 32) (aref   *primes* (char_to_index this-char)))))
          )))
    
    return-value))

(defun subtract-bags (minuend subtrahend)
  (declare (type integer minuend))
  (declare (type integer subtrahend))
  
  (multiple-value-bind (q r)
      (floor  minuend subtrahend)
    (if (zerop r)
        q
        nil)))

(defun bag-emptyp (b)
  (declare (type integer b))
  (= 1 b))

(defun bags-equalp (b1 b2) (= b1 b2))


;; unit tests
(assert (bag-emptyp (bag "")))
(assert (bags-equalp (bag "HEY")
                     (bag "hey")))
(assert (bags-equalp (bag "  hey   you   ")
                     (bag "heyyou")))
(assert (bags-equalp (bag "Fred's")
                     (bag "freds")))
(assert (not (bag-emptyp (bag "a"))))
(assert (bags-equalp (bag "abc")
                     (bag "cba")))

(let ((cant-be-done (subtract-bags (bag "a")
                                   (bag "b"))))
  (assert (not cant-be-done)))

(assert (not (subtract-bags  (bag "een")
                             (bag "eg"))))

(assert (not (bags-equalp (bag "abc")
                          (bag "bc"))))

(assert (bags-equalp (bag "a")
                     (subtract-bags (bag "ab")
                                    (bag "b"))))


(assert (not (subtract-bags (bag "a")
                            (bag "aa"))))

(assert (not (subtract-bags (* 100 101 110) (* 39 115))))

(let ((empty-bag (subtract-bags (bag "a")
                                (bag "a"))))
  (assert (bag-emptyp empty-bag))
  (assert empty-bag))

(format t "bag tests passed.~%")
