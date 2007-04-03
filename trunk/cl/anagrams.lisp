(in-package :anagrams)

(defvar *dict*)
(defvar *verbose* nil)

(defun combine (these-words more-anagrams)
  (mapcan #'(lambda (word-to-prepend)
              (mapcar #'(lambda (phrase) 
                          (cons word-to-prepend phrase))
                      more-anagrams))
          these-words))

(defmacro while (test &rest body)
  `(do ()
       ((not ,test))
     ,@body))

(defun prune (bag dict)
  (remove-if
   #'(lambda (entry) (not (subtract-bags bag (car entry))))
   dict))

(defun anagrams-internal (bag dict limit)
  (let ((rv ())
        (length 0))
    (while (and (or (not limit)
                    (> limit length))
                (not (null dict)))
      (let* ((entry (car dict))
             (this-bag (car entry))
             (these-words (cdr entry))
             (smaller-bag (subtract-bags bag this-bag)))
        (when smaller-bag
          (if (bag-emptyp smaller-bag)
              (let ((combined (mapcar #'list these-words)))
                (setf rv (nconc rv combined))
                (incf length (length combined)))
              (let ((more-anagrams (anagrams-internal
                                    smaller-bag
                                    (prune smaller-bag dict)                                 
                                    limit)))
                (when more-anagrams
                  (let ((combined (combine these-words more-anagrams)))
                    (setf rv (nconc rv combined))
                    (incf length (length combined))))))))
      (setf dict (cdr dict)))
    rv))

(defun anagrams (string &optional limit)
  (let ((b  (bag string)))
    (init b)
    (let ((result (anagrams-internal b (prune b *dict*) limit)))
      (prog1 result
        (format *error-output* ";; ~a anagrams of ~a~%" (length result)
                string)))))
