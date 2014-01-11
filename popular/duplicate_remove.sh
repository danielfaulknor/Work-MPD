#!/usr/bin/env bash
previousDIR=`pwd`
# Get root dir to get config file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$DIR")"

# Get path
path=$(sed -n 's/.*path *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)

cd $path/Popular

declare -A arr
shopt -s globstar

for file in **; do
  [[ -f "$file" ]] || continue

  read cksm _ < <(md5sum "$file")
  if ((arr[$cksm]++)); then
   rm $file
  fi
done

cd $previousDIR
