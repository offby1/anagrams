-module (anagrams).
-compile (export_all).

filter (CriterionBag, Dict) ->
    lists:filter (fun ({Candidate, _}) ->
                          bag:subtract (CriterionBag, Candidate) > 0
                  end,
                  Dict).

combine (Words, Anagrams) ->
    RV = lists:flatmap(fun (W) ->
                          lists:map (fun (An) -> [W | An] end, Anagrams) end,
                  Words),
%%%     io:format ("Combining ~p with a list ~p long, yielding ~p~n",
%%%                [Words, length (Anagrams), RV]),
    RV.

anagrams (_Bag, [], _Accum) ->
    io:format ("Ran outta dictionary with leftover bag ~p~n", [_Bag]),
    _Accum;
anagrams ([], _Dict, Accum) ->
    io:format ("Yay! Ran outta bag with leftover dict; returning ~p~n",
               [Accum]),
    Accum;
anagrams (Bag, [OneEntry|RestOfDict] = Dict, Accum)->
    {ThisKey, TheseWords} = OneEntry,
    SmallerBag = bag:subtract (Bag, ThisKey),
%%%     io:format ("so far ~p; Bag ~p minus ThisKey ~p (words: ~p) equals ~p~n",
%%%               [Accum, Bag, ThisKey, TheseWords, SmallerBag]),
    case SmallerBag of
        0 ->
            anagrams (Bag, RestOfDict, Accum);
        1 ->
            anagrams (Bag, RestOfDict, Accum ++ [[W] || W <- TheseWords]);
        _ ->
            FromSmallerBag = anagrams (SmallerBag, 
                                       Dict,
                                       Accum),
            case FromSmallerBag of
                [] -> anagrams (Bag, RestOfDict, Accum);
                _  -> anagrams (Bag, RestOfDict, Accum ++ combine (TheseWords, FromSmallerBag))
            end
    end.

tinydict () ->
    [
    {bag:bag ("dog"), "dog", "god"}
    ].

main ([])->
    io:format ("Dude.  How 'bout an argument?~n");
main ([CriterionString])->
    B = bag:bag (CriterionString),
    Filtered = filter (B, 
                       wheedledict:snarf ()),
    io:format ("Dictionary has ~p entries that include ~p.~n",
               [length (Filtered), CriterionString]),
    io:format ("~p~n", [anagrams (B, Filtered, [])]);
main ([CriterionString|Crap]) ->
    io:format ("(ignoring ~p ...)", [Crap]),
    main ([CriterionString]).
