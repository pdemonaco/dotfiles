#!/bin/sh
xrandr --output DP-0.2 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-0.3 --primary --mode 2560x1440 --pos 2560x0 --rotate normal --output DP-0 --off --output DP-1 --off --output DP-2 --off --output HDMI-0 --off --output DP-3 --off --output eDP-1-1 --off
sleep 1
nitrogen --restore
