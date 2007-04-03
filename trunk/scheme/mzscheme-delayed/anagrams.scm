#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec mzscheme -M errortrace -qu "$0" ${1+"$@"}
|#

(module anagrams
mzscheme
(require "dict.scm"
         "bag.scm"
         (lib "trace.ss")
         (only (lib "1.ss"  "srfi") filter find take)
         (only (lib "list.ss") sort))

(define (all-anagrams-internal bag dict level)

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
                        (map (lambda (w)
                               (cons (list w)
                                     (lambda () '())))
                             words)
                      (list
                       (cons
                        words
                        (lambda ()
                          (all-anagrams-internal
                           smaller-bag
                           (filter (lambda (entry)
                                     (subtract-bags
                                      smaller-bag
                                      (car entry)))
                                   dict)
                           (add1 level)
                           )))))))
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

(define (dn x)
  (display x)
  (newline))

;; (multi-assoc "foo" '(("foo" "bar") . 'golly)) => 'golly
(define (multi-assoc obj alist)
  (cond
   ((null? alist)
    #f)
   ((member obj (caar alist))
    (car alist))
   (else
    (multi-assoc obj (cdr alist)))))

(define in-bag (bag
                (vector-ref
                 (current-command-line-arguments)
                 0)))
(define dict (init in-bag (find file-exists? '("/usr/share/dict/words"
                                               "/usr/share/dict/american-english"))))

(let loop ((in-bag in-bag)
           (result (sort
                    (all-anagrams-internal
                     in-bag
                     dict
                     0
                     )
                    (lambda (e1 e2)
                      (> (string-length (caar e1))
                         (string-length (caar e2)))))))

  (when (not (null? result))
    (begin
      (fprintf (current-error-port)
               "Words that can be made from ~s:~%"
               (->string in-bag))
      (for-each dn result)
      (newline)
      (let get-input ()
        (display "Enter a word from the list: ")
        (let ((choice (multi-assoc (read-line) result)))
          (if choice
              (loop (bag (caar choice))
                    ((cdr choice)))
            (get-input))
          ))))))

