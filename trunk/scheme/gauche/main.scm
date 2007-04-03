#!/usr/bin/env gosh

(use anagrams)
(use srfi-13)

(define (main args)
  (let* ((input-string (string-join (cdr args) " "))
         (result  (anagrams input-string)))

    (display (length result))
    (display " anagrams of ")
    (write input-string)
    (display ":")
    (newline)
    (for-each (lambda (a)
                (display a)
                (newline))
              result)
    )
  (exit 0))

