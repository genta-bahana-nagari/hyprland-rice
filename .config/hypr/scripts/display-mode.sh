
#!/usr/bin/env bash
set -euo pipefail

# Find the laptop's built-in panel.
INTERNAL="$(hyprctl -j monitors all | jq -r \
  '[.[] | select(.name | test("^(eDP|LVDS)"))][0].name // empty')"

if [[ -z "$INTERNAL" ]]; then
    notify-send "Display mode" "Could not detect the laptop display."
    exit 1
fi

# Find an external output that is currently active.
EXTERNAL="$(hyprctl -j monitors | jq -r \
  --arg internal "$INTERNAL" \
  '[.[] | select(.name != $internal)][0].name // empty')"

# Re-detect the external output when the user chooses a mode.
get_external() {
    hyprctl -j monitors all | jq -r \
      --arg internal "$INTERNAL" \
      '[.[] | select(.name != $internal)][0].name // empty'
}

apply_mode() {
    local mode="$1"
    local ext
    ext="$(get_external)"

    if [[ -z "$ext" ]]; then
        notify-send "Display mode" "Connect an external display first."
        return 1
    fi

    case "$mode" in
      duplicate)
        hyprctl keyword monitor "$INTERNAL,preferred,0x0,1"
        hyprctl keyword monitor "$ext,preferred,auto,1,mirror,$INTERNAL"
        ;;
      extend)
        hyprctl keyword monitor "$INTERNAL,preferred,0x0,1"
        hyprctl keyword monitor "$ext,preferred,auto,1"
        ;;
      external)
        hyprctl keyword monitor "$ext,preferred,0x0,1"
        hyprctl keyword monitor "$INTERNAL,disable"
        ;;
      internal)
        hyprctl keyword monitor "$INTERNAL,preferred,0x0,1"
        hyprctl keyword monitor "$ext,disable"
        ;;
    esac
}

if [[ "${1:-}" != "" ]]; then
    apply_mode "$1"
    exit
fi

# Popup menu; Escape or Cancel leaves the layout unchanged.
THEME="$HOME/.config/rofi/styles/wifimanager-style.rasi"

choice="$(
    printf '%s\n' \
      'Duplicate — mirror laptop screen' \
      'Extend — use both screens' \
      'Second screen only — turn off laptop panel' \
      'PC screen only — return to laptop' \
      'Cancel / Close' |
    rofi -dmenu -i -p 'Project / Display' -l 5 -theme "$THEME"
)" || exit 0

case "$choice" in
  'Duplicate'*) apply_mode duplicate ;;
  'Extend'*) apply_mode extend ;;
  'Second screen only'*) apply_mode external ;;
  'PC screen only'*) apply_mode internal ;;
  *) exit 0 ;;
esac
