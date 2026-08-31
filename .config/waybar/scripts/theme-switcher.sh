#!/usr/bin/env bash

set -u

WAYBAR="$HOME/.config/waybar"
THEMES="$WAYBAR/themes"
ROFI_THEME="$HOME/.config/rofi/styles/waybar-theme-switcher.rasi"


# ---------------------------------------------------------
# Check theme directory
# ---------------------------------------------------------

if [[ ! -d "$THEMES" ]]; then
    notify-send \
        "Waybar Theme Switcher" \
        "Themes directory not found: $THEMES"
    exit 1
fi


# ---------------------------------------------------------
# Get theme directories
# ---------------------------------------------------------

mapfile -t themes < <(
    find "$THEMES" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -printf '%f\n' |
        sort -f
)

if [[ ${#themes[@]} -eq 0 ]]; then
    notify-send \
        "Waybar Theme Switcher" \
        "No themes found."
    exit 1
fi


# ---------------------------------------------------------
# Generate pretty display names
# ---------------------------------------------------------

display_names=()

for theme in "${themes[@]}"; do
    display_name="${theme//_/ }"

    display_name=$(
        printf '%s\n' "$display_name" |
            awk '{
                for (i = 1; i <= NF; i++) {
                    $i = toupper(substr($i, 1, 1)) substr($i, 2)
                }
                print
            }'
    )

    # Fix V1 / V2 capitalization
    display_name="${display_name// V1/ v1}"
    display_name="${display_name// V2/ v2}"

    display_names+=("$display_name")
done


# ---------------------------------------------------------
# Show Rofi
# ---------------------------------------------------------

selected=$(
    printf '%s\n' "${display_names[@]}" |
        rofi \
            -dmenu \
            -i \
            -p "Waybar Theme" \
            -theme "$ROFI_THEME"
)

[[ -z "$selected" ]] && exit 0


# ---------------------------------------------------------
# Find selected theme
# ---------------------------------------------------------

theme=""
selected_index=-1

for i in "${!display_names[@]}"; do
    if [[ "${display_names[$i]}" == "$selected" ]]; then
        theme="${themes[$i]}"
        selected_index="$i"
        break
    fi
done


# ---------------------------------------------------------
# Validate selection
# ---------------------------------------------------------

if [[ -z "$theme" || "$selected_index" -lt 0 ]]; then
    notify-send \
        "Error Waybar Theming" \
        "Could not find selected theme."
    exit 1
fi


# ---------------------------------------------------------
# Get the actual selected display name
# ---------------------------------------------------------

display_name="${display_names[$selected_index]}"


# ---------------------------------------------------------
# Theme paths
# ---------------------------------------------------------

THEME_DIR="$THEMES/$theme"
CONFIG="$THEME_DIR/config.jsonc"
STYLE="$THEME_DIR/style.css"


# ---------------------------------------------------------
# Validate theme files
# ---------------------------------------------------------

if [[ ! -f "$CONFIG" ]]; then
    notify-send \
        "Error Waybar Theming" \
        "Missing config.jsonc in $theme"
    exit 1
fi

if [[ ! -f "$STYLE" ]]; then
    notify-send \
        "Error Waybar Theming" \
        "Missing style.css in $theme"
    exit 1
fi


# ---------------------------------------------------------
# Switch symlinks
# ---------------------------------------------------------

ln -sfn "$CONFIG" "$WAYBAR/config.jsonc"
ln -sfn "$STYLE" "$WAYBAR/style.css"


# ---------------------------------------------------------
# Restart Waybar
# ---------------------------------------------------------

pkill waybar 2>/dev/null || true

sleep 0.3

if ! "$WAYBAR/scripts/launch.sh"; then
    notify-send \
        "Error Waybar Theming" \
        "Failed to start Waybar."
    exit 1
fi


# ---------------------------------------------------------
# Notification
# ---------------------------------------------------------

notify-send \
    "Waybar Theme" \
    "Switched to $display_name"
