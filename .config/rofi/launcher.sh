#!/usr/bin/env bash

dir="$HOME/.config/rofi/styles"
theme='launcher'

# 1. Membaca ID distro dari sistem
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="linux"
fi

# 2. Menentukan ikon Nerd Font berdasarkan ID distro
case "$DISTRO" in
    arch)
        ICON="󰣇"
        ;;
    ubuntu)
        ICON=""
        ;;
    debian)
        ICON=""
        ;;
    fedora)
        ICON=""
        ;;
    manjaro)
        ICON=""
        ;;
    linuxmint)
        ICON="󰣭"
        ;;
    nixos)
        ICON=""
        ;;
    opensuse*|suse)
        ICON=""
        ;;
    *)
        ICON="" # Ikon Tux default jika distro tidak terdaftar
        ;;
esac

# 3. Menjalankan Rofi dengan tema sekaligus ikon dinamis
rofi \
    -show drun \
    -display-drun "$ICON" \
    -theme "${dir}/${theme}.rasi"