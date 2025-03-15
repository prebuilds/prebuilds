#!/usr/bin/env bash

# DO NOT use this tool
# it is here as a reference, a note, not to be ran
exit

# Go to the source code directory
cd /prefix/src
while [ "$(ls -1 | wc -l)" -eq 1 ]; do
    cd "$(ls -1)" || break
done
