#!/usr/bin/env bash

set -e

if [[ -f /etc/arch-release ]]; then
    kitty bash -c 'sudo pacman -Syu; echo; read -rp "Press Enter to close..."'

elif [[ -f /etc/fedora-release ]]; then
    kitty bash -c 'sudo dnf upgrade --refresh; echo; read -rp "Press Enter to close..."'

else
    kitty bash -c 'echo "Unsupported distribution"; echo; cat /etc/os-release; echo; read -rp "Press Enter to close..."'
fi