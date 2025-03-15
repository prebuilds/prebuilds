if [ $# -eq 0 ]; then
  exit 1
fi

mkdir -p /prefix && cd /prefix || exit 1
export SOURCECODE=$1

if [[ "${SOURCECODE,,}" == *.git ]] || [[ "$SOURCECODE" != *.* ]]; then
  git clone --depth 1 "$SOURCECODE" src || exit 1
elif [[ "${SOURCECODE,,}" == *.tar.* ]]; then
  wget "$SOURCECODE" -O "src.tar.${SOURCECODE##*.}" || exit 1
  7z x -y "src.tar.${SOURCECODE##*.}"
  rm "src.tar.${SOURCECODE##*.}"
  7z x -y src.tar -o./src
  rm src.tar
else
  wget "$SOURCECODE" -O "src.${SOURCECODE##*.}" || exit 1
  7z x -y "src.${SOURCECODE##*.}" -o./src
  rm "src.${SOURCECODE##*.}"
fi
