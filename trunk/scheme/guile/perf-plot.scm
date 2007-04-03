(use-modules (ice-9 pretty-print)
             (anagrams))

;; Do a bunch of anagrams, with different sized inputs; measure the
;; time they take, and also the number of returned anagrams.  Then
;; display all that info in a nice graph.

;; Our first run will take the first character of this string; the
;; second will take the first two characters, and so on.
(define *ultimate-string* "ErnestHemingway")

(define (sym->filename s)
  (string-append
   "plot-me-"
   (symbol->string s)))

;; (((anagrams . 2) (time . 4.89e-4)) ((anagrams . 0) (time . 5.34e-4)))
(define stats-alists
  (let loop ((string (substring *ultimate-string* 0 1))
             (stats '()))
    (if (< (string-length string) (string-length *ultimate-string*))
        (let* ((start-time (get-internal-real-time))
               (output (all-anagrams string))
               (duration  (exact->inexact (/ (- (get-internal-real-time) start-time) internal-time-units-per-second))))

          (let ((ofile-name (string-append "outputs/" string)))
            (call-with-output-file ofile-name
              (lambda (p)
                (format p ";; ~a seconds~%" duration)
                (for-each (lambda (an)
                            (format p "~s~%" an))
                          output))))
          (loop (substring *ultimate-string* 0 (+ 1 (string-length string)))
                (cons `((anagrams . ,(length output))
                        (time     . ,duration))
                      stats)))
      (reverse stats))))

;; ((anagrams 2 0) (time 4.89e-4 5.34e-4))
(define stats-as-lists
  (map
   (lambda (thing)
     (cons thing
           (map (lambda (alist)
                  (assq-ref alist thing)) stats-alists)))
   (map car (car stats-alists))))

;; write out the lists into individual files suitable for being
;; snarfed by `graph'.
(for-each 
 (lambda (bunch-o-data)
   (let* ((y-axis-name (car bunch-o-data))
          (output-file-name (sym->filename y-axis-name)))
     (call-with-output-file 
         output-file-name
       (lambda (outp)
         (let loop ((data-written 0)
                    (data (cdr bunch-o-data)))
           (if (not (null? data))
               (begin
                 (format outp "~a ~a~%"
                         
                         ;; The first datum corresponds to one letter,
                         ;; not to zero letters.
                         (+ 1 data-written)
                         
                         (car data))
                 (loop (+ 1 data-written)
                       (cdr data)))))))
     
     (format #t "Wrote file ~a~%" output-file-name)))
 
 stats-as-lists)

(let ((graph-output-filename "really-plot-me")
      (child-pid (primitive-fork)))
  (if (zero? child-pid)
      (call-with-output-file 
          graph-output-filename
        (lambda (outp)
          (move->fdes outp 1)           ;redirect stdout
          (apply execlp
                 "graph"
                 "graph"
                 `( "-l" "Y" "-X" "letters"
                    ,@(apply append 
                             (map (lambda (dataset-name)
                                    `("-Y" ,(symbol->string dataset-name) ,(sym->filename dataset-name)))
                                  (map car stats-as-lists)))
                    ))))
    (if (zero? (status:exit-val (cdr (waitpid child-pid))))
        (begin
          (system* "plot" "-T" "X"  graph-output-filename )
          (format #t "plottable output is in ~s~%" graph-output-filename)
          (for-each (lambda (sym)
                      (delete-file (sym->filename sym)))
                    (map car stats-as-lists)))
      (error "graph failed"))))
