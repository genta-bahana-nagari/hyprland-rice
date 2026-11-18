#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Hyprland Rice — Curated Theme Switcher (Super + Ctrl + W)
# ============================================================

STATE_DIR="$HOME/.local/state/hypr-rice"
THEME_CONF="$STATE_DIR/theme.conf"
ROTATE_CONF="$STATE_DIR/wallpaper-rotate.conf"
WALLPAPER_ROOT="$HOME/Pictures/Wallpaper"
CACHE_DIR="$HOME/.cache/wallust"
LOCK_WALL="$HOME/.cache/current-wallpaper"

ROFI_THEME="$HOME/.config/rofi/styles/theme-switcher.rasi"

# Default (Catppuccin Mocha-ish) static baseline used by the "Default" theme.
D_BG="#1e1e2e"; D_FG="#cdd6f4"
D_C0="#45475a"; D_C1="#f38ba8"; D_C2="#a6e3a1"; D_C3="#f9e2af"
D_C4="#89b4fa"; D_C5="#cba6f7"; D_C6="#94e2d5"; D_C7="#bac2de"
D_C8="#585b70"; D_C9="#f38ba8"; D_C10="#a6e3a1"; D_C11="#f9e2af"
D_C12="#89b4fa"; D_C13="#cba6f7"; D_C14="#94e2d5"; D_C15="#bac2de"

THEMES=(
    "Default"
    "Catppuccin Mocha"
    "Gruvbox Dark"
    "Tokyo Night"
    "Nord"
    "Rose Pine"
    "Cyberpunk / Neon"
    "Monochrome"
)

folder_for() {
    case "$1" in
        Default) echo "default" ;;
        "Catppuccin Mocha") echo "catppuccin" ;;
        "Gruvbox Dark") echo "gruvbox" ;;
        "Tokyo Night") echo "tokyo-night" ;;
        Nord) echo "nord" ;;
        "Rose Pine") echo "rose-pine" ;;
        "Cyberpunk / Neon") echo "cyberpunk" ;;
        Monochrome) echo "monochrome" ;;
        *) echo "default" ;;
    esac
}

pick_wallpaper() {
    local dir="$1"
    [[ -d "$dir" ]] || return 1
    shopt -s nullglob nocaseglob
    local imgs=("$dir"/*.jpg "$dir"/*.jpeg "$dir"/*.png "$dir"/*.webp)
    shopt -u nullglob nocaseglob
    [[ ${#imgs[@]} -gt 0 ]] || return 1
    printf '%s\n' "${imgs[0]}"
}

write_default_baseline() {
    cat > "$CACHE_DIR/colors-rofi.rasi" <<EOF
* {
    background: $D_BG;
    foreground: $D_FG;
    color0: $D_C0; color1: $D_C1; color2: $D_C2; color3: $D_C3;
    color4: $D_C4; color5: $D_C5; color6: $D_C6; color7: $D_C7;
    color8: $D_C8; color9: $D_C9; color10: $D_C10; color11: $D_C11;
    color12: $D_C12; color13: $D_C13; color14: $D_C14; color15: $D_C15;
    selected: $D_C4;
    background-alt: $D_C0;
    urgent: $D_C1;
    active: $D_C2;
    border-colour: $D_C8;
    handle-colour: $D_C4;
}
EOF

    cat > "$CACHE_DIR/colors-swaync.css" <<EOF
@define-color background $D_BG;
@define-color foreground $D_FG;
@define-color color0 $D_C0; @define-color color1 $D_C1;
@define-color color2 $D_C2; @define-color color3 $D_C3;
@define-color color4 $D_C4; @define-color color5 $D_C5;
@define-color color6 $D_C6; @define-color color7 $D_C7;
@define-color color8 $D_C8; @define-color color9 $D_C9;
@define-color color10 $D_C10; @define-color color11 $D_C11;
@define-color color12 $D_C12; @define-color color13 $D_C13;
@define-color color14 $D_C14; @define-color color15 $D_C15;
EOF

    cat > "$CACHE_DIR/colors-waybar.css" <<EOF
@define-color background $D_BG;
@define-color foreground $D_FG;
@define-color color0 $D_C0; @define-color color1 $D_C1;
@define-color color2 $D_C2; @define-color color3 $D_C3;
@define-color color4 $D_C4; @define-color color5 $D_C5;
@define-color color6 $D_C6; @define-color color7 $D_C7;
@define-color color8 $D_C8; @define-color color9 $D_C9;
@define-color color10 $D_C10; @define-color color11 $D_C11;
@define-color color12 $D_C12; @define-color color13 $D_C13;
@define-color color14 $D_C14; @define-color color15 $D_C15;
EOF

    cat > "$CACHE_DIR/colors-kitty.conf" <<EOF
background $D_BG
foreground $D_FG
color0  $D_C0
color1  $D_C1
color2  $D_C2
color3  $D_C3
color4  $D_C4
color5  $D_C5
color6  $D_C6
color7  $D_C7
color8  $D_C8
color9  $D_C9
color10 $D_C10
color11 $D_C11
color12 $D_C12
color13 $D_C13
color14 $D_C14
color15 $D_C15
EOF

    cat > "$CACHE_DIR/colors-hyprland.lua" <<EOF
return {
    general = {
        col = {
            active_border   = "$D_C4",
            inactive_border = "$D_C8",
        },
    },
}
EOF
}

reload_desktop() {
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
    swaync-client -rs >/dev/null 2>&1 || true
    hyprctl reload >/dev/null 2>&1 || true
}

mkdir -p "$STATE_DIR" "$CACHE_DIR"

# Baca tema aktif saat ini agar bisa ditandai
CURRENT_THEME="Default"
if [[ -f "$THEME_CONF" ]]; then
    # shellcheck disable=SC1090
    source "$THEME_CONF"
    CURRENT_THEME="${THEME//\\/}"
fi

# Buat daftar pilihan dengan indikator tema aktif
list=""
for t in "${THEMES[@]}"; do
    if [[ "$t" == "$CURRENT_THEME" ]]; then
        list+="  $t"$'\n'
    else
        list+="   $t"$'\n'
    fi
done

raw_chosen=$(printf '%s' "$list" | rofi -dmenu -i \
    -p "Theme" \
    -mesg "Active: $CURRENT_THEME  •  Enter: Apply Theme" \
    -theme "$ROFI_THEME")
[[ -z "$raw_chosen" ]] && exit 0

# Bersihkan spasi/ikon centang di depan nama tema
chosen="${raw_chosen#  }"
chosen="${chosen#   }"

folder=$(folder_for "$chosen")
theme_dir="$WALLPAPER_ROOT/$folder"

wallpaper=$(pick_wallpaper "$theme_dir") \
    || wallpaper=$(pick_wallpaper "$WALLPAPER_ROOT/default") \
    || wallpaper=$(pick_wallpaper "$WALLPAPER_ROOT") \
    || wallpaper=""

# Simpan pilihan tema aktif (bersih tanpa escape backslash)
cat > "$THEME_CONF" <<EOF
THEME="$chosen"
FOLDER="$folder"
EOF

# Sinkronkan folder tema ke wallpaper-rotate.conf jika ada
if [[ -f "$ROTATE_CONF" ]]; then
    sed -i "s/^THEME=.*/THEME=\"$folder\"/" "$ROTATE_CONF" 2>/dev/null || true
fi

if [[ -n "$wallpaper" ]]; then
    awww img "$wallpaper" --transition-type grow --transition-fps 60 --transition-duration 1.5 >/dev/null 2>&1 || true
    ln -sfn "$wallpaper" "$LOCK_WALL"
fi

if [[ -n "$wallpaper" && "$chosen" != "Default" ]]; then
    wallust_bin=$(command -v wallust || command -v "$HOME/.local/bin/wallust" || command -v "$HOME/.cargo/bin/wallust" || true)
    if [[ -n "$wallust_bin" ]]; then
        "$wallust_bin" run "$wallpaper" >/dev/null 2>&1 || true
    fi
    reload_desktop
    notify-send -i "$wallpaper" "Theme Switched" "$chosen (dynamic)"
else
    write_default_baseline
    reload_desktop
    notify-send "Theme Switched" "$chosen (static baseline)"
fi