#!/usr/bin/env bash

main_display=$(xrandr --query | grep " connected primary" | awk '{print $1}')
external_display=$(xrandr --query | grep " connected" | grep -v " primary" | awk '{print $1}')

if [ -z "$external_display" ]; then
    external_display="$main_display"
fi

notify-send "Main display: $main_display"
notify-send "External display: $external_display"

xrandr --output "$external_display" --above "$main_display" --auto

ws1="1 "
ws2="2 "
ws3="3 " 
ws4="4"
ws5="5"
ws6="6"
ws7="7"
ws8="8"
ws9="9 󰐾"
ws10="10 "

# Get workspace names with their custom labels and icons
# ws1=$(i3-msg -t get_workspaces | jq '.[] | select(.num==1) | .name' | tr -d '"')
# ws2=$(i3-msg -t get_workspaces | jq '.[] | select(.num==2) | .name' | tr -d '"')
# ws3=$(i3-msg -t get_workspaces | jq '.[] | select(.num==3) | .name' | tr -d '"')
# ws4=$(i3-msg -t get_workspaces | jq '.[] | select(.num==4) | .name' | tr -d '"')
# ws5=$(i3-msg -t get_workspaces | jq '.[] | select(.num==5) | .name' | tr -d '"')
# ws6=$(i3-msg -t get_workspaces | jq '.[] | select(.num==6) | .name' | tr -d '"')
# ws7=$(i3-msg -t get_workspaces | jq '.[] | select(.num==7) | .name' | tr -d '"')
# ws8=$(i3-msg -t get_workspaces | jq '.[] | select(.num==8) | .name' | tr -d '"')
# ws9=$(i3-msg -t get_workspaces | jq '.[] | select(.num==9) | .name' | tr -d '"')
# ws10=$(i3-msg -t get_workspaces | jq '.[] | select(.num==10) | .name' | tr -d '"')

# Tell i3 where workspaces go
i3-msg "workspace \"$ws1 output $external_display"
i3-msg "workspace \"$ws2\" output $main_display"
i3-msg "workspace \"$ws3\" output $main_display"
i3-msg "workspace \"$ws4\" output $main_display"
i3-msg "workspace \"$ws5\" output $main_display"
i3-msg "workspace \"$ws6\" output $main_display"
i3-msg "workspace \"$ws7\" output $external_display"
i3-msg "workspace \"$ws8\" output $external_display"
i3-msg "workspace \"$ws9\" output $main_display"
i3-msg "workspace \"$ws10\" output $main_display"



# i3-msg "workspace 1 output $external_display"
# i3-msg "workspace 2 output $main_display"
# i3-msg "workspace 3 output $main_display"
# i3-msg "workspace 4 output $main_display"
# i3-msg "workspace 5 output $main_display"
# i3-msg "workspace 6 output $main_display"
# i3-msg "workspace 7 output $external_display"
# i3-msg "workspace 8 output $external_display"
# i3-msg "workspace 9 output $main_display"
# i3-msg "workspace 10 output $main_display"