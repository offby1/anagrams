-module (test).
-compile (export_all).
-import (wheedledict, [snarf/0]).

main (_What) ->
    wheedledict:snarf ().
