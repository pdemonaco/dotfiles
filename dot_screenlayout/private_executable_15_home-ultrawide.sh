#!/bin/sh
# 27" portrait
# xrandr --output eDP --mode 1920x1080 --pos 4880x1480 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --mode 2560x1440 --pos 3440x0 --rotate right --output DisplayPort-4 --primary --mode 3440x1440 --pos 0x876 --rotate normal

# 27" landscape
xrandr --output eDP --off --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --mode 2560x1440 --pos 3440x0 --rotate normal --output DisplayPort-4 --primary --mode 3440x1440 --pos 0x0 --rotate normal

# Fix backgrounds
sleep 3
nitrogen --restore
