CURRENT_THEME_FILE="$HOME/.config/hypr/current_theme.txt"

if [ -f "$CURRENT_THEME_FILE" ]; then
    CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")
    notify-send "Current Active Theme" "Theme: $CURRENT_THEME\nWallpaper switcher is locked to: ~/Pictures/Wallpaper/$CURRENT_THEME/"
else
    notify-send "No Active Theme" "Please run theme switcher first (Mod+T)"
fi