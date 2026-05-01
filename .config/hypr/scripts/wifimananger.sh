#!/bin/bash

theme="$HOME/.config/rofi/styles/wifimanager-style.rasi"
pass_theme="$HOME/.config/rofi/styles/wifipassword-style.rasi"

networks=$(nmcli -t -f SSID,SECURITY device wifi list | sed '/^$/d')

if [ -z "$networks" ]; then
    echo "No Wi-Fi networks found"
    exit 1
fi

ssid_list=$(echo "$networks" | cut -d: -f1 | sed '/^$/d' | sort -u)

chosen=$(echo "$ssid_list" | rofi -dmenu -theme "$theme" -p "Select Wi-Fi")

[ -z "$chosen" ] && exit 1

ssid="$chosen"

secured=$(echo "$networks" | awk -F: -v s="$ssid" '$1==s {print $2; exit}')

if [ -n "$secured" ] && [ "$secured" != "--" ]; then
    password=$(rofi -dmenu \
        -theme "$pass_theme" \
        -p "$ssid" \
        -password)

    [ -z "$password" ] && exit 1

    nmcli device wifi connect "$ssid" password "$password"
else
    nmcli device wifi connect "$ssid"
fi

notify-send "Connected to Wifi!"