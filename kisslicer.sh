#!/bin/bash

set -e

if [ "$1" = "" ]; then
    printer=kisslicer
else
    printer=$1
fi

(
     cd /home/crpalmer/kisslicer-configs/$printer
     if [ ! -e KISSlicer ]; then
          ln -s ../bin/KISSlicer
     fi
     ./KISSlicer &
)
