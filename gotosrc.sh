#!/usr/bin/env bash

# Go to the source code directory
cd /prefix/src
while [ "$(ls -1 | wc -l)" -eq 1 ]; do
    cd "$(ls -1)" || break
done
