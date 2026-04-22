#!/bin/bash

# Kill any existing gnome-screenshot processes
pkill -f gnome-screenshot

gnome-screenshot -a --file /tmp/screenshot.png
if [ $? -eq 0 ]; then
    notify-send "Screenshot taken" "Screenshot saved to clipboard."
    xclip -selection clipboard -t image/png -i /tmp/screenshot.png
else
    notify-send "Error" "Failed to take screenshot."
fi