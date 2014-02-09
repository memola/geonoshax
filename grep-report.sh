#!/bin/bash
# Lines that start with a pound-sign are comments. They are ignored when you run the script!
# $1 refers to the search term (that is, the first command line argument).
# the -z is a condition that is true if the length in characters
# of the search term is zero, that is if there was no search term
if [ -z $1 ]; then
  # set the list of places equal to the lines of content in the file 'countries.txt' 
  places=`cat countries.txt`;
else
  # set the list of places equal to the search term
  places=( "$1" )
fi
# make a list of all the file paths under the data directory whose name ends with '.txt'
allfiles=`find data -type f -name "*.txt"`
# for each value in the list of places, do the following
# with a variable called 'place' set equal to the value from the list
# this will only one value if there was a search term
for place in $places; do
  # print a header line for the place we're searching for
  echo "$place Matches:"
  # for each file path we found, set the variable f equal to the file path
  for f in $allfiles; do
    # set a variable for the file's running total of matches to start at 0
    running=0
    # backticks mean to collect output as a value
    # this backtick is the output of grep'ing the file for the place name
    # this will be a list of every line with the place name in it
    for line in `grep $place "$f"`; do
      # this line prints/echoes the matched line into grep again
      # when grep has the -o option, its output is each word that matched
      # on a separate line. We then pipe those lines into a utility that counts lines
      # and collect that number as the total number of matches in a line ('count')
      count=`echo $line | grep -o $place | wc -l`
      if [ -z $count ]; then
        count=0;
      fi
      # add the matches from this line to the running total for the file
      # notice that when you set a variable's value, you don't use the dollar sign
      # the dollar sign means you are referring to the current value
      running=`expr $running + $count`
    done
    # Now that we have the total number of matches from the file, we check to see
    # if it was greater than 0. If it was, we print the results.
    if [ $running -gt 0 ]; then
      # we get the year by taking the basename (without directories) of the file
      # ignoring the suffix '.txt'
      year=`basename "$f" .txt`
      echo "  $year : $running"
    fi
  done
done
