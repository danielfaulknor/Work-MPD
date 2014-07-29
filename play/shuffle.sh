#!/usr/bin/env bash
UPPER=`mpc | sed '2q;d' | cut -f 2 -d ' ' | cut -f 2 -d '/'` # How many times max. to shuffle?

for X in `seq 0 $UPPER`; do
MAXSONG=$UPPER;
RANFROM=$RANDOM;
RANTO=$RANDOM;


let "RANFROM = $RANFROM % $MAXSONG + 1";
let "RANTO = $RANTO % $MAXSONG + 1";


mpc move $RANFROM $RANTO;
echo "Moved song " $RANFROM " to " $RANTO; # For debugging, remove if you want.
done

# Moving playlist pointer back to the top
mpc play 1
