#!/usr/bin/env bash
# Get root dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Control+C Trap
cleanup()
{
  kill `cat $DIR/phones.pid`
  kill `cat $DIR/random.pid`
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
$DIR/play/random.php > $DIR/mpd.log 2>&1 &
echo $! > $DIR/random.pid

echo "*** Hit Control+C to exit ***"

wait `cat $DIR/phones.pid` 2>/dev/null
wait `cat $DIR/random.pid` 2>/dev/null


