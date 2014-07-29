#!/usr/bin/env bash
# Get root dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Control+C Trap
cleanup()
{
  kill `cat $DIR/phones.pid`
  kill `cat $DIR/random.pid`
  kill `cat $DIR/radio.pid`
  return $?
}

control_c()
# run if user hits control-c
{
  echo -en "*** Exiting ***"
  cleanup
  rm $DIR/phones.pid
  rm $DIR/random.pid
  exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

# Run our apps
$DIR/phones/phones.sh > $DIR/mpd.log 2>&1 &
echo $! > $DIR/phones.pid
$DIR/play/playlistmgr.php > $DIR/mpd.log 2>&1 &
echo $! > $DIR/random.pid
$DIR/radio/play.sh > $DIR/mpd.log 2>&1 &
echo $! > $DIR/radio.pid

echo "*** Hit Control+C to exit ***"

wait `cat $DIR/phones.pid` 2>/dev/null
wait `cat $DIR/random.pid` 2>/dev/null
wait `cat $DIR/radio.pid` 2>/dev/null


