-module (anagrams).
-compile (export_all).
-import (bag, [subtract/2]).
-import (wheedledict, [snarf/0]).

filter (_Bag, [])->
    [];
filter (Bag, [{Candidate, Words}|T]) ->
    case subtract (Candidate, Bag) of 
        0 ->
            filter (Bag, T);
        _ ->
            [{Candidate, Words} | filter (Bag, T)]
    end.
    
main ([])->
    io:format ("Dude.  How 'bout an argument?~n");
main ([CriterionString])->
    Filtered = filter (bag:bag (CriterionString), 
                       snarf ()),
    io:format ("Dictionary has ~p words that include ~p.~n", [length (Filtered), CriterionString]);
main ([CriterionString|Crap]) ->
    io:format ("(ignoring ~p ...)", [Crap]),
    main ([CriterionString]).
