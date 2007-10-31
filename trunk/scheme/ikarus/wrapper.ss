(import (rnrs)
        (dict)
        (ikarus))

(printf "Well, that was exciting.~%")
(printf "Let's try something for real: ~s~%"
        (init
         710                            ;"cat"
         "../../words.utf8"))
