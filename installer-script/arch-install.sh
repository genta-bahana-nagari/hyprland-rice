#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================================
# Arch Linux Hyprland Installer
# Target: Arch Linux
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
    # ------------------------------------------------------
    # Hyprland
    # ------------------------------------------------------
    "hyprland"
    "xdg-desktop-portal-hyprland"
    "hyprpolkitagent"
    "hypridle"
    "hyprlock"
    "hyprshot"

    # ------------------------------------------------------
    # Wayland / Qt
    # ------------------------------------------------------
    "qt5-wayland"
    "qt6-wayland"
    "sdbus-cpp"

    # ------------------------------------------------------
    # Login / terminal
    # ------------------------------------------------------
    "sddm"
    "kitty"

    # ------------------------------------------------------
    # Applications
    # ------------------------------------------------------
    "firefox"
    "nautilus"
    "loupe"
    "kate"
    "vlc"
    "vlc-plugin-ffmpeg"

    # ------------------------------------------------------
    # Desktop / launcher / bar
    # ------------------------------------------------------
    "rofi-wayland"
    "waybar"
    "nwg-look"
    "swaync"
    "swayosd"

    # ------------------------------------------------------
    # Utilities
    # ------------------------------------------------------
    "jq"
    "brightnessctl"
    "pavucontrol"
    "networkmanager"
    "cliphist"
    "tree"
    "cmatrix"
    "htop"
    "fastfetch"
    "nano"
    "unzip"
    "curl"
    "wget"
    "git"
    "swayosd"

    # ------------------------------------------------------
    # Audio / wallpaper / recording
    # ------------------------------------------------------
    "awww"
    "wf-recorder"

    # ------------------------------------------------------
    # Power / GTK
    # ------------------------------------------------------
    "power-profiles-daemon"
    "adw-gtk-theme"

    # ------------------------------------------------------
    # Fonts
    # ------------------------------------------------------
    "fontconfig"
    "ttf-jetbrains-mono-nerd"
)

# ----------------------------------------------------------
# AUR packages
# ----------------------------------------------------------

aur_packages=(
    "ttf-rubik"
    "ttf-rubik-vf"
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

    command -v "$cmd" >/dev/null 2>&1
}

# ----------------------------------------------------------
# Check package installed
# ----------------------------------------------------------

_isInstalled() {
    local package="$1"

    pacman -Q "$package" >/dev/null 2>&1
}

# ----------------------------------------------------------
# Check root
# ----------------------------------------------------------

_checkRoot() {
    if [[ "${EUID}" -eq 0 ]]; then
        echo -e "${RED}:: Do not run this installer as root.${NONE}"
        echo ":: Run it as your normal user."
        exit 1
    fi
}

# ----------------------------------------------------------
# Check sudo
# ----------------------------------------------------------

_checkSudo() {
    echo ":: Checking sudo access..."

    if ! _checkCommandExists sudo; then
        echo -e "${RED}:: sudo is not installed.${NONE}"
        exit 1
    fi

    if ! sudo -v; then
        echo -e "${RED}:: Unable to obtain sudo privileges.${NONE}"
        exit 1
    fi

    echo ":: sudo access verified."
}

# ----------------------------------------------------------
# Check Arch Linux
# ----------------------------------------------------------

_checkArch() {
    echo ":: Checking operating system..."

    if [[ ! -f /etc/arch-release ]]; then
        echo -e "${RED}:: This installer is intended for Arch Linux.${NONE}"
        exit 1
    fi

    echo ":: Arch Linux detected."

    if [[ -f /etc/os-release ]]; then
        local os_name
        os_name="$(. /etc/os-release && echo "${PRETTY_NAME:-Arch Linux}")"

        echo ":: Operating system: ${os_name}"
    fi
}

# ----------------------------------------------------------
# Check disk space
# ----------------------------------------------------------

_checkDiskSpace() {
    echo ":: Checking available disk space..."

    local available_kb
    available_kb="$(
        df --output=avail "$HOME" |
            tail -n 1 |
            tr -d ' '
    )"

    # Require at least 5 GB free.
    local minimum_kb=$((5 * 1024 * 1024))

    if (( available_kb < minimum_kb )); then
        echo -e "${RED}:: Not enough free disk space.${NONE}"
        echo
        df -h "$HOME"
        echo
        echo -e "${YELLOW}:: At least 5 GB free space is recommended.${NONE}"
        exit 1
    fi

    echo ":: Available disk space:"
    df -h "$HOME"
    echo
}

# ----------------------------------------------------------
# Refresh package database
# ----------------------------------------------------------

_refreshPacmanDatabase() {
    echo ":: Refreshing Arch package databases..."

    sudo pacman -Sy --noconfirm

    echo ":: Package databases refreshed."
}

# ----------------------------------------------------------
# System update
# ----------------------------------------------------------

_updateSystem() {
    echo ":: Updating Arch Linux packages..."

    sudo pacman -Syu --noconfirm

    echo ":: System update complete."
}

# ----------------------------------------------------------
# Install yay
# ----------------------------------------------------------

_installYay() {
    echo ":: Installing yay AUR helper..."

    if _checkCommandExists yay; then
        echo ":: yay is already installed."
        return 0
    fi

    echo ":: Installing build dependencies..."

    sudo pacman -S --needed --noconfirm \
        base-devel \
        git

    local yay_dir
    yay_dir="$(mktemp -d)"

    echo ":: Cloning yay..."

    git clone \
        https://aur.archlinux.org/yay.git \
        "$yay_dir/yay"

    echo ":: Building yay..."

    (
        cd "$yay_dir/yay"
        makepkg -si --noconfirm
    )

    rm -rf "$yay_dir"

    if ! _checkCommandExists yay; then
        echo -e "${RED}:: yay installation failed.${NONE}"
        exit 1
    fi

    echo ":: yay installed successfully."
}

# ----------------------------------------------------------
# Install official packages
# ----------------------------------------------------------

_installPackages() {
    local missing_packages=()

    echo ":: Checking official repository packages..."

    for pkg in "$@"; do
        if _isInstalled "$pkg"; then
            echo ":: ${pkg} is already installed."
        else
            missing_packages+=("$pkg")
        fi
    done

    if [[ "${#missing_packages[@]}" -eq 0 ]]; then
        echo ":: All official packages are already installed."
        return 0
    fi

    echo
    echo ":: Packages to install:"
    printf '   %s\n' "${missing_packages[@]}"
    echo

    sudo pacman -S --needed --noconfirm \
        "${missing_packages[@]}"

    echo ":: Official packages installed."
}

# ----------------------------------------------------------
# Install AUR packages
# ----------------------------------------------------------

_installAurPackages() {
    local missing_packages=()

    echo ":: Checking AUR packages..."

    for pkg in "$@"; do
        if _isInstalled "$pkg"; then
            echo ":: ${pkg} is already installed."
        else
            missing_packages+=("$pkg")
        fi
    done

    if [[ "${#missing_packages[@]}" -eq 0 ]]; then
        echo ":: All AUR packages are already installed."
        return 0
    fi

    echo
    echo ":: AUR packages to install:"
    printf '   %s\n' "${missing_packages[@]}"
    echo

    yay -S --needed --noconfirm \
        "${missing_packages[@]}"

    echo ":: AUR packages installed."
}

# ----------------------------------------------------------
# Verify important packages
# ----------------------------------------------------------

_verifyPackages() {
    echo ":: Verifying important packages..."

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
        "networkmanager"
        "power-profiles-daemon"
        "ttf-jetbrains-mono-nerd"
    )

    local failed=0

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

    echo
    echo ":: Package verification complete."
}

# ----------------------------------------------------------
# Verify important commands
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
        "yay"
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
        echo
        echo -e "${RED}:: Some required commands are missing.${NONE}"
        return 1
    fi

    echo
    echo ":: Command verification complete."
}

# ----------------------------------------------------------
# Refresh font cache
# ----------------------------------------------------------

_refreshFonts() {
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

    cp -rf \
        "$PROJECT_DIR/.config/"* \
        "$HOME/.config/"

    # ------------------------------------------------------
    # Hyprland scripts
    # ------------------------------------------------------

    if [[ -d "$HOME/.config/hypr/scripts" ]]; then
        find "$HOME/.config/hypr/scripts" \
            -type f \
            -name "*.sh" \
            -exec chmod +x {} \; \
            2>/dev/null || true
    fi

    # ------------------------------------------------------
    # Rofi scripts
    # ------------------------------------------------------

    if [[ -d "$HOME/.config/rofi" ]]; then
        find "$HOME/.config/rofi" \
            -type f \
            -name "*.sh" \
            -exec chmod +x {} \; \
            2>/dev/null || true
    fi

    # ------------------------------------------------------
    # Waybar scripts
    # ------------------------------------------------------

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
# Deploy user systemd services
# ----------------------------------------------------------

_deployUserServices() {
    echo ":: Deploying user systemd services..."

    local service_source="$PROJECT_DIR/.config/hypr/service"
    local service_target="$HOME/.config/systemd/user"

    if [[ ! -d "$service_source" ]]; then
        echo -e "${YELLOW}:: User service directory not found.${NONE}"
        echo "   $service_source"
        echo ":: Skipping user services."
        return 0
    fi

    mkdir -p "$service_target"

    find "$service_source" \
        -type f \
        -name "*.service" \
        -exec cp -f {} "$service_target/" \;

    echo ":: User services deployed to:"
    echo "   $service_target"

    # Tell systemd user manager to re-read unit files.
    systemctl --user daemon-reload

    echo ":: User systemd daemon reloaded."
}

# ----------------------------------------------------------
# Deploy local wallpapers
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

    cp -rf \
        "$PROJECT_DIR/Wallpaper/"* \
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

    if _checkCommandExists oh-my-posh; then
        echo ":: Oh My Posh is already installed."
    else
        curl -fsSL \
            https://ohmyposh.dev/install.sh \
            | bash -s
    fi

    echo ":: Configuring shell prompt..."

    touch "$HOME/.bashrc"

    local path_line
    local posh_line

    path_line='export PATH="$PATH:$HOME/.local/bin"'

    posh_line='eval "$(oh-my-posh init bash --config $HOME/.config/kitty/custom-theme.omp.json)"'

    grep -qxF "$path_line" "$HOME/.bashrc" || \
        echo "$path_line" >> "$HOME/.bashrc"

    # Only configure Oh My Posh when the theme exists.
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
# Enable system services
# ----------------------------------------------------------

_enableServices() {
    echo ":: Enabling system services..."

    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable power-profiles-daemon.service

    echo
    echo ":: Services enabled:"
    echo "   sddm"
    echo "   NetworkManager"
    echo "   power-profiles-daemon"
}

# ----------------------------------------------------------
# Verify services
# ----------------------------------------------------------

_verifyServices() {
    echo ":: Verifying system services..."

    local services=(
        "sddm.service"
        "NetworkManager.service"
        "power-profiles-daemon.service"
    )

    local failed=0

    for service in "${services[@]}"; do

        if systemctl is-enabled "$service" >/dev/null 2>&1; then
            echo -e "${GREEN}ENABLED${NONE}: $service"
        else
            echo -e "${RED}NOT ENABLED${NONE}: $service"
            failed=1
        fi

    done

    if (( failed != 0 )); then
        echo
        echo -e "${YELLOW}:: Some services are not enabled.${NONE}"
        return 1
    fi

    echo ":: Service verification complete."
}

# ----------------------------------------------------------
# Confirmation
# ----------------------------------------------------------

while true; do

    read -rp \
        "DO YOU WANT TO START THE ARCH HYPRLAND INSTALLATION NOW? (Yy/Nn): " \
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

# ==========================================================
# Main installation
# ==========================================================

# ----------------------------------------------------------
# Pre-flight checks
# ----------------------------------------------------------

_checkRoot

_checkArch

_checkSudo

_checkDiskSpace

# ----------------------------------------------------------
# System update
# ----------------------------------------------------------

echo
echo ":: Updating Arch Linux..."
echo

_updateSystem

# ----------------------------------------------------------
# Install yay
# ----------------------------------------------------------

echo
_installYay

# ----------------------------------------------------------
# Install official packages
# ----------------------------------------------------------

echo
echo ":: Installing official repository packages..."
echo

_installPackages "${packages[@]}"

# ----------------------------------------------------------
# Install AUR packages
# ----------------------------------------------------------

echo
echo ":: Installing AUR packages..."
echo

_installAurPackages "${aur_packages[@]}"

# ----------------------------------------------------------
# Verify packages
# ----------------------------------------------------------

echo
_verifyPackages

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

_deployUserServices

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
# Refresh font cache
# ----------------------------------------------------------

echo
_refreshFonts

# ----------------------------------------------------------
# Enable services
# ----------------------------------------------------------

echo
_enableServices

# ----------------------------------------------------------
# Verify services
# ----------------------------------------------------------

echo
_verifyServices || true

# ----------------------------------------------------------
# Final verification
# ----------------------------------------------------------

echo
echo ":: Running final verification..."
echo

_verifyCommands

# ----------------------------------------------------------
# Completed
# ----------------------------------------------------------

echo
echo -e "${GREEN}==============================================${NONE}"
echo -e "${GREEN}       HYPRLAND INSTALLATION COMPLETE        ${NONE}"
echo -e "${GREEN}==============================================${NONE}"
echo

echo ":: Arch Linux Hyprland environment has been installed."
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

echo ":: Configuration:"
echo "   $HOME/.config/"
echo

echo ":: Wallpapers:"
echo "   $HOME/Pictures/Wallpaper/"
echo

echo ":: Project directory:"
echo "   $PROJECT_DIR"
echo

# ----------------------------------------------------------
# Reboot confirmation
# ----------------------------------------------------------

while true; do

    read -rp "REBOOT NOW? (Yy/Nn): " reboot_now

    case "$reboot_now" in

        [Yy]*)
            echo
            echo ":: Rebooting in 3 seconds..."
            sleep 3
            sudo reboot
            ;;

        [Nn]*)
            echo
            echo ":: Reboot skipped."
            echo ":: Reboot manually when you are ready."
            break
            ;;

        *)
            echo ":: Please answer yes or no."
            ;;

    esac

done
