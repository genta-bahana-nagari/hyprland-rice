#!/usr/bin/env bash

set -e

# ----------------------------------------------------------
# Script / project directory
# ----------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

# ----------------------------------------------------------
# Colors
# ----------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'

# ----------------------------------------------------------
# Packages
# ----------------------------------------------------------

packages=(
    "hyprland"
    "xdg-desktop-portal-hyprland"
    "qt5-qtwayland"
    "qt6-qtwayland"
    "hyprpolkitagent"
    "sddm"
    "kitty"
    "hypridle"
    "sdbus-cpp"
    "hyprlock"
    "hyprshot"
    "nano"
    "firefox"
    "rofi-wayland"
    "waybar"
    "nwg-look"
    "awww"
    "cava"
    "jq"
    "brightnessctl"
    "pavucontrol"
    "NetworkManager"
    "nautilus"
    "loupe"
    "swaync"
    "cliphist"
    "tree"
    "cmatrix"
    "kate"
    "power-profiles-daemon"
    "adw-gtk3-theme"
    "htop"
    "fastfetch"
    "unzip"
    "curl"
    "wget"
    "jetbrains-mono-fonts"
    "wf-recorder"
    "vlc"
)

# ----------------------------------------------------------
# Check if command exists
# ----------------------------------------------------------

_checkCommandExists() {
    local cmd="$1"

    if command -v "$cmd" >/dev/null 2>&1; then
        echo 0
    else
        echo 1
    fi
}

# ----------------------------------------------------------
# Check if package is installed
# ----------------------------------------------------------

_isInstalled() {
    local package="$1"

    if rpm -q "$package" &>/dev/null; then
        echo 0
    else
        echo 1
    fi
}

# ----------------------------------------------------------
# Enable RPM Fusion
# ----------------------------------------------------------

_enableRpmFusion() {
    echo ":: Enabling RPM Fusion repositories..."

    if ! rpm -q \
        rpmfusion-free-release \
        >/dev/null 2>&1; then

        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    else
        echo ":: RPM Fusion Free is already installed."
    fi

    if ! rpm -q \
        rpmfusion-nonfree-release \
        >/dev/null 2>&1; then

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

    if ! dnf repolist 2>/dev/null | grep -q "copr:copr.fedorainfracloud.org:solopasha:hyprland"; then
        echo ":: Enabling solopasha/hyprland COPR..."

        sudo dnf copr enable -y solopasha/hyprland
    else
        echo ":: solopasha/hyprland COPR is already enabled."
    fi

    echo ":: COPR repositories enabled."
}

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

_installPackages() {
    for pkg in "$@"; do
        if [[ $(_isInstalled "$pkg") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi

        echo ":: Installing ${pkg} ..."

        sudo dnf install -y "$pkg"
    done
}

# ----------------------------------------------------------
# Deploy dotfiles
# ----------------------------------------------------------

_deployConfigs() {
    echo ":: Deploying configuration files..."

    mkdir -p "$HOME/.config"

    cp -rf "$PROJECT_DIR/.config/"* "$HOME/.config/"

    # Hyprland scripts
    find "$HOME/.config/hypr/scripts" \
        -type f \
        -name "*.sh" \
        -exec chmod +x {} \; \
        2>/dev/null || true

    # Rofi scripts
    find "$HOME/.config/rofi" \
        -type f \
        -name "*.sh" \
        -exec chmod +x {} \; \
        2>/dev/null || true

    # Waybar scripts
    find "$HOME/.config/waybar" \
        -type f \
        -name "*.sh" \
        -exec chmod +x {} \; \
        2>/dev/null || true

    echo ":: Configuration files deployed."
}

# ----------------------------------------------------------
# Deploy wallpapers
# ----------------------------------------------------------

_deployWallpapers() {
    echo ":: Deploying wallpapers..."

    mkdir -p "$HOME/Pictures/Wallpaper"

    cp -rf "$PROJECT_DIR/Wallpaper/"* \
        "$HOME/Pictures/Wallpaper/"

    echo ":: Wallpapers deployed to ~/Pictures/Wallpaper/"
}

# ----------------------------------------------------------
# Install Oh My Posh
# ----------------------------------------------------------

_installOhMyPosh() {
    echo ":: Installing Oh My Posh..."

    curl -s https://ohmyposh.dev/install.sh | bash -s

    echo ":: Configuring shell prompt..."

    grep -qxF \
        'export PATH="$PATH:$HOME/.local/bin"' \
        "$HOME/.bashrc" || \
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"

    grep -qxF \
        'eval "$(oh-my-posh init bash --config $HOME/.config/kitty/custom-theme.omp.json)"' \
        "$HOME/.bashrc" || \
        echo 'eval "$(oh-my-posh init bash --config $HOME/.config/kitty/custom-theme.omp.json)"' >> "$HOME/.bashrc"

    echo ":: Oh My Posh configured."
}

# ----------------------------------------------------------
# Enable services
# ----------------------------------------------------------

_enableServices() {
    echo ":: Enabling system services..."

    sudo systemctl enable sddm
    sudo systemctl enable NetworkManager
    sudo systemctl enable power-profiles-daemon

    echo ":: Services enabled."
}

# ----------------------------------------------------------
# Confirmation
# ----------------------------------------------------------

while true; do
    read -rp \
        "DO YOU WANT TO START THE FEDORA INSTALLATION NOW? (Yy/Nn): " \
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
# Verify Fedora
# ----------------------------------------------------------

if [[ ! -f /etc/fedora-release ]]; then
    echo -e "${RED}:: This installer is intended for Fedora Linux.${NONE}"
    exit 1
fi

# ----------------------------------------------------------
# System update
# ----------------------------------------------------------

echo ":: Updating Fedora packages..."

sudo dnf upgrade -y

# ----------------------------------------------------------
# Enable RPM Fusion
# ----------------------------------------------------------

_enableRpmFusion

# ----------------------------------------------------------
# Enable COPR repositories
# ----------------------------------------------------------

_enableCoprRepositories

# ----------------------------------------------------------
# Refresh package metadata
# ----------------------------------------------------------

echo ":: Refreshing package metadata..."

sudo dnf makecache

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

echo
echo ":: Installing Fedora packages..."
echo

_installPackages "${packages[@]}"

# ----------------------------------------------------------
# Deploy configuration
# ----------------------------------------------------------

echo
_deployConfigs

# ----------------------------------------------------------
# Deploy wallpaper
# ----------------------------------------------------------

echo
_deployWallpapers

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
# Completed
# ----------------------------------------------------------

echo
echo -e "${GREEN}:: Setup complete!${NONE}"
echo ":: Your Hyprland environment has been installed successfully."
echo
echo ":: System will reboot in 10 seconds..."

sleep 10

sudo reboot