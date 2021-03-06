-module(bag).
-export ([bag/1, subtract/2]).
-define (Primes, {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101}).

toprime (L) ->
    if (L >= $a) and (L =< $z) ->
            element (L - $a + 1, ?Primes);
       true ->
            1
    end.

bag (Letters) ->
    lists:foldl (fun (Letter, Result)->
                         toprime (Letter) * Result
                 end,
                 1,
                 string:to_lower (Letters)).

subtract (Top, Bottom) ->
    Rem  = Top rem Bottom,
    if
        (Rem =:= 0) ->
            Top div Bottom ;    
        true -> 0
    end.
