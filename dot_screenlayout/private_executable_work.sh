#!/bin/sh
xrandr --output eDP-1 --mode 1920x1080 --pos 0x360 --rotate normal --output HDMI-3 --off --output HDMI-2 --off --output HDMI-1 --off --output DP-3 --off --output DP-2 --off --output DP-1 --primary --mode 2560x1440 --pos 1920x0 --rotate normal
sleep 1
nitrogen --restore
