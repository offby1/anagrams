-module (wheedledict).
-compile (export_all).
-import (bag, [bag/1]).

snarf ()->
    {ok, S} = file:open ("/usr/share/dict/words", read),
    Dict = more (S, fun (_Candidate) -> true end, dict:new ()),
    file:close (S),
    io:format ("Stored ~p bags.~n", [dict:size (Dict)]),
    OFN = "snarfage",
    {ok, W} = file:open (OFN, write),
    io:format (W, "~p", [Dict]),
    io:format ("Wrote to ~p~n", [OFN]),
    file:close (W).

downcase (Char) ->
    case Char >= $A andalso Char =< $Z of 
            true -> Char - $A + $a;
        false -> Char
    end.

letters_only (String) ->
    [downcase(X) || X <- String,  (X >= $a andalso X =< $z) orelse (X >= $A andalso X =< $Z)].

adjoin (Item, [])->
    [Item];
adjoin (Item, [Item|Rest]) ->
    [Item|Rest];
adjoin (Item, [H|T]) ->
    [H|adjoin (Item, T)].

more (S, Criterion, SoFar)->
    case io:get_line (S, '') of
        eof ->
            SoFar;
        Line ->
            %% Strip trailing newlines by (*sigh*) reversing the
            %% string, matching, then re-reversing.
            Chars = lists:reverse (Line),
            case Chars of
                [$\n | T] ->
                    Word = lists:reverse (letters_only (T)),
                    case  Criterion (Word) of
                        true  -> more (S, 
                                       Criterion, 
                                       dict:update (bag (Word),
                                                    fun (Words) -> adjoin (Word, Words) end,
                                                    [Word], SoFar));
                        false -> more (S, Criterion, [SoFar])
                    end
            end
    end.
