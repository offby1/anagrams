#!/bin/sh

scons
time ./anagrams "Ernest Hemingway" >/dev/null
