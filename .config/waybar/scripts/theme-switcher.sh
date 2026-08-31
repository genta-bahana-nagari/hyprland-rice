#!/usr/bin/env bash

set -u

WAYBAR="$HOME/.config/waybar"
THEMES="$WAYBAR/themes"
ROFI_THEME="$HOME/.config/rofi/styles/waybar-theme-switcher.rasi"

if [[ ! -d "$THEMES" ]]; then
    notify-send "Waybar Theme Switcher" "Themes directory not found: $THEMES"
    exit 1
fi

# Store theme directories.
mapfile -t themes < <(
    find "$THEMES" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -printf '%f\n' |
        sort -f
)

if [[ ${#themes[@]} -eq 0 ]]; then
    notify-send "Waybar Theme Switcher" "No themes found."
    exit 1
fi

display_names=()

for theme in "${themes[@]}"; do
    display_name="${theme//_/ }"

    display_name=$(printf '%s\n' "$display_name" |
        awk '{
            for (i = 1; i <= NF; i++)
                $i = toupper(substr($i,1,1)) substr($i,2)
            print
        }'
    )

    display_names+=("$display_name")
done

selected=$(
    printf '%s\n' "${display_names[@]}" |
        rofi \
            -dmenu \
            -i \
            -p "Waybar Theme" \
            -theme "$ROFI_THEME"
)

[[ -z "$selected" ]] && exit 0

theme=""

for i in "${!display_names[@]}"; do
    if [[ "${display_names[$i]}" == "$selected" ]]; then
        theme="${themes[$i]}"
        break
    fi
done

if [[ -z "$theme" ]]; then
    notify-send "Waybar Theme Switcher" "Could not find selected theme."
    exit 1
fi

THEME_DIR="$THEMES/$theme"

if [[ ! -f "$THEME_DIR/config.jsonc" ]]; then
    notify-send "Waybar Theme Switcher" \
        "Missing config.jsonc in $theme"
    exit 1
fi

if [[ ! -f "$THEME_DIR/style.css" ]]; then
    notify-send "Waybar Theme Switcher" \
        "Missing style.css in $theme"
    exit 1
fi

ln -sfn "$THEME_DIR/config.jsonc" "$WAYBAR/config.jsonc"
ln -sfn "$THEME_DIR/style.css" "$WAYBAR/style.css"

pkill waybar 2>/dev/null || true

sleep 0.2

"$WAYBAR/scripts/launch.sh"

notify-send "Waybar Theme Changed!"
