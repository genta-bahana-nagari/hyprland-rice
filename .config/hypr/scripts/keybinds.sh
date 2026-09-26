#!/bin/bash

KEYBINDS="$HOME/.config/hypr/modules/keybinds.lua"
THEME="$HOME/.config/rofi/styles/keybind-dictionary.rasi"

python3 - "$KEYBINDS" <<'PY' |
import re
import sys

path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    text = f.read()

# Current modifier variable
main_mod = "Super"

# Current section, based on your Lua comments
section = ""

# Human-readable descriptions
descriptions = {
    "SUPER + Return": "Open Terminal",
    "SUPER + E": "Open File Manager",
    "SUPER + B": "Open Web Browser",
    "SUPER + C": "Open Code Editor",
    "SUPER + D": "Open Application Launcher",
    "SUPER + SHIFT + D": "Open Discord",
    "SUPER + P": "Open Postman",
    "SUPER + SHIFT + M": "Open Spotify",
    "SUPER + N": "Open Notification Center",
    "SUPER + SHIFT + N": "Open Wi-Fi Manager",
    "SUPER + CTRL + N": "Disconnect Wi-Fi",
    "SUPER + R": "Reload Hyprland",
    "SUPER + SHIFT + R": "Start Screen Recording",
    "SUPER + K": "Show Keybind Dictionary",

    "SUPER + Q": "Close Active Window",
    "SUPER + SHIFT + Delete": "Open Power Menu",
    "SUPER + W": "Change Wallpaper",
    "SUPER + SHIFT + W": "Toggle Waybar",
    "SUPER + CTRL + W": "Open Waybar Switcher",
    "SUPER + M": "Toggle Fullscreen",
    "SUPER + SPACE": "Toggle Floating Window",
    "SUPER + SHIFT + P": "Toggle Pseudo-Tiling",

    "SUPER + left": "Focus Window Left",
    "SUPER + right": "Focus Window Right",
    "SUPER + up": "Focus Window Above",
    "SUPER + down": "Focus Window Below",

    "SUPER + SHIFT + left": "Resize Window Left",
    "SUPER + SHIFT + right": "Resize Window Right",
    "SUPER + SHIFT + up": "Resize Window Up",
    "SUPER + SHIFT + down": "Resize Window Down",

    "SUPER + CTRL + left": "Move Window Left",
    "SUPER + CTRL + right": "Move Window Right",
    "SUPER + CTRL + up": "Move Window Up",
    "SUPER + CTRL + down": "Move Window Down",

    "SUPER + ALT + left": "Swap Window Left",
    "SUPER + ALT + right": "Swap Window Right",
    "SUPER + ALT + up": "Swap Window Up",
    "SUPER + ALT + down": "Swap Window Down",

    "SUPER + mouse_down": "Next Workspace",
    "SUPER + mouse_up": "Previous Workspace",
    "SUPER + mouse:272": "Move Window",
    "SUPER + mouse:273": "Resize Window",

    "SUPER + V": "Open Clipboard History",

    "XF86AudioRaiseVolume": "Increase Volume",
    "XF86AudioLowerVolume": "Decrease Volume",
    "XF86AudioMute": "Toggle Audio Mute",
    "XF86AudioMicMute": "Toggle Microphone Mute",

    "XF86MonBrightnessUp": "Increase Brightness",
    "XF86MonBrightnessDown": "Decrease Brightness",

    "XF86AudioNext": "Next Track",
    "XF86AudioPrev": "Previous Track",
    "XF86AudioPlay": "Play / Pause",
    "XF86AudioPause": "Play / Pause",

    "SUPER + S": "Capture Entire Screen",
    "SUPER + SHIFT + S": "Capture Selected Region",
    "SUPER + CTRL + S": "Capture Active Window",
}

def pretty_key(key):
    return {
        "Return": "Enter",
        "SPACE": "Space",
        "left": "←",
        "right": "→",
        "up": "↑",
        "down": "↓",
        "mouse_down": "Mouse Wheel Down",
        "mouse_up": "Mouse Wheel Up",
        "mouse:272": "Left Mouse Button",
        "mouse:273": "Right Mouse Button",

        "XF86AudioRaiseVolume": "Volume Up",
        "XF86AudioLowerVolume": "Volume Down",
        "XF86AudioMute": "Mute Audio",
        "XF86AudioMicMute": "Mute Microphone",

        "XF86MonBrightnessUp": "Brightness Up",
        "XF86MonBrightnessDown": "Brightness Down",

        "XF86AudioNext": "Next Track",
        "XF86AudioPrev": "Previous Track",
        "XF86AudioPlay": "Play / Pause",
        "XF86AudioPause": "Play / Pause",
    }.get(key, key)

def normalize(expr):
    expr = expr.strip()

    # mainMod .. " + K"
    expr = re.sub(
        r'mainMod\s*\.\.\s*" \+ ([^"]+)"',
        lambda m: "SUPER + " + m.group(1),
        expr
    )

    # Direct "XF86AudioPlay"
    expr = expr.strip('"')

    return expr

# Find first argument of every hl.bind(...)
#
# This handles:
#
# hl.bind(
#     mainMod .. " + K",
#     ...
# )
#
# and:
#
# hl.bind(
#     "XF86AudioPlay",
#     ...
# )
pattern = re.compile(
    r'hl\.bind\s*\(\s*'
    r'((?:mainMod\s*\.\.\s*)?"[^"]+"|mainMod\s*\.\.\s*"[^"]+")',
    re.MULTILINE
)

seen = set()

for match in pattern.finditer(text):
    expr = match.group(1)
    shortcut = normalize(expr)

    # Normalize modifier spelling
    shortcut = shortcut.replace("SHIFT", "Shift")
    shortcut = shortcut.replace("CTRL", "Ctrl")
    shortcut = shortcut.replace("ALT", "Alt")
    shortcut = shortcut.replace("SUPER", "Super")

    # Pretty-print key
    parts = shortcut.split(" + ")
    if len(parts) > 1:
        parts[-1] = pretty_key(parts[-1])
        display = " + ".join(parts)
    else:
        display = pretty_key(parts[0])

    # Original normalized key for description lookup
    lookup = shortcut

    # Convert pretty modifier names back
    lookup = lookup.replace("Shift", "SHIFT")
    lookup = lookup.replace("Ctrl", "CTRL")
    lookup = lookup.replace("Alt", "ALT")
    lookup = lookup.replace("Super", "SUPER")

    description = descriptions.get(lookup)

    if not description:
        description = "Keybind"

    if display not in seen:
        print(f"{display:<32}  {description}")
        seen.add(display)

PY
rofi \
    -dmenu \
    -i \
    -no-custom \
    -p "󰌌  Keybinds" \
    -theme "$THEME"
