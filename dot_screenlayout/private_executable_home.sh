#!/bin/sh
xrandr --output VIRTUAL1 --off --output DP3 --off --output eDP1 --off --output DP1 --mode 2560x1440 --pos 0x0 --rotate normal --output HDMI3 --off --output HDMI2 --off --output HDMI1 --off --output DP2 --primary --mode 2560x1440 --pos 2560x0 --rotate normal
sleep 1
nitrogen --restore
