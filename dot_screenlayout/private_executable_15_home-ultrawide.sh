#!/bin/sh
xrandr --output DP-0.3 --mode 2560x1440 --pos 0x0 --rotate left --output DP-0.2 --primary --mode 3440x1440 --pos 1440x808 --rotate normal --output DP-0 --off --output DP-1 --off --output DP-2 --off --output HDMI-0 --off --output DP-3 --off --output eDP-1-1 --mode 1920x1080 --pos 4880x1168 --rotate normal
sleep 3
nitrogen --restore