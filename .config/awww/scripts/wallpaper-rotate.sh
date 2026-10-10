
#!/usr/bin/env bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpaper"

# Interval in seconds (10 minutes)
INTERVAL=600

# Supported image formats
shopt -s nullglob nocaseglob
wallpapers=(
    "$WALLPAPER_DIR"/*.jpg
    "$WALLPAPER_DIR"/*.jpeg
    "$WALLPAPER_DIR"/*.png
    "$WALLPAPER_DIR"/*.webp
)

# Check if wallpapers exist
if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Rotate wallpapers forever
while true; do
    # Select a random wallpaper
    wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

    # Apply wallpaper with a transition
    awww img "$wallpaper" \
        --transition-type fade \
        --transition-duration 1

    notify-send "Wallpaper changed to: $wallpaper"

    # Wait for the next rotation
    sleep "$INTERVAL"
done
