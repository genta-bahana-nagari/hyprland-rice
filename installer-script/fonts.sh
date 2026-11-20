#!/usr/bin/env bash
# fonts.sh — Shared modular font installer.
# Sourced by arch-install.sh and fedora-install.sh.
# Installs the curated font stack and refreshes the font cache.
set -Eeuo pipefail

install_fonts() {
    if command -v pacman >/dev/null 2>&1; then
        # ---- Arch Linux ----
        sudo pacman -S --needed --noconfirm \
            ttf-jetbrains-mono-nerd \
            ttf-inter \
            noto-fonts-emoji \
            noto-fonts-cjk \
            || true
        if command -v yay >/dev/null 2>&1; then
            yay -S --needed --noconfirm \
                ttf-fira-code-nerd \
                ttf-rubik \
                || true
        fi
    elif command -v dnf >/dev/null 2>&1; then
        # ---- Fedora Linux ----
        sudo dnf install -y \
            jetbrains-mono-fonts \
            fira-code-fonts \
            google-rubik-fonts \
            rsms-inter-fonts \
            google-noto-emoji-color-fonts \
            google-noto-sans-cjk-fonts
    fi

    fc-cache -fv >/dev/null 2>&1 || true
}

install_fonts
