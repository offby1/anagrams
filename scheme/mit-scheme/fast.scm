;;; fast.scm - slightly less slow version
;;; http://polyglot-anagrams.googlecode.com/svn/trunk/stats

(declare (usual-integrations))

;;; Bags

;; Return an object that describes all the letters in S,
;; without regard to order.

(define (bag s)
  (let loop ((chars-to-examine (string-length s))
             (product 1))
    (if (< 0 chars-to-examine)
        (loop (- chars-to-examine 1)
              (* product
                 (char->factor (string-ref s (- chars-to-examine 1)))))
        product)))

(define char->factor
  (let ((a-code (char->integer #\a)))
    (lambda (c)
      (if (char-set-member? char-set:anagram c)
          (vector-ref primes (- (char->integer (char-downcase c)) a-code))
          1))))

(define primes (list->vector (stream-head prime-numbers-stream 26)))

(define (subtract-bags b1 b2)
  (if (bag-empty? b2) (error "Hey! Don't subtract the empty bag."))
  (let ((q+r (integer-divide b1 b2)))
    (and (zero? (integer-divide-remainder q+r))
         (integer-divide-quotient q+r))))

(define (bag-empty? b) (= 1 b))

;;; Character Sets

(define char-set:anagram
  (char-set-union (string->char-set "abcdefghijklmnopqrstuvwxyz")
                  (string->char-set "ABCDEFGHIJKLMNOPQRSTUVWXYZ")))
(define char-set:vowels (string->char-set "aeiouyAEIOUY"))
(define char-set:others (char-set-invert char-set:anagram))

;;; Dictionary

(define (word-acceptable? string)
  (and (not (string-null? string))
       (not (string-find-next-char-in-set string char-set:others))
       (string-find-next-char-in-set string char-set:vowels)
       (or (< 1 (string-length string))
           (string-ci=? "i" string)
           (string-ci=? "a" string))))

(define (snarf-dictionary word-bag verbose filename)
  (let ((hash-table (make-eqv-hash-table))
        (word-list #f)
        (hash-list #f)
        (bags-list #f))

    (if verbose (write-message "Reading dictionary"))
    (set! word-list (read-dict "../../words"))

    (if verbose (write-message "Pruning dictionary"))
    (set! word-list (keep-matching-items! word-list word-acceptable?))

    (if verbose (write-message "Computing bags"))
    (set! hash-list (map (lambda (word) (bag word)) word-list))

    (if verbose (write-message "Building table"))
    (for-each (lambda (word hash)
                (hash-table/put! hash-table
                                 hash
                                 (cons word
                                       (hash-table/get hash-table
                                                       hash
                                                       '()))))
              word-list
              hash-list)

    (if verbose (write-message "Drinking coffee"))
    (set! bags-list (hash-table->alist hash-table))

    (if verbose (write-message "Filtering table"))
    (set! bags-list (keep-matching-items! bags-list
                      (lambda (entry)
                        (subtract-bags word-bag (car entry)))))

    (if verbose (write-message "Kept words: " (length bags-list)))

    (if (and filename verbose) (write-message "Dumping words"))
    (if filename
        (with-output-to-file filename
          (lambda ()
            (write (sort bags-list (lambda (p1 p2) (< (car p1) (car p2))))))))

    bags-list))

(define (write-message . message)
  (fresh-line)
  (for-each display message))

(define (read-file-into-string pathname)
  (call-with-input-file pathname
    (lambda (port)
      (let ((n-bytes ((port/operation port 'LENGTH) port)))
        (let ((bytes (string-allocate n-bytes)))
          (let loop ((start 0))
            (if (< start n-bytes)
                (let ((n-read (read-substring! bytes 0 n-bytes port)))
                  (if (= n-read 0)
                      (error "Failed to read complete file:"
                             (+ start n-read) n-bytes pathname))
                  (loop (+ start n-read)))))
          bytes)))))

(define (read-dict pathname)
  (burst-string (string-downcase (read-file-into-string pathname))
                #\newline
                #t))

;;; Anagrams

(define (anagrams word #!optional verbose? dump?)
  (let ((word-bag (bag word))
        (filename (and (default-object? dump?)
                       (string-append "pruned-"
                                      (string-replace word #\space #\_))))
        (verbose (default-object? verbose?)))
    (let ((pruned
           (snarf-dictionary word-bag verbose filename)))
      (if verbose
          (write-message "Computing anagrams"))
      (all-anagrams-internal word-bag pruned))))

(define (all-anagrams-internal bag dict)
  (let ((rv '()))
    (let loop ((dict dict))
      (if (pair? dict)
          (let ((key   (caar dict))
                (words (cdar dict)))
            (let ((smaller (subtract-bags bag key)))
              (if smaller
                  (if (bag-empty? smaller)
                      (set! rv (append! (map list words) rv))
                      (let* ((pruned
                              (keep-matching-items dict
                                (lambda (entry)
                                  (subtract-bags smaller (car entry)))))
                             (anagrams
                              (all-anagrams-internal smaller pruned)))
                        (if (pair? anagrams)
                            (set! rv (append! (combine words anagrams)
                                              rv)))))))
            (loop (cdr dict)))
          rv))))

(define (combine words anagrams)
  ;; Given a list of WORDS, and a list of ANAGRAMS, creates a new
  ;; list of anagrams, each of which begins with one of the WORDS.
  (mapcan (lambda (word)                ;mapcan aka append-map! (srfi-1)
            (map (lambda (phrase)
                   (cons word phrase))
                 anagrams))
          words))

;;; Benchmarking

(define (test w)
  (gc-flip)
  (show-time
   (lambda () (write-message ";" (length (anagrams w #f)) " anagrams. "))))

(define (run-test1) (test "hemingway"))
(define (run-test2) (test "st hemingway"))
(define (run-test3) (test "est hemingway"))
(define (run-test4) (test "Ernes Hemingway"))
(define (run-test5) (test "Ernest Hemingway"))

(define (run-tests)
  (run-test1)
  (run-test2)
  (run-test3)
  (run-test4)
  (run-test5))
