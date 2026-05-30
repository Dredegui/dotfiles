#!/bin/bash

# Unique notification ID (can be any number)
NOTIFY_ID=9999

# Get the battery level
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

# Set brightness level (adjust accordingly)
DIM_BRIGHTNESS=30
NORMAL_BRIGHTNESS=100


# Check if battery is below threshold and discharging
if [[ "$battery_level" -le 5 && "$status" == "Discharging" ]]; then
    # Send notification
    # notify-send -u critical -r $NOTIFY_ID "Battery Low (${battery_level}%)"
    # notify-send -u critical -r $NOTIFY_ID "Battery Low" "Battery level is ${battery_level}%." --- IGNORE ---

    # Dim the screen
    brightnessctl s ${DIM_BRIGHTNESS}%
fi

# Check if battery is charging
if [[ "$status" == "Charging" ]]; then
    # Restore brightness
    brightnessctl s ${NORMAL_BRIGHTNESS}%
    # Clear the notification
    # gdbus call -e -d org.freedesktop.Notification -o /org/freedesktop/Notifications -m org.freedesktop.Notifications.CloseNotification $NOTIFY_ID
fi
