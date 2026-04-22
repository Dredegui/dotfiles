#!/bin/bash

# This script toggles the system between sleepless mode and normal mode.
# xset is used to disable/enable screen blanking and power management.
# notify-send is used to send desktop notifications.
# Usage: ./toggle_sleep_mode.sh
# Make sure to give execute permission: chmod +x toggle_sleep_mode.sh

# Check current state by querying xset for its current settings
current_state=$(xset q | grep "DPMS is" | awk '{print $3}')
if [ "$current_state" = "Enabled" ]; then
    # Disable sleep mode
    xset s 0 0 -dpms
    notify-send "Sleep Mode Disabled" "The system will not enter sleep mode."
else
    # Enable sleep mode with default settings
    xset s default 
    xset +dpms
    notify-send "Sleep Mode Enabled" "The system will enter sleep mode as per default settings."
fi