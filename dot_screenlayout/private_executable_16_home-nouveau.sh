#!/bin/sh
xrandr --output eDP-1 --mode 1920x1080 --pos 4880x1223 --rotate normal --output HDMI-1 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-1-1 --off --output DP-1-2 --primary --mode 3440x1440 --pos 1440x863 --rotate normal --output DP-1-3 --mode 2560x1440 --pos 0x0 --rotate left
sleep 3
nitrogen --restore
