#!/usr/bin/env bash

# Get root dir to get config file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$DIR")"

# Get path from config
path=$(sed -n 's/.*path *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)
url=$(sed -n 's/.*stream_url *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)
echo "RADIO - Starting loop"
while [ 1 ]
do

	if [ -e $DIR/play ]
	then
		if [ ! -e $DIR/mplayer.pid ]
		then
			echo "RADIO - Playing Radio"
			amixer sset PCM 70%
			mpc stop
			sleep 10
			mplayer $url &
			echo $! > $DIR/mplayer.pid
		fi
	fi

	if [ ! -e $DIR/play ]
	then
		if [ -e $DIR/mplayer.pid ]
		then
			echo "RADIO - Resuming MPD"
			kill `cat $DIR/mplayer.pid`
			rm $DIR/mplayer.pid
			sleep 10
			amixer sset PCM 100%
			mpc play
		fi
	fi
sleep 5
done

