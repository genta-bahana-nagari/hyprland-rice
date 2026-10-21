#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================================
# Hyprland Rice Updater
# Pulls the latest configs from the repository and deploys
# them into ~/.config (packages are not touched).
# ==========================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ----------------------------------------------------------
# Checks
# ----------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}:: git is required.${NONE}"
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
    echo -e "${RED}:: This is not a git clone of the repository.${NONE}"
    echo ":: Clone it first:"
    echo "   git clone https://github.com/genta-bahana-nagari/hyprland-rice.git"
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR/.config" ]]; then
    echo -e "${RED}:: Config directory not found:${NONE}"
    echo "   $SCRIPT_DIR/.config"
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo -e "${YELLOW}:: Local changes detected in $SCRIPT_DIR.${NONE}"
    echo ":: git pull may fail; commit or discard them first."
    echo
fi

# ----------------------------------------------------------
# Back up deployed configs
# ----------------------------------------------------------

backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo ":: Backing up current configs to:"
echo "   $backup_dir"

mkdir -p "$backup_dir"

for entry in .config/*/; do
    name="$(basename "$entry")"
    if [[ -d "$HOME/.config/$name" ]]; then
        cp -a "$HOME/.config/$name" "$backup_dir/"
    fi
done

echo ":: Backup complete."
echo

# ----------------------------------------------------------
# Remember the selected Waybar theme
# ----------------------------------------------------------

current_theme=""
if [[ -L "$HOME/.config/waybar/config.jsonc" ]]; then
    current_theme="$(
        basename "$(
            dirname "$(readlink -f "$HOME/.config/waybar/config.jsonc" 2>/dev/null || echo)"
        )"
    )"
fi

# ----------------------------------------------------------
# Pull latest changes
# ----------------------------------------------------------

before="$(git rev-parse --short HEAD)"

echo ":: Pulling latest configuration from origin..."
echo

git pull --ff-only

after="$(git rev-parse --short HEAD)"

echo
if [[ "$before" == "$after" ]]; then
    echo ":: Already up to date ($after). Redeploying anyway."
else
    echo ":: Updated from $before to $after."
fi
echo

# ----------------------------------------------------------
# Deploy configs
# ----------------------------------------------------------

echo ":: Deploying configuration files..."

mkdir -p "$HOME/.config"

cp -rf .config/* "$HOME/.config/"

# The repo's Waybar symlinks point at the author's home directory,
# so replace them with a relative link to the selected theme.
if [[ -z "$current_theme" ||
      ! -f "$HOME/.config/waybar/themes/$current_theme/config.jsonc" ]]; then
    current_theme="default"
fi

ln -sfn "themes/$current_theme/config.jsonc" "$HOME/.config/waybar/config.jsonc"
ln -sfn "themes/$current_theme/style.css" "$HOME/.config/waybar/style.css"
echo ":: Waybar theme: $current_theme"

# ----------------------------------------------------------
# Script permissions
# ----------------------------------------------------------

for dir in \
    "$HOME/.config/hypr/scripts" \
    "$HOME/.config/waybar/scripts" \
    "$HOME/.config/rofi"; do
    [[ -d "$dir" ]] || continue
    find "$dir" -type f -name "*.sh" -exec chmod +x {} \;
done

# ----------------------------------------------------------
# User systemd services
# ----------------------------------------------------------

if [[ -d ".config/hypr/service" ]]; then
    mkdir -p "$HOME/.config/systemd/user"
    find ".config/hypr/service" \
        -type f \
        -name "*.service" \
        -exec cp -f {} "$HOME/.config/systemd/user/" \;
    systemctl --user daemon-reload
    echo ":: User services updated."
fi

# ----------------------------------------------------------
# Wallpapers (never overwrite user wallpapers)
# ----------------------------------------------------------

if [[ -d "Wallpaper" ]]; then
    mkdir -p "$HOME/Pictures/Wallpaper"
    cp -n Wallpaper/* "$HOME/Pictures/Wallpaper/" 2>/dev/null || true
fi

echo ":: Configuration deployed."
echo

# ----------------------------------------------------------
# Reload the running desktop
# ----------------------------------------------------------

echo ":: Reloading desktop components..."

if command -v hyprctl >/dev/null 2>&1 &&
   [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprctl reload >/dev/null 2>&1 || true
    echo ":: Hyprland reloaded."
fi

if pgrep -x waybar >/dev/null 2>&1; then
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
    echo ":: Waybar reloaded."
fi

if pgrep -x swaync >/dev/null 2>&1; then
    swaync-client -rs >/dev/null 2>&1 || true
    echo ":: SwayNC reloaded."
fi

# ----------------------------------------------------------
# Done
# ----------------------------------------------------------

echo
echo -e "${GREEN}==============================================${NONE}"
echo -e "${GREEN}            UPDATE COMPLETE                   ${NONE}"
echo -e "${GREEN}==============================================${NONE}"
echo
echo ":: Configuration: $HOME/.config/"
echo ":: Backup:        $backup_dir"
echo
echo ":: Packages were not changed. Re-run install.sh"
echo ":: to update packages, or use your package manager."
echo
