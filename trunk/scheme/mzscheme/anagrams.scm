#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec mzscheme -qu "$0" ${1+"$@"}
|#

(module anagrams
mzscheme
(require "dict.scm"
         "bag.scm"
         (only (lib "1.ss"  "srfi") filter find take)
         (lib "etc.ss"))

(provide all-anagrams)

(define (all-anagrams string dict-file-name )
  (let ((in-bag   (bag string)))
    (all-anagrams-internal
     in-bag
     (init in-bag dict-file-name)
     0
     display)))

(define (all-anagrams-internal bag dict level callback)

  (let loop ((rv '())
             (dict dict))

    (if (null? dict)
        rv

      (let* ((key   (caar dict))
             (words (cdar dict))
             (smaller-bag (subtract-bags bag key)))

        (loop
         (if smaller-bag
             (let ((new-stuff
                    (if (bag-empty? smaller-bag)
                        (map list words)
                      (combine
                       words
                       (all-anagrams-internal
                        smaller-bag
                        (filter (lambda (entry)
                                  (subtract-bags
                                   smaller-bag
                                   (car entry)))
                                dict)
                        (add1 level)
                        callback)))))
               (if (and (zero? level)
                        (procedure? callback)
                        (not (null? new-stuff)))
                   (for-each (lambda (w)
                               (callback w))
                             new-stuff))
               (append new-stuff rv))
           rv)
         (cdr dict))))))

(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (apply append (map (lambda (word)
                       (map (lambda (an)
                              (cons word an))
                            anagrams))
                     words)))

(let ((in (vector-ref
           (current-command-line-arguments)
           0)))
  (fprintf (current-error-port)
           "~a anagrams of ~s~%"
           (length
            (all-anagrams
             in
             (build-path (this-expression-source-directory) 'up 'up "words")
             ))
           in
           )
  (newline)))

