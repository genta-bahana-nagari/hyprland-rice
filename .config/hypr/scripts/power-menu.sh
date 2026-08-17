theme="$HOME/.config/rofi/styles/powermenu-style.rasi"

options="󰐥  Shutdown
󰜉  Reboot
󰌾  Lock
󰍃  Logout
󰤄  Suspend"

chosen=$(printf '%s\n' "$options" | rofi -dmenu -theme "$theme" -p "Power")

case "$chosen" in
    "󰐥  Shutdown")
        systemctl poweroff
        ;;
    "󰜉  Reboot")
        systemctl reboot
        ;;
    "󰌾  Lock")
        hyprlock
        ;;
    "󰍃  Logout")
        hyprctl dispatch exit
        ;;
    "󰤄  Suspend")
        systemctl suspend
        ;;
esac