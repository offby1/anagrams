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

flatmap (Func, List) ->
    {_List2, Acc1} = lists:mapfoldl (fun (Item, Accum)-> {Item, Func (Item) ++ Accum} end, [], List),
    Acc1.

combine (Words, Anagrams) ->
    flatmap(fun (W) ->
                    lists:map (fun (An) -> [W | An] end, Anagrams) end,
            Words).

anagrams (_Bag, [], _Accum) ->
    [];
anagrams (Bag, [OneEntry|RestOfDict] = Dict, Accum)->
    {ThisKey, TheseWords} = OneEntry,
    SmallerBag = bag:subtract (Bag, ThisKey),
    case SmallerBag of
        0 ->
            anagrams (Bag, RestOfDict, Accum);
        1 ->
            anagrams (Bag, RestOfDict, Accum ++ [[W] || W <- TheseWords]);
        _ ->
            anagrams (Bag, RestOfDict, Accum ++
                      combine (TheseWords,
                               anagrams (SmallerBag, 
                                         filter (SmallerBag, Dict),
                                         Accum)))
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
    io:format ("Dictionary has ~p words that include ~p.~n",
               [length (Filtered), CriterionString]),
    io:format ("~p~n", anagrams (B, Filtered, []));
main ([CriterionString|Crap]) ->
    io:format ("(ignoring ~p ...)", [Crap]),
    main ([CriterionString]).
