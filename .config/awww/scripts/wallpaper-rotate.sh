
#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpaper"
LOCK_WALL="$HOME/.cache/current-wallpaper"
INTERVAL=600

mkdir -p "$HOME/.cache"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
    exit 1
fi

shopt -s nullglob nocaseglob
wallpapers=(
    "$WALLPAPER_DIR"/*.jpg
    "$WALLPAPER_DIR"/*.jpeg
    "$WALLPAPER_DIR"/*.png
    "$WALLPAPER_DIR"/*.webp
)

if [ ${#wallpapers[@]} -eq 0 ]; then
    exit 1
fi

while true; do
    wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

    # Change desktop wallpaper
    awww img "$wallpaper" \
        --transition-type fade \
        --transition-duration 1

    # Sync Hyprlock wallpaper
    ln -sfn "$wallpaper" "$LOCK_WALL"

    sleep "$INTERVAL"
done