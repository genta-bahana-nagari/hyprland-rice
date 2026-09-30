#!/bin/bash

theme="$HOME/.config/rofi/styles/wifimanager-style.rasi"
pass_theme="$HOME/.config/rofi/styles/wifipassword-style.rasi"

nmcli radio wifi on

# Scan Wi-Fi
nmcli device wifi rescan 2>/dev/null
sleep 1

networks=$(nmcli -t -f SSID,SECURITY device wifi list | sed '/^$/d')

if [ -z "$networks" ]; then
    notify-send "Wi-Fi" "No Wi-Fi networks found"
    exit 1
fi

ssid_list=$(echo "$networks" |
    cut -d: -f1 |
    sed '/^$/d' |
    sort -u)

chosen=$(echo "$ssid_list" |
    rofi -dmenu \
    -theme "$theme" \
    -p "Select Wi-Fi")

[ -z "$chosen" ] && exit 0

ssid="$chosen"

# ==================================================
# Check existing NetworkManager connection profile
# ==================================================

profile=$(nmcli -t -f NAME,TYPE connection show |
    awk -F: -v ssid="$ssid" '$2=="802-11-wireless" && $1==ssid {print $1; exit}')

if [ -n "$profile" ]; then

    # Profile already exists.
    # NetworkManager already knows the password.
    if nmcli connection up "$profile"; then
        notify-send "Wi-Fi" "Connected to $ssid"
    else
        notify-send "Wi-Fi" "Failed to connect to $ssid"
    fi

    exit $?
fi

# ==================================================
# No profile → first-time connection
# ==================================================

secured=$(echo "$networks" |
    awk -F: -v s="$ssid" '$1==s {print $2; exit}')

if [ -n "$secured" ] && [ "$secured" != "--" ]; then

    password=$(rofi -dmenu \
        -theme "$pass_theme" \
        -p "$ssid" \
        -password)

    [ -z "$password" ] && exit 0

    if nmcli device wifi connect "$ssid" password "$password"; then
        notify-send "Wi-Fi" "Connected to $ssid"
    else
        notify-send "Wi-Fi" "Failed to connect to $ssid"
        exit 1
    fi

else

    if nmcli device wifi connect "$ssid"; then
        notify-send "Wi-Fi" "Connected to $ssid"
    else
        notify-send "Wi-Fi" "Failed to connect to $ssid"
        exit 1
    fi

fi