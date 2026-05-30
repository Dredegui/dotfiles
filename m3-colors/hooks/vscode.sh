#!/usr/bin/env bash

notify-send "M3 Colors" "Updating VSCode color scheme..." --expire-time=2000
python3 ~/.config/m3-colors/hooks/vscode.py
