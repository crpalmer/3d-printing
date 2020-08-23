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
	newline
        echo "=== ignoring $i === "
     else
	newline
	echo "=== diffing  $i ==="
	d=`dirname "$i"`
	name0=`head -1 "$i" | sed s'/[\[]//g' | sed 's/\]//'`
	name="slic3r/$name0.ini"
        ( 
          cat "$i"
	  cat "$d/base.ini"
        ) | sort --stable --unique -k 1,1 -t ' ' | diff -w - "$name"
     fi
  fi
done
