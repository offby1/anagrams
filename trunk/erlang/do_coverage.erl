-module (do_coverage).
-compile (export_all).

main (_)->
    lists:map (fun (ModuleName) -> 
                       {ok, Module} = cover:compile (ModuleName)
               end,
               [anagrams, bag, wheedledict]),
    anagrams:main (["Ernest"]),
    {ok, Answer} = cover:analyse (anagrams, calls, line),
    io:format ("And the answer is ~p~n", [Answer]).
