#!/bin/bash

CURR=$(brightnessctl g)
MAX=$(brightnessctl m)
echo "$CURR"
echo "$MAX"
CPER=$(($(($CURR * 100)) / $(($MAX))))
echo "$CPER"
# notify-send "Brightness: $CPER%"
NPER=0
if [ "$1" -eq 0 ]; then
    NPER=$(($CPER - 10))
else
    NPER=$(($CPER + 10))
fi

brightnessctl s $NPER%
