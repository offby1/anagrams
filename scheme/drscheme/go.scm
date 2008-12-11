#!/usr/local/bin/mred -qu

(module go mzscheme
  (require (prefix srfi-19- (lib "19.ss" "srfi"))
           "anagrams.scm")
  (define start-time (srfi-19-current-time))
  (define rv (all-anagrams
              (vector-ref (current-command-line-arguments) 0)
              "/usr/share/dict/words"
              (lambda args ())))
  (display rv)
  (flush-output (current-output-port))
  (flush-output (current-error-port))
  (define stop-time (srfi-19-current-time))
  (fprintf (current-error-port)
           "~s anagrams took ~s seconds~%"
           (length rv)
           (srfi-19-time-second (srfi-19-time-difference stop-time start-time))))