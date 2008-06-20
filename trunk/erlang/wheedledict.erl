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
            {ok, S} = file:open (
                        %%"words-small",
                        "/usr/share/dict/words",
                        read),
            HT = hash_from_stream (S, dict:new ()),
            file:close (S),
            dict:map (fun (K, V) -> 
                              dets:insert (Dets, {K, V})
                              end,
                      HT),
            io:format ("Stored ~p.~n",
                       [dict:fold (fun (_Key, Value, AccIn)-> 
                                           {{bags, B}, {words, W}} = AccIn,
                                           {{bags, B + 1},
                                            {words, W+ length (Value)}}
                                   end,
                                   {{bags, 0}, {words, 0}},
                                   HT)]);
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

letters_only_lowercased (String) ->
    [downcase(X) || X <- String,  (X >= $a andalso X =< $z) orelse (X >= $A andalso X =< $Z)].

acceptable (Word, _Sym)->
    io:format ("Testing ~p...", [Word]),
    RV = acceptable (Word),
    io:format ("=> ~p~n", [RV]),
    RV.

acceptable ([]) -> false;
acceptable ([$a])-> true;
acceptable ([$i])-> true;
acceptable ([_SingleLetter]) -> false;
acceptable ([_H|_T])-> true.

hash_from_stream (S, HT) ->
    case io:get_line (S, '') of
        eof ->
            HT;
        Line ->
            %% Strip trailing newlines by (*sigh*) reversing the
            %% string, matching, then re-reversing.
            Chars = lists:reverse (Line),
            case Chars of
                [$\n | T] ->
                    Word = lists:reverse (letters_only_lowercased (T)),
                    case acceptable (Word) of
                        true  -> 
                            hash_from_stream(S,
                                             dict:update (bag (Word),
                                                          fun (Val) ->
                                                                  case lists:member (Word, Val) of
                                                                      true -> Val;
                                                                      _ -> [Word|Val]
                                                                  end
                                                          end,
                                                          [Word],
                                                          HT)) ;
                        _ -> 
                            hash_from_stream (S, HT)
                    end
            end
    end.
