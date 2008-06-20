-module (pairfold).
-compile (export_all).

pairfold (Fun, Seq) ->
    pairfold (Fun, Seq, []).

pairfold (_Fun, [], Accum)->
    Accum;

pairfold (Fun, [_|Tail] = Seq, Accum)->
    pairfold (Fun,
              Tail,
              Fun (Seq, Accum)).
