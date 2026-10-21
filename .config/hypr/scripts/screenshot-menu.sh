#!/bin/bash
# Screenshot menu with edit/upload options

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Rofi menu options
OPTIONS="󰹑  Fullscreen\n  Region\n  Window\n  Fullscreen (5s delay)"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Screenshot" -theme ~/.config/rofi/styles/simple.rasi)

case "$CHOICE" in
    *"Fullscreen")
        FILE="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        hyprshot -m output -o "$SCREENSHOT_DIR" && notify-send "Screenshot" "Saved to Screenshots"
        ;;
    *"Region")
        FILE="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        hyprshot -m region -o "$SCREENSHOT_DIR" && notify-send "Screenshot" "Saved to Screenshots"
        ;;
    *"Window")
        FILE="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        hyprshot -m window -o "$SCREENSHOT_DIR" && notify-send "Screenshot" "Saved to Screenshots"
        ;;
    *"delay")
        notify-send "Screenshot" "Starting in 5 seconds..."
        sleep 5
        hyprshot -m output -o "$SCREENSHOT_DIR" && notify-send "Screenshot" "Saved to Screenshots"
        ;;
esac
