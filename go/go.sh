#!/bin/sh

set -e

# Oddly, order matters here
for i in bag main
do
    8g ${i}.go
done

8l *.8

./8.out