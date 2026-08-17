#!/bin/bash

KEYBINDS="$HOME/.config/hypr/modules/keybinds.conf"
THEME="$HOME/.config/rofi/styles/simple.rasi"

awk '

function trim(s) {
    gsub(/^[ \t]+|[ \t]+$/, "", s)
    return s
}

function pretty_key(k) {
    k = trim(k)

    if (k == "Return") return "Enter"
    if (k == "SPACE") return "Space"

    if (k == "left")  return "←"
    if (k == "right") return "→"
    if (k == "up")    return "↑"
    if (k == "down")  return "↓"

    if (k == "mouse_down") return "Mouse Wheel Down"
    if (k == "mouse_up")   return "Mouse Wheel Up"
    if (k == "mouse:272")  return "Left Mouse Button"
    if (k == "mouse:273")  return "Right Mouse Button"

    if (k == "XF86AudioRaiseVolume") return "Volume Up"
    if (k == "XF86AudioLowerVolume") return "Volume Down"
    if (k == "XF86AudioMute")        return "Mute Audio"
    if (k == "XF86AudioMicMute")     return "Mute Microphone"

    if (k == "XF86MonBrightnessUp")   return "Brightness Up"
    if (k == "XF86MonBrightnessDown") return "Brightness Down"

    if (k == "XF86AudioNext")  return "Next Track"
    if (k == "XF86AudioPrev")  return "Previous Track"
    if (k == "XF86AudioPlay")  return "Play / Pause"
    if (k == "XF86AudioPause") return "Play / Pause"

    return k
}

function pretty_mod(m) {
    m = trim(m)

    gsub(/\$mainMod/, "Super", m)
    gsub(/SHIFT/, "Shift", m)
    gsub(/CTRL/, "Ctrl", m)
    gsub(/ALT/, "Alt", m)

    return m
}

function make_shortcut(mod, key) {
    mod = pretty_mod(mod)
    key = pretty_key(key)

    if (mod == "")
        return key

    return mod " + " key
}

function description(mod, key, action, target) {

    mod    = pretty_mod(mod)
    key    = trim(key)
    action = trim(action)
    target = trim(target)

    # ============================================================
    # Apps / Core
    # ============================================================

    if (section == "Apps / Core") {

        if (key == "Return")
            return "Open Terminal"

        if (key == "E")
            return "Open File Manager"

        if (key == "B")
            return "Open Web Browser"

        if (key == "C")
            return "Open Code Editor"

        if (key == "D")
            return "Open Application Launcher"

        if (key == "P")
            return "Open Postman"

        if (key == "N" && mod == "Super")
            return "Open Notification Center"

        if (key == "N" && mod == "Super + Shift")
            return "Open Wi-Fi Manager"

        if (key == "N" && mod == "Super + Ctrl")
            return "Disconnect Wi-Fi"

        if (key == "R" && mod == "Super + Shift")
            return "Start Screen Recording"

        if (key == "K")
            return "Show Keybind Dictionary"
    }

    # ============================================================
    # Window Management
    # ============================================================

    if (section == "Window Mgmt") {

        if (key == "Q")
            return "Close Active Window"

        if (key == "Delete")
            return "Open Power Menu"

        if (key == "W" && mod == "Super")
            return "Change Wallpaper"

        if (key == "W" && mod == "Super + Shift")
            return "Toggle Waybar"

        if (key == "W" && mod == "Super + Ctrl")
            return "Open Waybar Switcher"

        if (key == "M")
            return "Toggle Fullscreen"

        if (key == "SPACE")
            return "Toggle Floating Window"

        if (key == "P")
            return "Toggle Pseudo-Tiling"

        if (key == "R" && mod == "Super + Shift")
            return "Reload Hyprland"
    }

    # ============================================================
    # Focus Management
    # ============================================================

    if (section == "Focus Mgmt") {

        if (key == "left")
            return "Focus Window Left"

        if (key == "right")
            return "Focus Window Right"

        if (key == "up")
            return "Focus Window Above"

        if (key == "down")
            return "Focus Window Below"
    }

    # ============================================================
    # Resize Window
    # ============================================================

    if (section == "Resize Window") {

        if (key == "left")
            return "Resize Window Left"

        if (key == "right")
            return "Resize Window Right"

        if (key == "up")
            return "Resize Window Up"

        if (key == "down")
            return "Resize Window Down"
    }

    # ============================================================
    # Move & Swap Window
    # ============================================================

    if (section == "Move & Swap Window") {

        if (mod == "Super + Ctrl" && key == "left")
            return "Move Window Left"

        if (mod == "Super + Ctrl" && key == "right")
            return "Move Window Right"

        if (mod == "Super + Ctrl" && key == "up")
            return "Move Window Up"

        if (mod == "Super + Ctrl" && key == "down")
            return "Move Window Down"

        if (mod == "Super + Alt" && key == "left")
            return "Swap Window Left"

        if (mod == "Super + Alt" && key == "right")
            return "Swap Window Right"

        if (mod == "Super + Alt" && key == "up")
            return "Swap Window Up"

        if (mod == "Super + Alt" && key == "down")
            return "Swap Window Down"
    }

    # ============================================================
    # Workspaces
    # ============================================================

    if (section == "Workspaces") {

        if (action == "workspace")
            return "Switch to Workspace " target

        if (action == "movetoworkspace")
            return "Move Window to Workspace " target
    }

    # ============================================================
    # Mouse
    # ============================================================

    if (section == "Mouse") {

        if (key == "mouse_down")
            return "Next Workspace"

        if (key == "mouse_up")
            return "Previous Workspace"

        if (key == "mouse:272")
            return "Move Window"

        if (key == "mouse:273")
            return "Resize Window"
    }

    # ============================================================
    # Media and Screen Keys
    # ============================================================

    if (section == "Media and Screen Keys") {

        if (key == "XF86AudioRaiseVolume")
            return "Increase Volume"

        if (key == "XF86AudioLowerVolume")
            return "Decrease Volume"

        if (key == "XF86AudioMute")
            return "Toggle Audio Mute"

        if (key == "XF86AudioMicMute")
            return "Toggle Microphone Mute"

        if (key == "XF86MonBrightnessUp")
            return "Increase Brightness"

        if (key == "XF86MonBrightnessDown")
            return "Decrease Brightness"

        if (key == "V")
            return "Open Clipboard History"
    }

    # ============================================================
    # Media Controls
    # ============================================================

    if (section == "Media Ctrl") {

        if (key == "XF86AudioNext")
            return "Next Track"

        if (key == "XF86AudioPause")
            return "Play / Pause"

        if (key == "XF86AudioPlay")
            return "Play / Pause"

        if (key == "XF86AudioPrev")
            return "Previous Track"
    }

    # ============================================================
    # Screenshots
    # ============================================================

    if (section == "Screenshot") {

        if (key == "S" && mod == "Super")
            return "Capture Entire Screen"

        if (key == "S" && mod == "Super + Shift")
            return "Capture Selected Region"

        if (key == "S" && mod == "Super + Ctrl")
            return "Capture Active Window"
    }

    return ""
}

BEGIN {
    section = ""
}

# ================================================================
# Comments / Sections
# ================================================================

/^#/ {

    line = $0

    # Ignore decorative lines such as:
    # ###############
    if (line ~ /^#[# ]+$/)
        next

    # Remove leading #
    sub(/^#[ \t]*/, "", line)

    # Remove trailing #
    sub(/[ \t]*#$/, "", line)

    line = trim(line)

    # Ignore subsection labels
    if (line == "Switch" || line == "Move to workspace" || line == "Audio" || line == "Brightness")
        next

    section = line
    next
}

# ================================================================
# Bindings
# ================================================================

/^bind/ {

    line = $0

    # Remove inline comments
    sub(/[ \t]+#.*/, "", line)

    # Remove bind, bindd, bindl, bindel, bindm, binded, etc.
    sub(/^bind[a-z]*[ \t]*=[ \t]*/, "", line)

    # Split Hyprland binding
    n = split(line, p, ",")

    if (n < 3)
        next

    mod    = trim(p[1])
    key    = trim(p[2])
    action = trim(p[3])
    target = trim(p[4])

    desc = description(mod, key, action, target)

    # If we do not have a translation, do not show raw commands.
    if (desc == "")
        next

    key_display = make_shortcut(mod, key)

    printf "%-32s  %s\n", key_display, desc
}
' "$KEYBINDS" |
rofi \
    -dmenu \
    -i \
    -no-custom \
    -p "󰌌  Keybinds" \
    -theme "$THEME"