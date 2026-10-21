#!/bin/bash
# Window search and switcher

# Get all windows with their info
WINDOWS=$(hyprctl clients -j | jq -r '.[] | "\(.address)|\(.class)|\(.title)|\(.workspace.id)"')

if [ -z "$WINDOWS" ]; then
    notify-send "Window Switcher" "No windows open"
    exit 0
fi

# Format for rofi: icon class - title (workspace)
FORMATTED=$(echo "$WINDOWS" | while IFS='|' read -r addr class title ws; do
    echo "$addr| $class - $title [WS:$ws]"
done)

# Show menu
SELECTED=$(echo "$FORMATTED" | awk -F'|' '{print $2}' | rofi -dmenu -p "Switch to Window" -theme ~/.config/rofi/styles/simple.rasi)

if [ -n "$SELECTED" ]; then
    # Get address from selection
    ADDR=$(echo "$FORMATTED" | grep -F "$SELECTED" | cut -d'|' -f1)
    hyprctl dispatch focuswindow address:$ADDR
fi
