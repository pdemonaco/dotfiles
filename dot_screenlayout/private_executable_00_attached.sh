#!/bin/sh
xrandr --output DP-0.2 --off --output DP-0.3 --off --output DP-0 --off --output DP-1 --off --output DP-2 --off --output HDMI-0 --off --output DP-3 --off --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
sleep 1
nitrogen --restore
