#!/usr/bin/env bash

theme="$HOME/.config/rofi/styles/wallpaper-switch.rasi"
WALL_DIR="$HOME/Pictures/Wallpaper"
LOCK_WALL="$HOME/.cache/current-wallpaper"
THEME_CONF="$HOME/.local/state/hypr-rice/theme.conf"

mkdir -p "$HOME/.cache"

if [[ -f "$THEME_CONF" ]]; then
    source "$THEME_CONF"
    if [[ -n "${FOLDER:-}" && -d "$WALL_DIR/$FOLDER" ]]; then
        WALL_DIR="$WALL_DIR/$FOLDER"
    fi
fi

if [ ! -d "$WALL_DIR" ]; then
    echo "Error: Wallpaper directory $WALL_DIR does not exist."
    exit 1
fi

CHOICE=$(find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" \
       -o -iname "*.png" -o -iname "*.webp" \) -print0 |
    xargs -0 -r -I {} sh -c 'printf "%s\0icon\x1f%s\n" "$(basename "$1")" "$1"' _ {} |
    rofi -dmenu -i -show-icons -theme "$theme" -p "Wallpaper")

[ -z "$CHOICE" ] && exit 0

WALLPAPER="$WALL_DIR/$CHOICE"

CURSOR_POS=$(hyprctl cursorpos 2>/dev/null | tr -d ' ')
[ -z "$CURSOR_POS" ] && CURSOR_POS="0.5,0.5"

TRANSITIONS=(
    "--transition-type wipe --transition-bezier .34,1.19,1,.4"
    "--transition-type grow --transition-pos $CURSOR_POS --transition-bezier .22,1,.36,1"
    "--transition-type wave --transition-angle 45 --transition-wave 40,20"
    "--transition-type outer --transition-pos $CURSOR_POS --transition-bezier .22,1,.36,1"
)
RANDOM_TRANSITION="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"

awww img "$WALLPAPER" \
    $RANDOM_TRANSITION \
    --transition-fps 60 \
    --transition-duration 0.8 &

ln -sfn "$WALLPAPER" "$LOCK_WALL" &

wallust run "$WALLPAPER" -s

pkill -SIGUSR2 -x waybar 2>/dev/null &
swaync-client -rs >/dev/null 2>&1 &
pkill -SIGUSR1 -x kitty 2>/dev/null &
hyprctl reload >/dev/null 2>&1 &

notify-send "Wallpaper Changed!" "$CHOICE" &
wait