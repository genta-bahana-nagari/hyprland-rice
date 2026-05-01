#!/bin/bash

theme="$HOME/.config/rofi/styles/powermenu-style.rasi"

options="Shutdown\nReboot\nLock\nLogout\nSuspend"

chosen=$(echo -e "$options" | rofi -dmenu -theme "$theme" -p "Power")

case "$chosen" in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
esac