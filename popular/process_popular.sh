#!/usr/bin/env bash
previousDIR=`pwd`

# Get root dir to get config file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$DIR")"

# Get path from config
path=$(sed -n 's/.*path *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)
owner=$(sed -n 's/.*owner *= *\([^ ]*.*\)/\1/p' < $parentdir/config.ini)

# Drop explicit music
echo "Removing explicit music"
find $path/zPopularSource -type f -name "*Explicit*" -exec rm {} \;

# Move MP3s to processing folder
echo "Moving music to processing"
find $path/zPopularSource -iname "*.mp3" -type f -exec /bin/mv {} $path/zPopularProcessing \;

# Change into processing folder
echo "Processing"
cd /media/music/zPopularProcessing
# Remove ranking numbers from the start
rename -f -v "s/^[0-5][0-9] //g" *.mp3
rename -f -v "s/^[0-5][0-9] - //g" *.mp3

# Move files to the proper directory
echo "Moving music into media folder"
rsync -avz --remove-source-files $path/zPopularProcessing/* $path/Popular

# Clean up duplicates
echo "Removing duplicates"
$DIR/duplicate_remove.sh

# Fix permissions
echo "Fixing permissions"
chown -R $owner:$owner $path/Popular

# Return us to previous directory
cd $previousDIR
