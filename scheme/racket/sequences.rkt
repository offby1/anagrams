#lang racket
(module+ test
  (require rackunit))

(provide in-cdrs)
(define (in-cdrs seq)
  (make-do-sequence
   (lambda ()
     (values
      ;; pos->element(s)
      (lambda (seq)
        (values (first seq)
                seq))

      ;; next-pos
      cdr

      ;; initial position
      seq

      ;; not-last?  pos->bool
      (compose not null?)

      ;; not-last?  element(s)->bool
      (const #t)

      ;; not-last? (-> pos elt ... bool)
      (const #t)))))

(module+ test
  (check-equal?
   (for/list ([(elt rest) (in-cdrs (list 1 2 3))])
     (list elt rest))
   '((1 (1 2 3))
     (2 (2 3))
     (3 (3)))))
