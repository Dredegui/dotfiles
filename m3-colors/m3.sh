#!/usr/bin/env bash

WALLPAPER=$HOME/.config/wallpaper/current.jpg
rm $HOME/.config/m3-colors/output/current_*_scheme.* 

if [ ! -f "$WALLPAPER" ]; then
  echo "Wallpaper not found at $WALLPAPER. Exiting."
  exit 1
fi

# Check last modify date of the wallpaper and regenerate color schemes if it has changed since last run.
if [ -f "$WALLPAPER" ]; then
  LAST_MODIFIED=$(stat -c %Y "$WALLPAPER")
  LAST_RUN_FILE="$HOME/.config/m3-colors/last_run"
  if [ -f "$LAST_RUN_FILE" ]; then
    LAST_RUN=$(cat "$LAST_RUN_FILE")
    if [ "$LAST_MODIFIED" -le "$LAST_RUN" ]; then
      notify-send "M3 Colors" "Wallpaper has not changed since last run. Exiting."
      feh --bg-scale $WALLPAPER
      # echo "Wallpaper has not changed since last run. Exiting."
      exit 0
    fi
  fi
  echo "$LAST_MODIFIED" > "$LAST_RUN_FILE"
fi

"$HOME/m3/.venv/bin/m3wal" "$WALLPAPER" --full --variant FIDELITY --mode dark