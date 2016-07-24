#!/usr/bin/env bash

# xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
# sleep .25
# xrandr --addmode eDP1 1920x1080_60.00
# sleep .25
xrandr --output eDP1 --mode 1920x1080


killall notify-osd && notify-send -i terminal "Resolution" "Updated"

cat ~/.config/wallpath | feh --bg-fill "$(xargs -0)"
