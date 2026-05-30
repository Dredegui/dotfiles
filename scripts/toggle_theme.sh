#!/bin/bash

# Path to gsettings keys
GTK_THEME_KEY="org.gnome.desktop.interface gtk-theme"
COLOR_SCHEME_KEY="org.gnome.desktop.interface color-scheme"
GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"

# Set this to the base GTK theme you are currently using.
# The script will derive the dark variant by appending "-dark".
GTK_THEME_BASE="FlatColor"
GTK_THEME_LIGHT="${GTK_THEME_LIGHT:-$GTK_THEME_BASE}"
GTK_THEME_DARK="${GTK_THEME_DARK:-$GTK_THEME_BASE}"

# Read current theme
current_theme=$(grep "gtk-theme-name" "$GTK_FILE" | cut -d= -f2 | tr -d ' ')
# Get PID of Chrome if running
chrome_pid=$(pidof chrome)

kill_chrome() {
    if [ -n "$chrome_pid" ]; then
        pidof chrome | xargs kill
        return 0
    fi
    return 1
}

start_chrome() {
    # Start Chrome if $1 is true, 
    if [ "$1" -eq 0 ]; then
        google-chrome &
    fi
}

kill_vscode() {
    # Get VSCode process ID
    vscode_id=$(wmctrl -l | grep "Visual Studio Code" | awk '{print $1}')
    if [ -n "$vscode_id" ]; then
        wmctrl -ic "$vscode_id"
        return 0
    fi
    return 1
}

start_vscode() {
    # Start VSCode with the resolved path
    if [ "$1" -eq 0 ]; then
        code "$2"
    fi
}

# Function to (re)start Chrome with normal features
restart_chrome() {
    # Kill Chrome if running
    if [ -n "$chrome_pid" ]; then
        pidof chrome | xargs kill
        sleep 1
    fi
    # Start Chrome 
    google-chrome &

    sleep 2
    # Send google to ws1
    # wmctrl -r "Google Chrome" -t 0
    i3-msg move container to workspace "1 "
}

# Get the VSCode process with folder path
PROJECT_PATH=$(ps aux | grep "[c]ode " | awk '{for(i=11;i<=NF;++i)printf $i" "; print ""}' | head -n 1 | xargs | awk '{print $3}')
# Check if the project path is not empty
if [ -n "$PROJECT_PATH" ]; then
    RESOLVED_PATH=$(realpath "$PROJECT_PATH")
    # Check if the path exists in the filesystem
    if [ ! -d "$RESOLVED_PATH" ]; then
        RESOLVED_PATH="/home/$(whoami)/work/$(PROJECT_PATH)"
        # Check if the new path exists
        if [ ! -d "$RESOLVED_PATH" ]; then
            PATRESOLVED_PATHH=""
        fi
    fi
else
    RESOLVED_PATH=""
fi


if [ "$current_theme" = "$GTK_THEME_DARK" ]; then
    # Switch to Light
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=${GTK_THEME_LIGHT}/" "$GTK_FILE"
    gsettings set $COLOR_SCHEME_KEY 'default'
    notify-send "Switched to Light Mode"
else
    # Switch to Dark
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=${GTK_THEME_DARK}/" "$GTK_FILE"
    gsettings set $COLOR_SCHEME_KEY 'prefer-dark'
    notify-send "Switched to Dark Mode"
fi

# kill_chrome
kill_vscode
result_vscode=$?
kill_chrome
result_chrome=$?

# Wait a moment to ensure it's fully closed
sleep 1

# Start Chrome if it was running
start_chrome "$result_chrome"
sleep 1
i3-msg move container to workspace "1 "
# Start VSCode if it was running
start_vscode "$result_vscode" "$RESOLVED_PATH"



