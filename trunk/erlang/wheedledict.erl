-module (wheedledict).
-compile (export_all).
-import (bag, [bag/1]).

snarf ()->
    {ok, S} = file:open ("/usr/share/dict/words", read),
    Lines = more (S, fun (_Candidate) -> true end, []),
    file:close (S),
    io:format ("Read ~p lines.~n", [length (Lines)]),
    OFN = "snarfage",
    {ok, W} = file:open (OFN, write),
    io:format (W, "~p", [Lines]),
    io:format ("Wrote to ~p~n", [OFN]),
    file:close (W).

more (S, Criterion, SoFar)->
    case io:get_line (S, '') of
        eof ->
            lists:reverse (SoFar);
        Line ->
            Chars = lists:reverse (Line),
            case Chars of
                [$\n | T] ->
                    Word = lists:reverse (T),
                    case  Criterion (Word) of
                        true  -> more (S, Criterion, [{bag (Word), Word}|SoFar]);
                        false -> more (S, Criterion, [SoFar])

                    end
            end
    end.
