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

anagrams (Bag, Dict)->
    pairfold:pairfold (
      fun (Dict, Accum) ->
              [{ThisKey, TheseWords}|_] = Dict,
              SmallerBag = bag:subtract (Bag, ThisKey),

              case SmallerBag of
                  0 -> Accum;
                  1 -> [[W] || W <- TheseWords] ++ Accum;
                  _ ->
                      FromSmallerBag = anagrams (SmallerBag, Dict),
                      case FromSmallerBag of
                          [] -> Accum;
                          _  -> combine (TheseWords, FromSmallerBag) ++ Accum
                      end
              end
      end,
      Dict).

tinydict () ->
    [
     {bag:bag ("cat"), ["cat"]},
     {bag:bag ("dog"), ["dog", "god"]},
     {bag:bag ("at"), ["at"]}
    ].

main ([])->
    io:format ("Dude.  How 'bout an argument?~n");
main ([CriterionString])->
    B = bag:bag (CriterionString),

%%%     Filtered = filter (B, 
%%%                        wheedledict:snarf ()),

    Filtered = tinydict (),
    
    io:format ("Dictionary has ~p entries that include ~p.~n",
               [length (Filtered), CriterionString]),
    io:format ("~p~n", [anagrams (B, Filtered)]);
main ([CriterionString|Crap]) ->
    io:format ("(ignoring ~p ...)", [Crap]),
    main ([CriterionString]).
