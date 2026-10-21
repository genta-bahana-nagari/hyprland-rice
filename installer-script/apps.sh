#!/usr/bin/env bash

# ==========================================================
# Shared application selection for both installers.
#
# Option format:
#   Label|package|command|source|lua_key
#
# source: official | aur | flatpak | microsoft
# lua_key: key in programs.lua, empty when the app has no keybind
#
# The first option in every category is the recommendation, so
# pressing Enter accepts it.
# ==========================================================

APPS_OFFICIAL=()
APPS_AUR=()
APPS_FLATPAK=()
APPS_PROGRAMS=()
APPS_NEEDS_VSCODE_REPO=0

# ----------------------------------------------------------
# Add one selection
# ----------------------------------------------------------

_apps_apply() {
    local entry="$1"
    local label pkg cmd src luakey p

    IFS='|' read -r label pkg cmd src luakey <<< "$entry"

    case "$src" in
        official|aur)
            # A package field may list several space-separated packages.
            for p in $pkg; do
                if [[ "$src" == "aur" ]]; then
                    APPS_AUR+=("$p")
                else
                    APPS_OFFICIAL+=("$p")
                fi
            done
            ;;
        flatpak)
            APPS_FLATPAK+=("$pkg")
            ;;
        microsoft)
            APPS_NEEDS_VSCODE_REPO=1
            APPS_OFFICIAL+=("$pkg")
            ;;
        *)
            echo ":: Unknown package source: $src" >&2
            exit 1
            ;;
    esac

    if [[ -n "$luakey" ]]; then
        APPS_PROGRAMS+=("    $luakey = \"$cmd\",")
    fi
}

# ----------------------------------------------------------
# Pick one option from a category
# ----------------------------------------------------------

_apps_pick() {
    local title="$1"
    shift
    local -a entries=("$@")
    local choice i label pkg cmd src luakey

    while true; do
        echo
        echo "$title"

        for i in "${!entries[@]}"; do
            IFS='|' read -r label pkg cmd src luakey <<< "${entries[$i]}"

            if (( i == 0 )); then
                echo "  $((i + 1))) ${label}  [recommended]"
            else
                echo "  $((i + 1))) ${label}"
            fi
        done

        read -rp "Choice [1]: " choice
        choice="${choice:-1}"

        if [[ "$choice" =~ ^[0-9]+$ ]] &&
            (( choice >= 1 && choice <= ${#entries[@]} )); then
            _apps_apply "${entries[$((choice - 1))]}"
            return 0
        fi

        echo ":: Invalid choice."
    done
}

# ----------------------------------------------------------
# Yes/no for extra applications (default: yes)
# ----------------------------------------------------------

_apps_confirm() {
    local title="$1"
    local entry="$2"
    local yn

    read -rp "Install ${title}? (Y/n): " yn

    case "${yn:-y}" in
        [Yy]*) _apps_apply "$entry" ;;
        *) ;;
    esac
}

# ----------------------------------------------------------
# Selection menus
# ----------------------------------------------------------

_apps_select() {
    local distro="$1"

    echo
    echo "=============================================="
    echo "        APPLICATION SELECTION"
    echo "=============================================="
    echo ":: Press Enter to accept the recommended choice."
    echo ":: Image viewer, video player and calculator"
    echo ":: are opened from Rofi and have no keybind."

    case "$distro" in
        arch)
            _apps_pick "Browser (Super + B)" \
                "Firefox|firefox|firefox|official|browser" \
                "Chromium|chromium|chromium|official|browser" \
                "Brave|brave-bin|brave|aur|browser" \
                "Google Chrome|google-chrome|google-chrome-stable|aur|browser"

            _apps_pick "File manager (Super + E)" \
                "Nautilus|nautilus|nautilus|official|fileManager" \
                "Dolphin|dolphin|dolphin|official|fileManager" \
                "Thunar|thunar|thunar|official|fileManager" \
                "Nemo|nemo|nemo|official|fileManager"

            _apps_pick "Terminal (Super + Return)" \
                "Kitty|kitty|kitty|official|terminal" \
                "Foot|foot|foot|official|terminal" \
                "Alacritty|alacritty|alacritty|official|terminal" \
                "WezTerm|wezterm|wezterm|official|terminal"

            _apps_pick "Code editor (Super + C)" \
                "Visual Studio Code|code|code|official|code" \
                "Kate|kate|kate|official|code" \
                "GNOME Text Editor|gnome-text-editor|gnome-text-editor|official|code" \
                "Gedit|gedit|gedit|official|code"

            _apps_pick "Image viewer" \
                "Loupe|loupe|loupe|official|" \
                "imv|imv|imv|official|" \
                "Gwenview|gwenview|gwenview|official|"

            _apps_pick "Video player" \
                "VLC|vlc vlc-plugin-ffmpeg|vlc|official|" \
                "mpv|mpv|mpv|official|" \
                "Haruna|haruna|haruna|official|"

            _apps_pick "Calculator" \
                "Qalculate-GTK|qalculate-gtk|qalculate-gtk|official|" \
                "GNOME Calculator|gnome-calculator|gnome-calculator|official|" \
                "KCalc|kcalc|kcalc|official|"

            echo
            echo ":: Developer tools and media apps"
            _apps_confirm "Postman (Super + Shift + P)" \
                "Postman|postman-bin|postman|aur|postman"
            ;;

        fedora)
            _apps_pick "Browser (Super + B)" \
                "Firefox|firefox|firefox|official|browser" \
                "Chromium|chromium|chromium|official|browser"

            _apps_pick "File manager (Super + E)" \
                "Nautilus|nautilus|nautilus|official|fileManager" \
                "Dolphin|dolphin|dolphin|official|fileManager" \
                "Thunar|thunar|thunar|official|fileManager" \
                "Nemo|nemo|nemo|official|fileManager"

            _apps_pick "Terminal (Super + Return)" \
                "Kitty|kitty|kitty|official|terminal" \
                "Foot|foot|foot|official|terminal" \
                "Alacritty|alacritty|alacritty|official|terminal"

            _apps_pick "Code editor (Super + C)" \
                "Visual Studio Code|code|code|microsoft|code" \
                "Kate|kate|kate|official|code" \
                "GNOME Text Editor|gnome-text-editor|gnome-text-editor|official|code" \
                "Gedit|gedit|gedit|official|code"

            _apps_pick "Image viewer" \
                "Loupe|loupe|loupe|official|" \
                "imv|imv|imv|official|" \
                "Gwenview|gwenview|gwenview|official|"

            _apps_pick "Video player" \
                "VLC|vlc|vlc|official|" \
                "mpv|mpv|mpv|official|" \
                "GNOME Videos|totem|totem|official|"

            _apps_pick "Calculator" \
                "Qalculate-GTK|qalculate-gtk|qalculate-gtk|official|" \
                "GNOME Calculator|gnome-calculator|gnome-calculator|official|" \
                "KCalc|kcalc|kcalc|official|"

            echo
            echo ":: Developer tools and media apps"
            _apps_confirm "Postman (Super + Shift + P)" \
                "Postman|com.getpostman.Postman|flatpak run com.getpostman.Postman|flatpak|postman"
            ;;

        *)
            echo ":: Unknown distribution for app selection: $distro" >&2
            exit 1
            ;;
    esac

    _apps_confirm "Discord (Flatpak, Super + Shift + D)" \
        "Discord|com.discordapp.Discord|flatpak run com.discordapp.Discord|flatpak|discord"

    _apps_confirm "Spotify (Flatpak, Super + Shift + M)" \
        "Spotify|com.spotify.Client|flatpak run com.spotify.Client|flatpak|spotify"

    echo
}

# ----------------------------------------------------------
# Optional third-party repository (Fedora VS Code)
# ----------------------------------------------------------

_apps_setup_repositories() {
    if (( APPS_NEEDS_VSCODE_REPO == 0 )); then
        return 0
    fi

    echo ":: Adding the Microsoft VS Code repository..."

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

    sudo dnf makecache
}

# ----------------------------------------------------------
# Flatpak applications
# ----------------------------------------------------------

_apps_install_flatpaks() {
    if [[ ${#APPS_FLATPAK[@]} -eq 0 ]]; then
        return 0
    fi

    if ! command -v flatpak >/dev/null 2>&1; then
        echo ":: flatpak was not found; skipping Flatpak applications."
        return 0
    fi

    echo ":: Adding the Flathub remote..."
    flatpak remote-add --if-not-exists --user flathub \
        https://flathub.org/repo/flathub.flatpakrepo

    local missing=()
    local app

    for app in "${APPS_FLATPAK[@]}"; do
        if flatpak info "$app" >/dev/null 2>&1; then
            echo ":: ${app} is already installed."
        else
            missing+=("$app")
        fi
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        return 0
    fi

    echo ":: Installing Flatpak applications:"
    printf '   %s\n' "${missing[@]}"

    flatpak install -y --user flathub "${missing[@]}"
}

# ----------------------------------------------------------
# Persist keybind choices (survives update.sh)
# ----------------------------------------------------------

_apps_write_programs() {
    local target_dir="$HOME/.config/hypr/modules"
    local target="$target_dir/programs.local.lua"

    if [[ ! -d "$target_dir" ]]; then
        echo ":: Hyprland module directory not found; skipping app overrides."
        return 0
    fi

    {
        echo "-- Generated by the installer. Re-run it to change the selection."
        echo "return {"
        printf '%s\n' "${APPS_PROGRAMS[@]}"
        echo "}"
    } > "$target"

    echo ":: Application choices saved to:"
    echo "   $target"
}
