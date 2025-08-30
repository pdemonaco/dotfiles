#!/bin/sh
xrandr --output eDP --mode 1920x1080 --pos 5120x360 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --primary --mode 2560x1440 --pos 2560x0 --rotate normal --output DisplayPort-4 --mode 2560x1440 --pos 0x0 --rotate normal

# Fix backgrounds
sleep 3
nitrogen --restore
