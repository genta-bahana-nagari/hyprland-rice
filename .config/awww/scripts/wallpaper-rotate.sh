#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Hyprland Rice — Wallpaper Rotation Loop
# ============================================================

STATE_DIR="$HOME/.local/state/hypr-rice"
THEME_CONF="$STATE_DIR/theme.conf"
ROTATE_CONF="$STATE_DIR/wallpaper-rotate.conf"
WALLPAPER_ROOT="$HOME/Pictures/Wallpaper"
LOCK_WALL="$HOME/.cache/current-wallpaper"

mkdir -p "$HOME/.cache"

pick_wallpaper() {
    local dir="$1"
    [[ -d "$dir" ]] || return 1
    shopt -s nullglob nocaseglob
    local imgs=("$dir"/*.jpg "$dir"/*.jpeg "$dir"/*.png "$dir"/*.webp)
    shopt -u nullglob nocaseglob
    [[ ${#imgs[@]} -gt 0 ]] || return 1

    local current=""
    [[ -L "$LOCK_WALL" ]] && current=$(readlink -f "$LOCK_WALL" || true)

    if [[ ${#imgs[@]} -gt 1 && -n "$current" ]]; then
        local filtered=()
        for img in "${imgs[@]}"; do
            [[ "$(readlink -f "$img")" != "$current" ]] && filtered+=("$img")
        done
        if [[ ${#filtered[@]} -gt 0 ]]; then
            printf '%s\n' "${filtered[RANDOM % ${#filtered[@]}]}"
            return 0
        fi
    fi

    printf '%s\n' "${imgs[RANDOM % ${#imgs[@]}]}"
}

while true; do
    ENABLED=false
    INTERVAL=300
    FOLDER="default"

    # shellcheck disable=SC1090
    [[ -f "$ROTATE_CONF" ]] && source "$ROTATE_CONF"
    # shellcheck disable=SC1090
    [[ -f "$THEME_CONF" ]] && source "$THEME_CONF"

    # Keluar jika auto-rotate dimatikan
    [[ "$ENABLED" == "true" ]] || exit 0

    active_folder="${FOLDER:-${THEME:-default}}"
    theme_dir="$WALLPAPER_ROOT/$active_folder"

    wallpaper=$(pick_wallpaper "$theme_dir") \
        || wallpaper=$(pick_wallpaper "$WALLPAPER_ROOT/default") \
        || wallpaper=$(pick_wallpaper "$WALLPAPER_ROOT") \
        || wallpaper=""

    if [[ -n "$wallpaper" ]]; then
        awww img "$wallpaper" \
            --transition-type grow \
            --transition-fps 60 \
            --transition-duration 1.5 \
            >/dev/null 2>&1 || true

        ln -sfn "$wallpaper" "$LOCK_WALL"

        wallust_bin=$(command -v wallust || command -v "$HOME/.local/bin/wallust" || command -v "$HOME/.cargo/bin/wallust" || true)
        if [[ -n "$wallust_bin" ]]; then
            "$wallust_bin" run "$wallpaper" -s >/dev/null 2>&1 || true
            pkill -SIGUSR2 -x waybar 2>/dev/null || true
            swaync-client -rs >/dev/null 2>&1 || true
            kill -SIGUSR1 $(pidof kitty) 2>/dev/null || true
            hyprctl reload >/dev/null 2>&1 || true
        fi
    fi

    sleep "$INTERVAL"
done