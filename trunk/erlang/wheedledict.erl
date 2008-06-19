-module (wheedledict).
-compile (export_all).
-import (bag, [bag/1]).
-export ([snarf/0]).

dets_size (Dets)->
    {value, {size, S}} = lists:keysearch(size, 1, dets:info (Dets)),
    S.

snarf ()->
    {ok, Dets} = dets:open_file (snork, [{file, "dict.dets"}]),
    case dets_size (Dets) of
        0 -> 
            {ok, S} = file:open ("/usr/share/dict/words", read),
            fill_dets_from_stream (Dets, S),
            file:close (S),
            io:format ("Stored ~p bags.~n", [dets_size (Dets)]);
        _ -> whatever
    end,
    BigList = dets:traverse (Dets, fun (Object) -> {continue, Object} end),
    dets:close (Dets),
    BigList.

downcase (Char) ->
    case Char >= $A andalso Char =< $Z of 
            true -> Char - $A + $a;
        false -> Char
    end.

letters_only (String) ->
    [downcase(X) || X <- String,  (X >= $a andalso X =< $z) orelse (X >= $A andalso X =< $Z)].

acceptable (_Word) ->
    true.

fill_dets_from_stream (Dets, S) ->
    case io:get_line (S, '') of
        eof ->
            dets:traverse (Dets, fun (Object) -> {continue, Object} end);
        Line ->
            %% Strip trailing newlines by (*sigh*) reversing the
            %% string, matching, then re-reversing.
            Chars = lists:reverse (Line),
            case Chars of
                [$\n | T] ->
                    Word = lists:reverse (letters_only (T)),
                    case acceptable (Word) of
                        true  -> 
                            dets:insert (Dets, {bag (Word), Word}) ;
                        _ -> 
                            dontcare
                    end,
                    fill_dets_from_stream (Dets, S)
            end
    end.
