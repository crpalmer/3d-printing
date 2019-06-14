#!/bin/bash

sed 's/^[-+a-z_]*_gcode = //' | \
   sed 's/\\n//g' | \
   tr '' '\n'

