-module (anagrams).
-compile (export_all).

filter (_Bag, [])->
    [];
filter (Bag, [{Candidate, Words}|T]) ->
    case bag:subtract (Candidate, Bag) of 
        0 ->
            filter (Bag, T);
        _ ->
            [{Candidate, Words} | filter (Bag, T)]
    end.
    
main ([])->
    io:format ("Dude.  How 'bout an argument?~n");
main ([CriterionString])->
    Filtered = filter (bag:bag (CriterionString), 
                       wheedledict:snarf ()),
    io:format ("Dictionary has ~p words that include ~p: ~p.~n",
               [length (Filtered),
                CriterionString,
                Filtered]);
main ([CriterionString|Crap]) ->
    io:format ("(ignoring ~p ...)", [Crap]),
    main ([CriterionString]).
