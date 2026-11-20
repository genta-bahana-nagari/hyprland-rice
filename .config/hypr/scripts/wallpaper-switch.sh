#!/usr/bin/env bash

theme="$HOME/.config/rofi/styles/wallpaper-switch.rasi"
WALL_DIR="$HOME/Pictures/Wallpaper"
LOCK_WALL="$HOME/.cache/current-wallpaper"

mkdir -p "$HOME/.cache"

if [ ! -d "$WALL_DIR" ]; then
    echo "Error: Wallpaper directory $WALL_DIR does not exist."
    exit 1
fi

CHOICE=$(find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" \
       -o -iname "*.png" -o -iname "*.webp" \) |
    while read -r img; do
        name=$(basename "$img")
        printf "%s\x00icon\x1f%s\n" "$name" "$img"
    done | rofi -dmenu -i -theme "$theme" -p "Wallpaper")

[ -z "$CHOICE" ] && exit 0

WALLPAPER="$WALL_DIR/$CHOICE"

# Change desktop wallpaper
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1

# Sync wallpaper for Hyprlock
ln -sfn "$WALLPAPER" "$LOCK_WALL"

# Generate Wallust palette and reload UI
wallust run "$WALLPAPER" -s

# Live-reload UI components
pkill -SIGUSR2 -x waybar 2>/dev/null || true
swaync-client -rs 2>/dev/null || true
kill -SIGUSR1 $(pidof kitty) 2>/dev/null || true
hyprctl reload 2>/dev/null || true

notify-send "Wallpaper Changed!" "$CHOICE"
