#!/usr/bin/env sh
monitor_count=$(hyprctl monitors | grep -c "^Monitor")
if [ "$monitor_count" -gt 1 ]; then
    hyprctl keyword monitor "eDP-1, disable"
    sleep 0.5
    pkill hyprpanel
    hyprpanel &
fi
