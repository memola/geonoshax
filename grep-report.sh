#!/bin/bash
if [ -z $1 ]; then
  places=`cat countries.txt`;
else
  places=( "$1" )
fi
for patt in $places; do
  echo "$patt Matches:"
  for f in `find data -type f -name "*.txt"`; do
    running=0
    for line in `grep $patt "$f"`; do
      count=`echo $line | grep -o $patt | wc -l`
      if [ -z $count ]; then
        count=0;
      fi
      running=`expr $running + $count`
    done
    if [ $running -gt 0 ]; then
      year=`basename "$f" .txt`
      echo "  $year : $running"
    fi
  done
done
