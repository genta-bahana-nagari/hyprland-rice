#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Hyprland Rice — Curated Theme Switcher (Super + Shift + T)
# ============================================================

STATE_DIR="$HOME/.local/state/hypr-rice"
THEME_CONF="$STATE_DIR/theme.conf"
ROTATE_CONF="$STATE_DIR/wallpaper-rotate.conf"
WALLPAPER_ROOT="$HOME/Pictures/Wallpaper"
LOCK_WALL="$HOME/.cache/current-wallpaper"

ROFI_THEME="$HOME/.config/rofi/styles/theme-switcher.rasi"
NOTIFY_ICON="$HOME/.config/swaync/icons/palette.png"

# ── Daftar tema populer ──────────────────────────────────────
THEMES=(
    "Default (Dynamic Wallpaper)"
    "Catppuccin Mocha"
    "Catppuccin Latte"
    "Gruvbox Dark"
    "Gruvbox Light"
    "Tokyo Night"
    "Nord"
    "Rose Pine"
    "Dracula"
    "Everforest"
    "Kanagawa"
    "Solarized Dark"
    "One Dark"
    "Material Ocean"
    "Ayu Dark"
    "Cyberpunk / Neon"
    "Monochrome"
)

# ── Mapping nama tema ke subfolder wallpaper ─────────────────
folder_for() {
    case "$1" in
        "Default (Dynamic Wallpaper)") echo "default" ;;
        "Catppuccin Mocha")            echo "catppuccin-mocha" ;;
        "Catppuccin Latte")            echo "catppuccin-latte" ;;
        "Gruvbox Dark")                echo "gruvbox" ;;
        "Gruvbox Light")               echo "gruvbox" ;;
        "Tokyo Night")                 echo "tokyo-night" ;;
        "Nord")                        echo "nord" ;;
        "Rose Pine")                   echo "rose-pine" ;;
        "Dracula")                     echo "dracula" ;;
        "Everforest")                  echo "everforest" ;;
        "Kanagawa")                    echo "kanagawa" ;;
        "Solarized Dark")              echo "solarized" ;;
        "One Dark")                    echo "one-dark" ;;
        "Material Ocean")              echo "material-ocean" ;;
        "Ayu Dark")                    echo "ayu" ;;
        "Cyberpunk / Neon")            echo "cyberpunk" ;;
        "Monochrome")                  echo "monochrome" ;;
        *)                             echo "default" ;;
    esac
}

# ── Terapkan palet warna via Wallust ─────────────────────────
apply_wallust_theme() {
    local theme="$1"
    local wall="$2"
    local preset=""

    case "$theme" in
        "Default (Dynamic Wallpaper)")
            if [[ -n "$wall" ]]; then
                wallust run "$wall" -s
            fi
            return 0
            ;;
        "Catppuccin Mocha") preset="Catppuccin-Mocha" ;;
        "Catppuccin Latte") preset="Catppuccin-Latte" ;;
        "Gruvbox Dark")     preset="Gruvbox-Dark" ;;
        "Gruvbox Light")    preset="Gruvbox-Light" ;;
        "Tokyo Night")      preset="Tokyo-Night" ;;
        "Nord")             preset="Nord" ;;
        "Rose Pine")        preset="Rosé-Pine" ;;
        "Dracula")          preset="Dracula" ;;
        "Everforest")       preset="Everforest-Dark-Medium" ;;
        "Kanagawa")         preset="Kanagawa" ;;
        "Solarized Dark")   preset="Solarized-Dark" ;;
        "One Dark")         preset="One-Dark" ;;
        "Material Ocean")   preset="Material-Ocean" ;;
        "Ayu Dark")         preset="Ayu-Dark" ;;
        "Monochrome")       preset="base16-grayscale-dark" ;;
        *)                  preset="" ;;
    esac

    # Coba jalankan preset bawaan wallust; jika gagal/tidak ada di versi wallust,
    # otomatis fallback mengekstrak warna langsung dari wallpaper tema tersebut.
    if [[ -n "$preset" ]] && wallust theme "$preset" -s 2>/dev/null; then
        return 0
    elif [[ -n "$wall" ]]; then
        wallust run "$wall" -s
    fi
}

# ── Ambil wallpaper acak dari folder tema (dengan fallback) ──
pick_wallpaper() {
    local dir="$1"
    [[ -d "$dir" ]] || return 1
    shopt -s nullglob nocaseglob
    local imgs=("$dir"/*.jpg "$dir"/*.jpeg "$dir"/*.png "$dir"/*.webp)
    shopt -u nullglob nocaseglob
    [[ ${#imgs[@]} -gt 0 ]] || return 1

    # Pilih acak agar tidak selalu gambar pertama jika ada banyak wallpaper di folder tema
    local rand_idx=$(( RANDOM % ${#imgs[@]} ))
    printf '%s\n' "${imgs[$rand_idx]}"
}

# ── Live-reload seluruh komponen desktop ─────────────────────
reload_desktop() {
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
    swaync-client -rs >/dev/null 2>&1 || true
    kill -SIGUSR1 $(pidof kitty) 2>/dev/null || true
    hyprctl reload >/dev/null 2>&1 || true
}

# ── Main ─────────────────────────────────────────────────────
mkdir -p "$STATE_DIR" "$HOME/.cache"

# Baca tema aktif saat ini
CURRENT_THEME="Default (Dynamic Wallpaper)"
if [[ -f "$THEME_CONF" ]]; then
    # shellcheck disable=SC1090
    source "$THEME_CONF"
    CURRENT_THEME="${THEME:-Default (Dynamic Wallpaper)}"
fi

# Buat daftar pilihan Rofi dengan indikator tema aktif
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

# Bersihkan ikon centang / spasi di depan nama tema
chosen="${raw_chosen#  }"
chosen="${chosen#   }"

# Tentukan folder dan pilih wallpaper
folder=$(folder_for "$chosen")
theme_dir="$WALLPAPER_ROOT/$folder"

wallpaper=""
wallpaper=$(pick_wallpaper "$theme_dir") \
    || wallpaper=$(pick_wallpaper "$WALLPAPER_ROOT/default") \
    || wallpaper=$(pick_wallpaper "$WALLPAPER_ROOT") \
    || wallpaper=""

# 1. Terapkan palet warna Wallust (menulis ulang ke seluruh target di wallust.toml)
apply_wallust_theme "$chosen" "$wallpaper"

# 2. Ganti wallpaper via awww & sinkronkan Hyprlock
if [[ -n "$wallpaper" ]]; then
    awww img "$wallpaper" \
        --transition-type grow \
        --transition-fps 60 \
        --transition-duration 1.5 >/dev/null 2>&1 || true
    ln -sfn "$wallpaper" "$LOCK_WALL"
fi

# 3. Simpan state tema aktif
cat > "$THEME_CONF" <<EOF
THEME="$chosen"
FOLDER="$folder"
EOF

# Sinkronkan folder tema ke wallpaper-rotate.conf jika ada
if [[ -f "$ROTATE_CONF" ]]; then
    sed -i "s/^THEME=.*/THEME=\"$folder\"/" "$ROTATE_CONF" 2>/dev/null || true
fi

# 4. Reload semua komponen UI (Waybar, SwayNC, Kitty, Hyprland)
reload_desktop

# 5. Kirim notifikasi desktop
if [[ -f "$NOTIFY_ICON" ]]; then
    notify-send -i "$NOTIFY_ICON" "Theme Switched" "Applied: $chosen"
elif [[ -n "$wallpaper" ]]; then
    notify-send -i "$wallpaper" "Theme Switched" "Applied: $chosen"
else
    notify-send "Theme Switched" "Applied: $chosen"
fi