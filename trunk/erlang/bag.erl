-module(bag).
-export ([bag/1, subtract/2]).

lowercase (L) ->
    if (L >= $A) and (L =< $Z) ->
            L - $A + $a;
       true  ->
            L
    end.

toprime (L) ->
    Primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101},
    Lower = lowercase (L),
    if (Lower >= $a) and (Lower =< $z) ->
            element (Lower - $a + 1, Primes);
       true ->
            1
    end.

bag ([]) ->
    1;
bag ([Letter|Rest]) ->
    toprime (Letter) * bag (Rest).

subtract (Top, Bottom) ->
    Rem  = Top rem Bottom,
    if
        (Rem =:= 0) ->
            Top div Bottom ;    
        true -> 0
    end.
