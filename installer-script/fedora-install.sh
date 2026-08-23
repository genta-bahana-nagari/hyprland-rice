#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================================
# Fedora Hyprland Installer
# Target: Fedora 43
# ==========================================================

# ----------------------------------------------------------
# Colors
# ----------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NONE='\033[0m'

# ----------------------------------------------------------
# Script / project directory
# ----------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

# ----------------------------------------------------------
# Error handler
# ----------------------------------------------------------

trap 'echo -e "${RED}:: Installation stopped at line $LINENO.${NONE}"' ERR

# ----------------------------------------------------------
# Packages
# ----------------------------------------------------------

packages=(
    # Hyprland
    "hyprland"
    "xdg-desktop-portal-hyprland"
    "hyprpolkitagent"
    "hypridle"
    "hyprlock"
    "hyprshot"

    # Wayland / Qt
    "qt5-qtwayland"
    "qt6-qtwayland"

    # Login / terminal / applications
    "sddm"
    "kitty"
    "firefox"
    "kate"
    "nautilus"
    "loupe"
    "vlc"

    # Desktop / launcher / bar
    "rofi-wayland"
    "waybar"
    "nwg-look"
    "swaync"
    "swayosd"

    # Utilities
    "jq"
    "brightnessctl"
    "pavucontrol"
    "NetworkManager"
    "cliphist"
    "tree"
    "cmatrix"
    "htop"
    "fastfetch"
    "nano"
    "curl"
    "wget"
    "git"
    "unzip"

    # Audio / wallpaper / recording
    "cava"
    "wf-recorder"
    "awww"

    # Power / GTK
    "power-profiles-daemon"
    "adw-gtk3-theme"

    # Fonts
    "fontconfig"
    "jetbrains-mono-fonts"
    "google-rubik-fonts"
)

# ----------------------------------------------------------
# Wallpaper repositories
# ----------------------------------------------------------

wallpaper_repos=(
    "https://github.com/genta-bahana-nagari/wp-collection.git"
)

# ----------------------------------------------------------
# Check command exists
# ----------------------------------------------------------

_checkCommandExists() {
    local cmd="$1"

    if command -v "$cmd" >/dev/null 2>&1; then
        return 0
    fi

    return 1
}

# ----------------------------------------------------------
# Check package installed
# ----------------------------------------------------------

_isInstalled() {
    local package="$1"

    rpm -q "$package" >/dev/null 2>&1
}

# ----------------------------------------------------------
# Check disk space
# ----------------------------------------------------------

_checkDiskSpace() {
    echo ":: Checking available disk space..."

    local available_kb
    available_kb="$(df --output=avail "$HOME" | tail -n 1 | tr -d ' ')"

    # Require at least 5 GB free.
    local minimum_kb=$((5 * 1024 * 1024))

    if (( available_kb < minimum_kb )); then
        echo -e "${RED}:: Not enough free disk space.${NONE}"
        echo
        df -h "$HOME"
        echo
        echo -e "${YELLOW}:: At least 5 GB free space is recommended before installation.${NONE}"
        exit 1
    fi

    echo ":: Available disk space:"
    df -h "$HOME"
    echo
}

# ----------------------------------------------------------
# Check Fedora
# ----------------------------------------------------------

_checkFedora() {
    if [[ ! -f /etc/fedora-release ]]; then
        echo -e "${RED}:: This installer is intended for Fedora Linux.${NONE}"
        exit 1
    fi

    local fedora_version
    fedora_version="$(rpm -E %fedora)"

    echo ":: Fedora version: ${fedora_version}"

    if [[ "$fedora_version" != "43" ]]; then
        echo -e "${YELLOW}:: Warning: this script was prepared for Fedora 43.${NONE}"
        echo -e "${YELLOW}:: Current Fedora version: ${fedora_version}${NONE}"
        echo
    fi
}

# ----------------------------------------------------------
# Enable RPM Fusion
# ----------------------------------------------------------

_enableRpmFusion() {
    echo ":: Enabling RPM Fusion repositories..."

    if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
        echo ":: Installing RPM Fusion Free..."

        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    else
        echo ":: RPM Fusion Free is already installed."
    fi

    if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
        echo ":: Installing RPM Fusion Nonfree..."

        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    else
        echo ":: RPM Fusion Nonfree is already installed."
    fi
}

# ----------------------------------------------------------
# Enable COPR repositories
# ----------------------------------------------------------

_enableCoprRepositories() {
    echo ":: Enabling COPR repositories..."

    # Main Hyprland COPR.
    if ! dnf repolist 2>/dev/null | grep -q \
        "copr:copr.fedorainfracloud.org:sdegler:hyprland"; then

        echo ":: Enabling sdegler/hyprland..."

        sudo dnf copr enable -y sdegler/hyprland
    else
        echo ":: sdegler/hyprland is already enabled."
    fi

    echo ":: COPR repositories configured."
}

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

_installPackages() {
    local missing_packages=()

    echo ":: Checking packages..."

    for pkg in "$@"; do
        if _isInstalled "$pkg"; then
            echo ":: ${pkg} is already installed."
        else
            missing_packages+=("$pkg")
        fi
    done

    if [[ "${#missing_packages[@]}" -eq 0 ]]; then
        echo ":: All packages are already installed."
        return 0
    fi

    echo
    echo ":: Packages to install:"
    printf '   %s\n' "${missing_packages[@]}"
    echo

    sudo dnf install -y "${missing_packages[@]}"
}

# ----------------------------------------------------------
# Verify important packages
# ----------------------------------------------------------

_verifyPackages() {
    echo ":: Verifying important packages..."

    local failed=0

    local verify_packages=(
        "hyprland"
        "xdg-desktop-portal-hyprland"
        "hyprpolkitagent"
        "hypridle"
        "hyprlock"
        "hyprshot"
        "waybar"
        "rofi-wayland"
        "nwg-look"
        "kitty"
        "sddm"
        "jetbrains-mono-fonts"
        "google-rubik-fonts"
    )

    for pkg in "${verify_packages[@]}"; do
        if _isInstalled "$pkg"; then
            echo -e "${GREEN}OK${NONE}: $pkg"
        else
            echo -e "${RED}MISSING${NONE}: $pkg"
            failed=1
        fi
    done

    if (( failed != 0 )); then
        echo
        echo -e "${RED}:: One or more important packages are missing.${NONE}"
        return 1
    fi

    echo ":: Package verification complete."
}

# ----------------------------------------------------------
# Install / refresh fonts
# ----------------------------------------------------------

_installFonts() {
    echo ":: Installing fonts..."

    # Fonts are installed from Fedora packages.
    # This avoids downloading the entire Google Fonts repository.

    sudo dnf install -y \
        fontconfig \
        jetbrains-mono-fonts \
        google-rubik-fonts

    echo ":: Rebuilding font cache..."

    fc-cache -f

    echo
    echo ":: Checking installed fonts..."

    if fc-match "JetBrains Mono" >/dev/null 2>&1; then
        echo -e "${GREEN}OK${NONE}: JetBrains Mono"
        fc-match "JetBrains Mono"
    else
        echo -e "${YELLOW}WARNING${NONE}: JetBrains Mono was not detected."
    fi

    if fc-match "Rubik" >/dev/null 2>&1; then
        echo -e "${GREEN}OK${NONE}: Rubik"
        fc-match "Rubik"
    else
        echo -e "${YELLOW}WARNING${NONE}: Rubik was not detected."
    fi
}

# ----------------------------------------------------------
# Deploy dotfiles
# ----------------------------------------------------------

_deployConfigs() {
    echo ":: Deploying configuration files..."

    if [[ ! -d "$PROJECT_DIR/.config" ]]; then
        echo -e "${RED}:: Config directory not found:${NONE}"
        echo "   $PROJECT_DIR/.config"
        return 1
    fi

    mkdir -p "$HOME/.config"

    cp -rf "$PROJECT_DIR/.config/"* "$HOME/.config/"

    # Hyprland scripts
    if [[ -d "$HOME/.config/hypr/scripts" ]]; then
        find "$HOME/.config/hypr/scripts" \
            -type f \
            -name "*.sh" \
            -exec chmod +x {} \; \
            2>/dev/null || true
    fi

    # Rofi scripts
    if [[ -d "$HOME/.config/rofi" ]]; then
        find "$HOME/.config/rofi" \
            -type f \
            -name "*.sh" \
            -exec chmod +x {} \; \
            2>/dev/null || true
    fi

    # Waybar scripts
    if [[ -d "$HOME/.config/waybar" ]]; then
        find "$HOME/.config/waybar" \
            -type f \
            -name "*.sh" \
            -exec chmod +x {} \; \
            2>/dev/null || true
    fi

    echo ":: Configuration files deployed."
}

# ----------------------------------------------------------
# Deploy initial wallpapers
# ----------------------------------------------------------

_deployWallpapers() {
    echo ":: Deploying initial wallpapers..."

    local wallpaper_dir="$HOME/Pictures/Wallpaper"

    mkdir -p "$wallpaper_dir"

    if [[ ! -d "$PROJECT_DIR/Wallpaper" ]]; then
        echo -e "${YELLOW}:: Local Wallpaper directory not found.${NONE}"
        echo ":: Skipping local wallpapers."
        return 0
    fi

    cp -rf "$PROJECT_DIR/Wallpaper/"* \
        "$wallpaper_dir/" 2>/dev/null || true

    echo ":: Wallpapers are located in:"
    echo "   $wallpaper_dir"
}

# ----------------------------------------------------------
# Download wallpaper collections
# ----------------------------------------------------------

_downloadWallpaperCollections() {
    echo ":: Downloading wallpaper collections..."

    local wallpaper_dir="$HOME/Pictures/Wallpaper"
    local temp_dir
    local repo
    local repo_name

    mkdir -p "$wallpaper_dir"

    if ! _checkCommandExists git; then
        echo -e "${RED}:: git is required but was not found.${NONE}"
        return 1
    fi

    temp_dir="$(mktemp -d)"

    # Always clean temporary directory.
    trap 'rm -rf "$temp_dir"' RETURN

    for repo in "${wallpaper_repos[@]}"; do

        repo_name="$(basename "$repo" .git)"

        echo
        echo ":: Downloading ${repo_name}..."

        git clone \
            --depth 1 \
            "$repo" \
            "$temp_dir/$repo_name"

        echo ":: Copying wallpapers from ${repo_name}..."

        find "$temp_dir/$repo_name" \
            -type f \
            \( \
                -iname "*.jpg" \
                -o -iname "*.jpeg" \
                -o -iname "*.png" \
                -o -iname "*.webp" \
            \) \
            -exec cp -n {} "$wallpaper_dir/" \;
    done

    rm -rf "$temp_dir"

    echo
    echo ":: Wallpaper collections downloaded."
    echo ":: Wallpapers are located in:"
    echo "   $wallpaper_dir"
}

# ----------------------------------------------------------
# Install Oh My Posh
# ----------------------------------------------------------

_installOhMyPosh() {
    echo ":: Installing Oh My Posh..."

    if command -v oh-my-posh >/dev/null 2>&1; then
        echo ":: Oh My Posh is already installed."
    else
        curl -fsSL \
            https://ohmyposh.dev/install.sh \
            | bash -s
    fi

    echo ":: Configuring shell prompt..."

    touch "$HOME/.bashrc"

    local path_line='export PATH="$PATH:$HOME/.local/bin"'
    local posh_line='eval "$(oh-my-posh init bash --config $HOME/.config/kitty/custom-theme.omp.json)"'

    grep -qxF "$path_line" "$HOME/.bashrc" || \
        echo "$path_line" >> "$HOME/.bashrc"

    # Only add Oh My Posh configuration if the theme exists.
    if [[ -f "$HOME/.config/kitty/custom-theme.omp.json" ]]; then
        grep -qxF "$posh_line" "$HOME/.bashrc" || \
            echo "$posh_line" >> "$HOME/.bashrc"
    else
        echo -e "${YELLOW}:: Oh My Posh theme was not found:${NONE}"
        echo "   $HOME/.config/kitty/custom-theme.omp.json"
        echo ":: Skipping Oh My Posh theme configuration."
    fi

    echo ":: Oh My Posh configured."
}

# ----------------------------------------------------------
# Enable services
# ----------------------------------------------------------

_enableServices() {
    echo ":: Enabling system services..."

    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable power-profiles-daemon.service

    echo ":: Services enabled."
}

# ----------------------------------------------------------
# Check important commands
# ----------------------------------------------------------

_verifyCommands() {
    echo ":: Checking important commands..."

    local commands=(
        "git"
        "curl"
        "wget"
        "unzip"
        "fc-cache"
        "fc-match"
    )

    local failed=0

    for cmd in "${commands[@]}"; do
        if _checkCommandExists "$cmd"; then
            echo -e "${GREEN}OK${NONE}: $cmd"
        else
            echo -e "${RED}MISSING${NONE}: $cmd"
            failed=1
        fi
    done

    if (( failed != 0 )); then
        echo -e "${RED}:: Some required commands are missing.${NONE}"
        return 1
    fi
}

# ----------------------------------------------------------
# Confirmation
# ----------------------------------------------------------

while true; do

    read -rp \
        "DO YOU WANT TO START THE FEDORA HYPRLAND INSTALLATION NOW? (Yy/Nn): " \
        yn

    case "$yn" in

        [Yy]*)
            echo
            echo ":: Installation started."
            echo
            break
            ;;

        [Nn]*)
            echo
            echo ":: Installation canceled."
            exit 0
            ;;

        *)
            echo ":: Please answer yes or no."
            ;;

    esac

done

# ----------------------------------------------------------
# Main installation
# ----------------------------------------------------------

_checkFedora

_checkDiskSpace

# ----------------------------------------------------------
# System update
# ----------------------------------------------------------

echo
echo ":: Updating Fedora packages..."
echo

sudo dnf upgrade -y

# ----------------------------------------------------------
# RPM Fusion
# ----------------------------------------------------------

echo
_enableRpmFusion

# ----------------------------------------------------------
# COPR
# ----------------------------------------------------------

echo
_enableCoprRepositories

# ----------------------------------------------------------
# Refresh package metadata
# ----------------------------------------------------------

echo
echo ":: Refreshing package metadata..."
echo

sudo dnf makecache

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

echo
echo ":: Installing Fedora / Hyprland packages..."
echo

_installPackages "${packages[@]}"

# ----------------------------------------------------------
# Verify packages
# ----------------------------------------------------------

echo
_verifyPackages

# ----------------------------------------------------------
# Install fonts
# ----------------------------------------------------------

echo
echo ":: Installing fonts..."
echo

_installFonts

# ----------------------------------------------------------
# Verify commands
# ----------------------------------------------------------

echo
_verifyCommands

# ----------------------------------------------------------
# Deploy configuration
# ----------------------------------------------------------

echo
echo ":: Deploying configuration..."
echo

_deployConfigs

# ----------------------------------------------------------
# Deploy local wallpapers
# ----------------------------------------------------------

echo
echo ":: Deploying wallpapers..."
echo

_deployWallpapers

# ----------------------------------------------------------
# Optional wallpaper collections
# ----------------------------------------------------------

while true; do

    read -rp \
        "DO YOU WANT TO DOWNLOAD ADDITIONAL WALLPAPER COLLECTIONS? (Yy/Nn): " \
        yn

    case "$yn" in

        [Yy]*)
            echo
            _downloadWallpaperCollections
            echo
            break
            ;;

        [Nn]*)
            echo
            echo ":: Skipping additional wallpaper collections."
            echo
            break
            ;;

        *)
            echo ":: Please answer yes or no."
            ;;

    esac

done

# ----------------------------------------------------------
# Install Oh My Posh
# ----------------------------------------------------------

echo
_installOhMyPosh

# ----------------------------------------------------------
# Enable services
# ----------------------------------------------------------

echo
_enableServices

# ----------------------------------------------------------
# Final font cache
# ----------------------------------------------------------

echo
echo ":: Final font cache refresh..."
fc-cache -f

# ----------------------------------------------------------
# Completed
# ----------------------------------------------------------

echo
echo -e "${GREEN}==============================================${NONE}"
echo -e "${GREEN}       HYPRLAND INSTALLATION COMPLETE        ${NONE}"
echo -e "${GREEN}==============================================${NONE}"
echo

echo ":: Hyprland environment has been installed."
echo
echo ":: Installed fonts:"
fc-match "JetBrains Mono" || true
fc-match "Rubik" || true
echo

echo ":: Enabled services:"
echo "   sddm"
echo "   NetworkManager"
echo "   power-profiles-daemon"
echo

read -rp "REBOOT NOW? (Yy/Nn): " reboot_now

case "$reboot_now" in
    [Yy]*)
        echo
        echo ":: Rebooting..."
        sleep 3
        sudo reboot
        ;;
    *)
        echo
        echo ":: Reboot skipped."
        echo ":: Reboot manually when you are ready."
        ;;
esac
