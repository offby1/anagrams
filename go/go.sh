#!/bin/sh

set -e

for i in *.go
do
    8g $i
done

8l *.8

./8.out