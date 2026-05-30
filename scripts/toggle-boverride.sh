#!/bin/bash

# Toggle brightness override for the current monitor
# This script is meant to be used with i3's exec command and the XF86MonBrightnessUp/Down keys.

# Get the current monitor's name using xrandr
MONITOR=$(xrandr --current | grep " connected" | awk '{print $1}')
if [ -z "$MONITOR" ]; then
	notify-send "Brightness Control" "No connected monitor found."
	exit 1
fi

# Check the current brightness state for the monitor
CURRENT_BRIGHTNESS=$(xrandr --verbose | grep -A 5 "^$MONITOR" | grep "Brightness" | awk '{print $2}')
if (($(echo "$CURRENT_BRIGHTNESS <= 1.0" | bc -l))); then
	# If brightness is at default (1.0), set it to a higher value to simulate a brightness override
	xrandr --output "$MONITOR" --brightness 1.3
	notify-send "Brightness Control" "Brightness override enabled for $MONITOR."
else
	# Reset it to default (1.0)
	xrandr --output "$MONITOR" --brightness 1.0
	notify-send "Brightness Control" "Brightness override disabled for $MONITOR."
fi
