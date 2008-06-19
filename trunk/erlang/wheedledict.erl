-module (wheedledict).
-compile (export_all).
-import (bag, [bag/1]).

snarf ()->
    {ok, S} = file:open ("/usr/share/dict/words", read),
    Lines = more (S, []),
    file:close (S),
    io:format ("Read ~p lines.~n", [length (Lines)]),
    OFN = "snarfage",
    {ok, W} = file:open (OFN, write),
    io:format (W, "~p", [Lines]),
    io:format ("Wrote to ~p~n", [OFN]),
    file:close (W).

more (S, SoFar)->
    case io:get_line (S, '') of
        eof ->
            lists:reverse (SoFar);
        Line ->
            more (S, [{bag (Line), Line}|SoFar])
    end.
