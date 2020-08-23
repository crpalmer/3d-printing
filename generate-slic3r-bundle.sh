#!/bin/bash

newline() {
  awk 'BEGIN { printf("%c", 10); }' < /dev/null
}

git ls-files slic3r | 
while read i
do
  if echo "$i" | grep -q '/.*/';
  then
     if echo "$i" | grep -q 'base.ini$'
     then
        echo "ignoring   $i" >& /dev/tty
     else
	echo "processing $i" >& /dev/tty
	d=`dirname "$i"`
	head -1 "$i"
        ( 
          tail -n +2 "$i"
	  cat "$d/base.ini"
        ) | sort --stable --unique -k 1,1 -t ' ' 
	newline
     fi
  else
     cat "$i"
     newline
  fi
done
