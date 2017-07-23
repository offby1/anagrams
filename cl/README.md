On OS X, `brew install sbcl` works.

So to run the profile, this works:

`sbcl --load profile.lisp > out 2> err`

> The output redirections aren't strictly necessary, but given that I
> generally run these commands via emacs' `M-x compile`, and emacs is
> dog-slow, this speeds things up.

And to run without profiling:

`time sbcl --load sbcl-main.lisp`
