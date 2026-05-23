#!/usr/bin/env bash

set -e

# ----------------------------------------------------------
# Packages
# ----------------------------------------------------------

packages=(
    "hyprland"
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
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
    "jq"
    "brightnessctl"
    "pavucontrol"
    "networkmanager"
    "nautilus"
    "loupe"
    "swaync"
    "cliphist"
    "tree"
    "cmatrix"
    "kate"
    "power-profiles-daemon"
    "adw-gtk-theme"
    "htop"
    "fastfetch"
    "unzip"
    "curl"
    "wget"
    "ttf-jetbrains-mono-nerd"
)

aur_packages=(
    "ttf-rubik"
    "ttf-rubik-vf"
)

# ----------------------------------------------------------
# Colors
# ----------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'

# ----------------------------------------------------------
# Check if command exists
# ----------------------------------------------------------

_checkCommandExists() {
    cmd="$1"

    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi

    echo 0
    return
}

# ----------------------------------------------------------
# Check if package is installed
# ----------------------------------------------------------

_isInstalled() {
    package="$1"

    check="$(pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"

    if [ -n "${check}" ]; then
        echo 0
        return
    fi

    echo 1
    return
}

# ----------------------------------------------------------
# Install yay
# ----------------------------------------------------------

_installYay() {
    echo ":: Installing yay AUR helper..."

    sudo pacman -S --needed --noconfirm base-devel git

    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay

    makepkg -si --noconfirm

    cd "$temp_path"
    rm -rf /tmp/yay

    echo ":: yay installed successfully."
}

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi

        echo ":: Installing ${pkg} ..."
        sudo pacman -S --needed --noconfirm "${pkg}"
    done
}

# ----------------------------------------------------------
# Install AUR packages
# ----------------------------------------------------------

_installAurPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi

        echo ":: Installing AUR package ${pkg} ..."
        yay -S --needed --noconfirm "${pkg}"
    done
}

# ----------------------------------------------------------
# Deploy dotfiles
# ----------------------------------------------------------

_deployConfigs() {
    echo ":: Deploying configuration files..."

    mkdir -p "$HOME/.config"

    cp -rf .config/* "$HOME/.config/"

    find "$HOME/.config/hypr/scripts" \
        -type f \
        -name "*.sh" \
        -exec chmod +x {} \; 2>/dev/null || true

    echo ":: Configuration files deployed."
}

# ----------------------------------------------------------
# Install Oh My Posh
# ----------------------------------------------------------

_installOhMyPosh() {
    echo ":: Installing Oh My Posh..."

    curl -s https://ohmyposh.dev/install.sh | bash -s

    echo ":: Configuring shell prompt..."

    grep -qxF 'export PATH="$PATH:$HOME/.local/bin"' "$HOME/.bashrc" || \
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"

    grep -qxF 'eval "$(oh-my-posh init bash --config $HOME/.config/kitty/custom-theme.omp.json)"' "$HOME/.bashrc" || \
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
# Header
# ----------------------------------------------------------

clear

echo -e "${GREEN}"

cat <<"EOF"
__        _______ _     ____ ___  __  __ _____
\ \      / / ____| |   / ___/ _ \|  \/  | ____|
 \ \ /\ / /|  _| | |  | |  | | | | |\/| |  _|
  \ V  V / | |___| |__| |__| |_| | |  | | |___
   \_/\_/  |_____|_____\____\___/|_|  |_|_____|

Hyprland Setup Installer for Arch Linux

EOF

echo -e "${NONE}"

# ----------------------------------------------------------
# Confirmation
# ----------------------------------------------------------

while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn

    case $yn in
        [Yy]* )
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]* )
            echo ":: Installation canceled."
            exit
            ;;
        * )
            echo ":: Please answer yes or no."
            ;;
    esac
done

# ----------------------------------------------------------
# System update
# ----------------------------------------------------------

echo ":: Updating system packages..."

sudo pacman -Syu --noconfirm

# ----------------------------------------------------------
# Install yay if needed
# ----------------------------------------------------------

if [[ $(_checkCommandExists "yay") == 0 ]]; then
    echo ":: yay is already installed."
else
    echo ":: yay is not installed."
    _installYay
fi

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

echo ":: Installing official repository packages..."

_installPackages "${packages[@]}"

echo
echo ":: Installing AUR packages..."

_installAurPackages "${aur_packages[@]}"

# ----------------------------------------------------------
# Dotfiles
# ----------------------------------------------------------

_deployConfigs

# ----------------------------------------------------------
# Oh My Posh
# ----------------------------------------------------------

_installOhMyPosh

# ----------------------------------------------------------
# Services
# ----------------------------------------------------------

_enableServices

# ----------------------------------------------------------
# Completed
# ----------------------------------------------------------

echo
echo -e "${GREEN}:: Setup complete!${NONE}"
echo ":: Your Hyprland environment has been installed successfully."
echo ":: System will reboot in 10 seconds..."

sleep 10

reboot
