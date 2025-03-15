#!/usr/bin/env bash

echo Gotosrc.SH debug before: $(pwd)

# Go to the source code directory
cd /prefix/src
while [ "$(ls -1 | wc -l)" -eq 1 ]; do
    cd "$(ls -1)" || break
done

echo Gotosrc.SH debug after: $(pwd)
