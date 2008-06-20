-module (do_coverage).
-compile (export_all).

main (_)->
    {ok, Module} = cover:compile (anagrams),
    anagrams:main (["dog"]),
    {ok, Answer} = cover:analyse (Module, calls, line),
    io:format ("And the answer is ~p~n", [Answer]).
