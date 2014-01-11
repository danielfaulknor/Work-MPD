#!/usr/bin/env bash

# Get root dir to get config file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$DIR")"

# Get status URL from config
path=$(sed -n 's/.*path *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)

find $path -type f -iname '*.mp3' -print0 | xargs -0 mp3gain
find $path -type f -iname '*.mp3' -exec $DIR/ape2id3.py -df {} \;
