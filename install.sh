#!/usr/bin/env bash

set -e

# ----------------------------------------------------------
# Colors
# ----------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NONE='\033[0m'

# ----------------------------------------------------------
# Script directory
# ----------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------
# Header
# ----------------------------------------------------------

clear

echo -e "${GREEN}"

cat <<'EOF'
__        _______ _     ____ ___  __  __ _____
\ \      / / ____| |   / ___/ _ \|  \/  | ____|
 \ \ /\ / /|  _| | |  | |  | | | | |\/| |  _|
  \ V  V / | |___| |__| |__| |_| | |  | | |___
   \_/\_/  |_____|_____\____\___/|_|  |_|_____|

Hyprland Setup Installer for Linux

EOF

echo -e "${NONE}"

# ----------------------------------------------------------
# Installation selection
# ----------------------------------------------------------

while true; do
    echo "Please select your distribution:"
    echo
    echo "  1) Arch Linux"
    echo "  2) Fedora Linux"
    echo "  3) Cancel"
    echo

    read -rp "Enter your choice [1-3]: " choice

    case "$choice" in
        1)
            echo
            echo ":: Arch Linux installation selected."
            echo
            exec bash "$SCRIPT_DIR/installer-script/arch-install.sh"
            ;;

        2)
            echo
            echo ":: Fedora Linux installation selected."
            echo
            exec bash "$SCRIPT_DIR/installer-script/fedora-install.sh"
            ;;

        3)
            echo
            echo ":: Installation canceled."
            exit 0
            ;;

        *)
            echo
            echo -e "${RED}:: Invalid selection.${NONE}"
            echo
            ;;
    esac
done