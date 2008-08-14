#!/bin/sh

test `./anagrams Ernest 2>/dev/null | wc -l` = 20
