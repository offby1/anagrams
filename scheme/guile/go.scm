#!/bin/sh
here=$(cd $(dirname $0); pwd)
GUILE_LOAD_PATH="$here"
export GUILE_LOAD_PATH
GUILE_WARN_DEPRECATED=detailed
export GUILE_WARN_DEPRECATED

if [ -z "$1" ];
then
    exec "$here/$0" "Frotz Plotz"
fi

exec guile -s $0 ${1+"$@"}
!#

(use-modules (anagrams))
(display (length (all-anagrams (cadr (command-line)))))
(newline)
