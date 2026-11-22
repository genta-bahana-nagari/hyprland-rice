#!/usr/bin/env bash
set -euo pipefail

WAYBAR="$HOME/.config/waybar"
LAYOUTS="$WAYBAR/themes"
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-layout"
ROFI_THEME="$HOME/.config/rofi/styles/theme-switcher.rasi"
NOTIFY_ICON="$HOME/.config/swaync/icons/palette.png"

# ---------------------------------------------------------
# Scan layout directories (only dirs with config.jsonc + style.css)
# ---------------------------------------------------------

mapfile -t layouts < <(
    find "$LAYOUTS" -mindepth 1 -maxdepth 1 -type d \
        -exec test -f {}/config.jsonc -a -f {}/style.css \; \
        -printf '%f\n' | sort -f
)

if [[ ${#layouts[@]} -eq 0 ]]; then
    notify-send "Waybar Layout" "No valid layouts found (need config.jsonc + style.css)."
    exit 1
fi

# ---------------------------------------------------------
# Build display names + mark current layout
# ---------------------------------------------------------

# Read current layout from state file (default: "default")
current_layout="default"
if [[ -f "$STATE" ]]; then
    current_layout="$(cat "$STATE")"
fi

display_names=()
for layout in "${layouts[@]}"; do
    # Simple prettification: replace _ and - with space, title-case each word
    display="$(printf '%s' "$layout" | sed 's/_/ /g; s/-/ /g' \
        | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')"

    # Mark the currently active layout with a checkmark prefix
    if [[ "$layout" == "$current_layout" ]]; then
        display="  $display"
    fi

    display_names+=("$display")
done


# ---------------------------------------------------------
# Show Rofi menu
# ---------------------------------------------------------

selected=$(
    printf '%s\n' "${display_names[@]}" |
        rofi -dmenu -i -p "Waybar Layout" -theme "$ROFI_THEME"
)

[[ -z "$selected" ]] && exit 0


# ---------------------------------------------------------
# Find selected layout folder name
# ---------------------------------------------------------

# Strip   prefix if present for matching
search="$(printf '%s' "$selected" | sed 's/  //')"

layout=""
for i in "${!display_names[@]}"; do
    # Get the display name without the   prefix
    entry="$(printf '%s' "${display_names[$i]}" | sed 's/  //')"
    if [[ "$entry" == "$search" ]]; then
        layout="${layouts[$i]}"
        break
    fi
done

[[ -z "$layout" ]] && {
    notify-send "Error Waybar Layout" "Could not find selected layout."
    exit 1
}


# ---------------------------------------------------------
# Write active layout state
# ---------------------------------------------------------

echo "$layout" > "$STATE"


# ---------------------------------------------------------
# Restart Waybar cleanly via launch.sh
# ---------------------------------------------------------

pkill -x waybar 2>/dev/null || true
sleep 0.3

if ! "$WAYBAR/scripts/launch.sh"; then
    notify-send "Error Waybar Layout" "Failed to start Waybar."
    exit 1
fi


# ---------------------------------------------------------
# Notification confirming the new layout
# ---------------------------------------------------------

notify-send -i "$NOTIFY_ICON" "Waybar Layout" "Switched to $layout"