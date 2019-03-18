#!/bin/sh
xrandr --output DP-2-1 --off --output DP-2-8 --off --output eDP-1 --primary --mode 1920x1080 --pos 5120x360 --rotate normal --output HDMI-3 --off --output HDMI-2 --off --output HDMI-1 --off --output DP-3 --off --output DP-2 --off --output DP-1 --off
sleep 1
nitrogen --restore
