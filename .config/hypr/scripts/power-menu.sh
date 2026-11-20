#!/usr/bin/env bash
set -Eeuo pipefail

theme="$HOME/.config/rofi/styles/powermenu-style.rasi"

uptime_info=$(uptime -p | sed -e 's/up //g')
host_name=$(hostname)

# 1 baris per item (TIDAK ada \n di tengah item agar tidak terpecah jadi kartu terpisah)
shutdown="<span size='18pt' rise='-1500'>󰐥</span>  Shutdown"
reboot="<span size='18pt' rise='-1500'>󰜉</span>  Reboot"
lock="<span size='18pt' rise='-1500'>󰌾</span>  Lock"
logout="<span size='18pt' rise='-1500'>󰍃</span>  Logout"
suspend="<span size='18pt' rise='-1500'>󰤄</span>  Suspend"

options="$shutdown\n$reboot\n$lock\n$logout\n$suspend"

chosen=$(printf '%b' "$options" | rofi -dmenu \
    -markup-rows \
    -hover-select \
    -me-select-entry '' \
    -me-accept-entry MousePrimary \
    -theme "$theme" \
    -mesg "<b>$host_name</b>   •   Uptime: $uptime_info")

[[ -z "$chosen" ]] && exit 0

confirm_action() {
    local action="$1"
    local yes="<span size='16pt' rise='-1000'>󰄬</span>  Yes"
    local no="<span size='16pt' rise='-1000'>󰅖</span>  No"
    local ans

    ans=$(printf '%b' "$yes\n$no" | rofi -dmenu \
        -markup-rows \
        -hover-select \
        -me-select-entry '' \
        -me-accept-entry MousePrimary \
        -theme "$theme" \
        -theme-str 'window { width: 480px; padding: 28px; } listview { columns: 2; lines: 1; } element { padding: 32px 12px; }' \
        -mesg "Confirm <b>$action</b>?")

    [[ "$ans" == *"Yes"* ]]
}

case "$chosen" in
    *"Shutdown"*)
        confirm_action "Shutdown" && systemctl poweroff
        ;;
    *"Reboot"*)
        confirm_action "Reboot" && systemctl reboot
        ;;
    *"Lock"*)
        pidof hyprlock >/dev/null || hyprlock
        ;;
    *"Logout"*)
        confirm_action "Logout" && hyprctl dispatch 'hl.dsp.exit()'
        ;;
    *"Suspend"*)
        systemctl suspend
        ;;
esac