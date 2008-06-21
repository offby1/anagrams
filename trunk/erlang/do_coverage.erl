-module (do_coverage).
-compile (export_all).

main (_)->
    eprof:profile([self ()],
                  anagrams,
                  main,
                  [["Ernest Hemingway"]]),
    eprof:analyse ().
