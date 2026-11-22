#!/usr/bin/env bash

THEMES="$HOME/.config/waybar/themes"
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-layout"

# Read active layout from state file (default: "default")
LAYOUT="default"
if [[ -f "$STATE" ]]; then
    LAYOUT="$(cat "$STATE")"
fi

pkill waybar
pkill swaync

while pgrep -x waybar >/dev/null; do
    sleep 0.2
done

waybar -c "$THEMES/$LAYOUT/config.jsonc" -s "$THEMES/$LAYOUT/style.css" &
swaync &