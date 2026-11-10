#!/usr/bin/env sh
restart_panel() {
    # Waybar's process name is ".waybar-wrapped" (argv is "waybar"), so a plain
    # `pgrep waybar` substring-matches it. Reload via SIGUSR2; start if absent.
    if pgrep waybar >/dev/null 2>&1; then
        pkill -SIGUSR2 waybar
    else
        waybar &
    fi
}

case "$1" in
    on)
        monitor_count=$(hyprctl monitors | grep -c "^Monitor")
        if [ "$monitor_count" -gt 1 ]; then
            hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
            sleep 0.5
            restart_panel
        fi
        ;;
    off)
        hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = false, mode = "2880x1800@120", position = "auto-right", scale = 1.5 })'
        sleep 0.5
        restart_panel
        ;;
esac
