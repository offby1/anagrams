-module (do_profile).
-compile (export_all).

main (String)->
    Apple = fprof:apply (anagrams,
                         main,
                         [String]),
    io:format ("apply->~p~n", [Apple]),
    Whut = fprof:profile(),
    io:format ("profile->~p~n", [Whut]),
    Annie = fprof:analyse ([{dest, []}]),
    io:format ("analyse->~p~n", [Annie]).
