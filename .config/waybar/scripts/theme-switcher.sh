#!/usr/bin/env bash

WAYBAR="$HOME/.config/waybar"
THEMES="$WAYBAR/themes"

theme=$(
    find "$THEMES" -mindepth 1 -maxdepth 1 -type d \
    | xargs -n1 basename \
    | sort \
    | rofi -dmenu \
        -i \
        -p "Waybar Theme" \
        -theme ~/.config/rofi/styles/theme-switcher.rasi
)

[ -z "$theme" ] && exit

ln -sf "$THEMES/$theme/config.jsonc" "$WAYBAR/config.jsonc"
ln -sf "$THEMES/$theme/style.css" "$WAYBAR/style.css"

pkill waybar
"$WAYBAR/scripts/launch.sh"