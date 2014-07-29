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
			mpc stop
			sleep 10
			mplayer $url -softvol -volume 4 &
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
			mpc play
		fi
	fi
sleep 5
done

