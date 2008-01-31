#!/bin/sh

arc=/usr/local/src/langs/arc
(cat bag.arc dict.arc; echo '(quit)') | (cd $arc/arc0; $arc/plt/bin/mzscheme -m -f as.scm) 
