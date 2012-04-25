#!/bin/sh

set -e

# Oddly, order matters here
for i in bag main
do
    6g ${i}.go
done

6l main.6

./6.out
