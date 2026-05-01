#!/bin/bash

set -e

echo "Update system & install base dependencies..."
sudo pacman -Syu --needed git base-devel

if ! command -v yay &> /dev/null; then
    echo "Installing AUR helper (yay)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "AUR (yay) already installed"
fi

echo "Installing packages..."

sudo pacman -S \
    hyprland \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    hyprpolkitagent \
    sddm \
    kitty \
    hyprlock \
    hyprshot \
    nano \
    firefox \
    rofi-wayland \
    waybar \
    nwg-look \
    awww \
    jq \
    brightnessctl \
    pavucontrol \
    networkmanager \
    nautilus \
    loupe \
    swaync \
    cliphist \
    tree \
    cmatrix \
    power-profiles-daemon \
    adwaita-gtk-theme \
    adw-gtk-theme \
    htop \
    fastfetch \
    unzip \
    curl \
    wget \
    ttf-jetbrains-mono-nerd 

yay -S --needed --noconfirm \
    ttf-rubik \
    ttf-rubik-vf

# Move this BEFORE oh-my-posh setup
echo "Deploying configuration files..."
mkdir -p "$HOME/.config"
cp -rf .config/* "$HOME/.config/"

find "$HOME/.config/hypr/scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

echo "Installing Oh My Posh prompt engine..."
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "Setting up prompt themes..."
echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"
echo 'eval "$(oh-my-posh init bash --config $HOME/.config/kitty/custom-theme.omp.json)"' >> "$HOME/.bashrc"

echo "Enabling services and scripts..."
sudo systemctl enable sddm NetworkManager power-profiles-daemon

echo "Setup complete! Rebooting in 10 seconds..."
sleep 10
reboot