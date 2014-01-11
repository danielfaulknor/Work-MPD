#!/usr/bin/env bash

# Get root dir to get config file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$DIR")"

# Get status URL from config
url=$(sed -n 's/.*phone_status *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)
callVol=$(sed -n 's/.*call_volume *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)

if [ -z "$url" ]; then
	echo "PHONES - No URL set, not running phone status check"
	exit 0
fi

# Run loop
echo "PHONES - Staring loop"
while [ 1 ]
do
	# Pull status
	RESULT=$(wget --quiet -O- $url)

	# If someone is on the phone...
	if [ "$RESULT" =  "On" ]
	then
		# ...and they weren't before...
		if [ -f $DIR/offphone ]
		then
			# ...turn the music down.
			echo -n "PHONES - "
			echo -n `date +%X`
			echo " :: New Call -Turning volume down"

			# Flip status file
			rm $DIR/offphone
			touch $DIR/onphone

			# Drop volume
			amixer sset Master $callVol

			echo "=== VOLUME MOVEMENT DONE ==="
		fi
	# If nobody is on the phone....
	else
		# ...and they were before...
		if [ -f $DIR/onphone ]
		then
			# ...turn the music back up.
			echo -n "PHONES - "
			echo -n `date +%X`
			echo " :: No more calls - Volume up!"

			# Flip status file
			rm $DIR/onphone
			touch $DIR/offphone

			# Turn the volume back up slowly
			amixer sset Master 90%
			sleep 1;
			amixer sset Master 95%
			sleep 1;
			amixer sset Master 100%
			echo "=== VOLUME MOVEMENT DONE ==="

		fi
	fi
	sleep 3
done

