#!/bin/bash
# Window search and switcher
THEME="$HOME/.config/rofi/styles/wifimanager-style.rasi"

# Get all windows with their info
WINDOWS=$(hyprctl clients -j | jq -r '.[] | "\(.address)|\(.class)|\(.title)|\(.workspace.id)"')

if [ -z "$WINDOWS" ]; then
    notify-send "Window Switcher" "No windows open"
    exit 0
fi

# Format for rofi: icon class - title (workspace)
# Store addresses in a temp file or array to map later
mapfile -t lines <<< "$WINDOWS"
display_lines=()
for line in "${lines[@]}"; do
    addr=$(echo "$line" | cut -d'|' -f1)
    class=$(echo "$line" | cut -d'|' -f2)
    title=$(echo "$line" | cut -d'|' -f3)
    ws=$(echo "$line" | cut -d'|' -f4)
    display_lines+=("$class - $title [WS:$ws]")
done

# Show menu and get index (0-based)
selected_index=$(printf '%s\n' "${display_lines[@]}" | rofi -dmenu -i -p "Switch to Window" -format i -theme "$THEME")

if [ -n "$selected_index" ]; then
    # Get address from selection index
    addr=$(echo "$WINDOWS" | sed -n "$((selected_index + 1))p" | cut -d'|' -f1)
    hyprctl dispatch focuswindow "address:$addr"
fi
