#!/usr/bin/env bash

theme="$HOME/.config/rofi/styles/wallpaperswitch.rasi"
WALL_DIR="$HOME/Pictures/Wallpaper"

CHOICE=$(find "$WALL_DIR" -maxdepth 1 -type f | while read -r img; do
    name=$(basename "$img")
    printf "%s\x00icon\x1f%s\n" "$name" "$img"
done | rofi -dmenu -i -theme "$theme" -p "Wallpaper")

[ -z "$CHOICE" ] && exit

awww img "$WALL_DIR/$CHOICE" \
    --transition-type grow \
    --transition-duration 1

notify-send "Wallpaper Changed!"