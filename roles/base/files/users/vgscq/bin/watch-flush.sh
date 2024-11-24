#!/bin/bash

timeorig=$(date '+%s')
deltat=5  # checking time interval

if [ $# -eq 2 ]
then
 echo "'${0##*/}' watches flushing buffered alias 'dirty' data"
 tailfile="$2"
 dirtorig="$1" # total file size [bytes] to be cloned
 dirtorig=$((dirtorig/1000))
 echo "dirty = $dirtorig kB - total file size to be cloned"
 echo "0
# file size :  $dirtorig kB - to be cloned" > "$tailfile"
else
 echo "'${0##*/}' watches flushing 'dirty' data - quit with 'q'"
 dirtorig=$(grep -e 'Dirty:' /proc/meminfo | tr -s ' ' '\t' | cut -f2)
 echo "dirty = $dirtorig kB - when starting to watch"
fi
dirt0=$dirtorig

run=true
ratsum=0
numsum=0
while $run
do
 if [ $# -eq 2 ]
 then
  sleep "$deltat"
 else
  read -n 1 -s -t "$deltat" tdum
  if [ "$tdum" == "q" ]
  then
   run=false
  fi
 fi
 dirty=$(grep -e 'Dirty:' /proc/meminfo | tr -s ' ' '\t' | cut -f2)
 deltad=$((dirt0-dirty))
 if [ $deltad -gt 0 ]
 then
  eta="$((dirty*deltat/deltad)) s"
  rate=$(((deltad+500)/deltat/1000))
  ratsum=$((ratsum+rate))
  numsum=$((numsum+1))
  rate="$rate MB/s"
 elif [ $deltad -lt 0 ]
 then
  eta="n.a."
  rate=$(((deltad+500)/deltat/1000))
#  ratsum=$((ratsum+rate))
#  numsum=$((numsum+1))
  rate="$rate MB/s"
 else
  eta="n.a."
  rate="n.a."
 fi
 echo -en "\0033[2K\0033[1G"
 echo -n "dirty = $dirty kB -- watching -- rate = $rate -- eta = $eta"
 dirt0="$dirty"
 if [ $# -eq 2 ]
 then
  percent=$((100-(100*dirty+50)/dirtorig))
  echo "$percent
# buffered data : $dirty kB -- watching -- rate : $rate -- eta : $eta" >> "$tailfile"
 fi
done
echo -e "\0033[2K\0033[1GDone watching :-)"

timefinal=$(date '+%s')
timeused=$((timefinal-timeorig))
if [ $numsum -gt 0 ]
then
 rate="$(( (ratsum + numsum/2) / numsum))"
else
 rate="n.a."
fi
echo "ratsum=$ratsum"
echo "numsum=$numsum"
echo "watching time = $timeused s -- average rate = $rate MB/S"
