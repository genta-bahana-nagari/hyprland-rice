#!/usr/bin/env bash

set -u

WAYBAR="$HOME/.config/waybar"
LAYOUTS="$WAYBAR/themes"
ROFI_THEME="$HOME/.config/rofi/styles/waybar-theme-switcher.rasi"


# ---------------------------------------------------------
# Check layout directory
# ---------------------------------------------------------

if [[ ! -d "$LAYOUTS" ]]; then
    notify-send \
        "Waybar Layout Switcher" \
        "Layouts directory not found: $LAYOUTS"
    exit 1
fi


# ---------------------------------------------------------
# Get layout directories (only directories with config.jsonc + style.css)
# ---------------------------------------------------------

mapfile -t layouts < <(
    find "$LAYOUTS" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -exec test -f {}/config.jsonc -a -f {}/style.css \; \
        -printf '%f\n' |
        sort -f
)

if [[ ${#layouts[@]} -eq 0 ]]; then
    notify-send \
        "Waybar Layout Switcher" \
        "No valid layouts found (need config.jsonc + style.css)."
    exit 1
fi


# ---------------------------------------------------------
# Generate pretty display names
# ---------------------------------------------------------

display_names=()

for layout in "${layouts[@]}"; do
    display_name="${layout//_/ }"

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
            -p "Waybar Layout" \
            -theme "$ROFI_THEME"
)

[[ -z "$selected" ]] && exit 0


# ---------------------------------------------------------
# Find selected layout
# ---------------------------------------------------------

layout=""
selected_index=-1

for i in "${!display_names[@]}"; do
    if [[ "${display_names[$i]}" == "$selected" ]]; then
        layout="${layouts[$i]}"
        selected_index="$i"
        break
    fi
done


# ---------------------------------------------------------
# Validate selection
# ---------------------------------------------------------

if [[ -z "$layout" || "$selected_index" -lt 0 ]]; then
    notify-send \
        "Error Waybar Layout" \
        "Could not find selected layout."
    exit 1
fi


# ---------------------------------------------------------
# Get the actual selected display name
# ---------------------------------------------------------

display_name="${display_names[$selected_index]}"


# ---------------------------------------------------------
# Layout paths
# ---------------------------------------------------------

LAYOUT_DIR="$LAYOUTS/$layout"
CONFIG="$LAYOUT_DIR/config.jsonc"
STYLE="$LAYOUT_DIR/style.css"


# ---------------------------------------------------------
# Validate layout files
# ---------------------------------------------------------

if [[ ! -f "$CONFIG" ]]; then
    notify-send \
        "Error Waybar Layout" \
        "Missing config.jsonc in $layout"
    exit 1
fi

if [[ ! -f "$STYLE" ]]; then
    notify-send \
        "Error Waybar Layout" \
        "Missing style.css in $layout"
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
        "Error Waybar Layout" \
        "Failed to start Waybar."
    exit 1
fi


# ---------------------------------------------------------
# Notification
# ---------------------------------------------------------

notify-send \
    "Waybar Layout" \
    "Switched to $display_name"
