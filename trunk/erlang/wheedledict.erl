-module (wheedledict).
-compile (export_all).

snarf ()->
    {ok, S} = file:open ("/usr/share/dict/words", read),
    Lines = more (S, []),
    file:close (S),
    io:format ("Read ~p lines.~n", [length (Lines)]).

more (S, SoFar)->
    case io:get_line (S, '') of
        eof ->
            lists:reverse (SoFar);
        Line ->
            more (S, [Line|SoFar])
    end.
