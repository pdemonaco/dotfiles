#!/bin/sh
xrandr --output eDP --mode 1920x1080 --pos 3440x360 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --primary --mode 3440x1440 --pos 0x0 --rotate normal --output DisplayPort-4 --off
sleep 1
nitrogen --restore
