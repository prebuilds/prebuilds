#!/usr/bin/env bash

# Exits if there are no arguments
if [ $# -eq 0 ]; then
  exit 1
fi

# Creates the prefix directory
mkdir -p /prefix && cd /prefix || exit 1

# Gets the source code link
export SOURCECODE=$1

# Choose which tool to use for downloading and extracting
if [[ "${SOURCECODE,,}" == *.git ]] || [[ "$SOURCECODE" != *.* ]]; then
  # Git link given, use Git to make a shallow clone of the repo
  git clone --depth 1 "$SOURCECODE" src || exit 1
elif [[ "${SOURCECODE,,}" == *.tar.* ]]; then
  # Link to a compressed TAR file given, download it with Wget and extract it two times with 7-zip
  wget "$SOURCECODE" -O "src.tar.${SOURCECODE##*.}" || exit 1
  7z x -y "src.tar.${SOURCECODE##*.}"
  rm "src.tar.${SOURCECODE##*.}"
  7z x -y src.tar -o./src
  rm src.tar
else
  # Link to regular ZIP or TAR file, download it with Wget and extract it with 7-Zip
  wget "$SOURCECODE" -O "src.${SOURCECODE##*.}" || exit 1
  7z x -y "src.${SOURCECODE##*.}" -o./src
  rm "src.${SOURCECODE##*.}"
fi
