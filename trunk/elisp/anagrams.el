(eval-when-compile (require 'cl))

;; bag stuff
(defun anagrams-bag-sort-string (s) (concat (sort (append s nil) '<)))

(defun anagrams-bag-empty? (b) (and (stringp b) 
                                    (zerop (length b))))

(defun anagrams-bag (s) 
  (anagrams-bag-sort-string 

   ;; split-string filters out non-letters.
   (apply 'concat  (split-string (downcase s) "[^[:alpha:]]+"))
   
           ))

(defun anagrams-bags=? (s1 s2) (string= s1 s2))


;;           
;;           
;;                   m i n u e n d
;;           - s u b t r a h e n d
;;           ---------------------
;;             d i f f e r e n c e
;;           
;;           

(defun anagrams-subtract-bags (minuend subtrahend)
  (let ((min (append minuend nil))
        (sub (append subtrahend nil))
        (diff nil))

    ;; walk down both strings, as long as their first characters are
    ;; the same.
    (while (and
            min
            sub
            (= (car min)
               (car sub)))
      (setq min (cdr min))
      (setq sub (cdr sub)))

    (cond

     ;; if we ran out of subtrahend we're done: the difference is
     ;; what's left of the minuend.
     ((not sub)
      (concat (reverse diff) min))

     ;; if we ran out of minuend., we're done: the subtraction can't
     ;; happen.
     ((not min)
      nil)

     ;; eg (> ?\w ?\b)

     ;; similarly, if the current letter of the subtrahend precedes
     ;; that of the minuend, that means the subtraction can't happen,
     ;; since we encounter the letters in order.  In our example,
     ;; we've already skipped all the `b's in the minuend, and yet
     ;; there's at least one remaining `b' in the subtrahend.
     ((> (car min) (car sub))
      nil)

     (t
      ;; eg (?\f) and (?\x)
      
      ;; walk along the minuend until its first character matches the
      ;; subtrahend.
      (while (and min (< (car min) (car sub)))
        (setq diff (cons (car min) diff))
        (setq min (cdr min)))

      ;; again, if we ran out, we're done.

      (when min
        (let ((furthur (anagrams-subtract-bags min sub)))
          (and furthur
               (concat (reverse diff) furthur))))))))



;;; bag unit tests

;; Notes about bags in general:

;; creating a bag from a string needn't be all that fast, since we'll
;; probably only do it a few thousand times per application (namely,
;; reading a dictionary of words), whereas subtracting bags needs to
;; be *really* fast, since I suspect we do this O(n!) times where n is
;; the length of the string being anagrammed.

(assert (anagrams-bag-empty? (anagrams-bag "")))
(assert (anagrams-bags=? (anagrams-bag "HEY")
                (anagrams-bag "hey")))
(assert (anagrams-bags=? (anagrams-bag "  hey   you   ")
                (anagrams-bag "heyyou")))
(assert (anagrams-bags=? (anagrams-bag "Fred's")
                (anagrams-bag "freds")))
(assert (not (anagrams-bag-empty? (anagrams-bag "a"))))
(assert (anagrams-bags=? (anagrams-bag "abc")
                (anagrams-bag "cba")))

(let ((cant-be-done (anagrams-subtract-bags (anagrams-bag "a")
                                            (anagrams-bag "b"))))
  (assert (not cant-be-done))
  (assert (not (anagrams-bag-empty? cant-be-done))))

(assert (not (anagrams-subtract-bags  (anagrams-bag "een")
                                      (anagrams-bag "eg"))))

(assert (not (anagrams-bags=? (anagrams-bag "abc")
                              (anagrams-bag "bc"))))

(assert (anagrams-bags=? (anagrams-bag "a")
                (anagrams-subtract-bags (anagrams-bag "ab")
                               (anagrams-bag "b"))))


(assert (not (anagrams-subtract-bags (anagrams-bag "a")
                            (anagrams-bag "aa"))))

(assert (not (anagrams-subtract-bags '(100 101 110) '(39 115))))

(let ((empty-bag (anagrams-subtract-bags (anagrams-bag "a")
                                (anagrams-bag "a"))))
  (assert (anagrams-bag-empty? empty-bag))
  (assert empty-bag))

(message "anagrams-bag tests passed.")

;; dictionary stuff
(defun anagrams-word-acceptable (w)
  (and (string-match "[aeiou]" w)
       (not (string-match "[^a-z]" w))
       (or (equal w "i")
           (equal w "a")
           (string-match ".." w))))

(defvar anagrams-dictionary-file-name "/usr/share/dict/words"
  "The name of the file that contains lots of words.")

(defun anagrams-select-dictionary (name)
  "Tell Emacs where the dictionary is, in case its original guess is wrong."
  (interactive "fEnter the dictionary's name: ")
  (setq anagrams-dictionary-file-name name))

(defvar anagrams-internal-dict-hash nil
  "A hash table that holds the dictionary from
  `anagrams-dictionary-file-name'.  Initialized (very slowly) upon
  first use.")

(defun anagrams-maybe-init-hash ()
  (when (not anagrams-internal-dict-hash)
    (with-temp-buffer
      (insert-file-contents anagrams-dictionary-file-name) 

      ;; do this _after_ insert-file-contents, since that function
      ;; might signal an error.
      (setq anagrams-internal-dict-hash  (make-hash-table :test 'equal :size 65000))

      (while (not (eobp))
        (let ((w (downcase (buffer-substring (line-beginning-position)
                                             (line-end-position)))))
          (if (anagrams-word-acceptable w)
              (let* ((b (anagrams-bag w))
                     (existing (gethash b anagrams-internal-dict-hash nil)))
                (if (not (member w existing))
                    (puthash b (cons w existing) anagrams-internal-dict-hash)))))
        (forward-line 1)
        (message  "Reading %s ... %3.3f %%" anagrams-dictionary-file-name  
                  (* 100
                     (/ (float (point))
                        (point-max)))))
      (message "Done"))
    ))


;; making anagrams
(defun anagrams-combine (words anagrams)
  (apply 'append (mapcar (lambda (word)
                           (mapcar (lambda (an)
                                     (cons word an))
                                   anagrams))
                         words)))

(defun anagrams-internal (bag dict exclusions level)
  (let ((rv))
    (mapc
     (lambda (entry)
       (let ((dict-bag (car entry))
             (words (cdr entry)))
       (if (not (member dict-bag exclusions))
           (let ((smaller-bag (anagrams-subtract-bags bag dict-bag)))
             (when smaller-bag
               (if (anagrams-bag-empty? smaller-bag)
                   (progn
                     (setq exclusions (cons dict-bag exclusions))
                     (let ((combined (mapcar 'list words)))
                       (setq rv (append rv combined))))
                 (let ((more (anagrams-internal smaller-bag dict exclusions (1+ level))))
                   (if more
                       (progn
                         (setq exclusions (cons dict-bag exclusions))
                         (let ((combined (anagrams-combine words more)))
                           (setq rv (append rv combined))))))))))))
     
     dict)
    rv))

(defun anagrams (s)
  "Print all the anagrams of string S."
  (interactive "sType a (short!) string: ")
  (condition-case file-error
      (progn
        (anagrams-maybe-init-hash)
      
        ;; now turn the hash into a list.
        (let ((pruned-dictionary)
              (b (anagrams-bag s)))
          (message "Pruning the dictionary ... ")
          (let ((entries-examined 0))
            (maphash (lambda (victim-bag words)
                       (when (anagrams-subtract-bags b victim-bag)
                         (setq pruned-dictionary
                               (cons (cons victim-bag 
                                           ;; alphabetize the words in
                                           ;; this entry, just so we
                                           ;; get a sense of progress
                                           ;; as we watch the anagrams
                                           ;; being generated.
                                           (sort words 'string<)
                                           )
                                     pruned-dictionary)))
                       (setq entries-examined (1+ entries-examined))
                       (message "Pruning the dictionary ... %d entries examined" entries-examined))
                     anagrams-internal-dict-hash))
  
          (message "Pruning the dictionary ... done")
          (princ (anagrams-internal b pruned-dictionary nil 0))))
    (error (message (format "%s.  %s." 
                            (error-message-string file-error)
                            (substitute-command-keys "Try \\[anagrams-select-dictionary].")))))
  )
