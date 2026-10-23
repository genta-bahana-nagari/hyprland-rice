#!/bin/bash
# Audio device switcher (sinks and sources)
THEME="$HOME/.config/rofi/styles/wifimanager-style.rasi"

# Get list of sinks (output devices)
get_sinks() {
    pactl list sinks | awk '
        /^Sink #/{sink=$2}
        /Description:/{desc=substr($0, index($0,$2)); print sink"|"desc}
    '
}

# Get list of sources (input devices)
get_sources() {
    pactl list sources | awk '
        /^Source #/{source=$2}
        /Description:/{desc=substr($0, index($0,$2)); print source"|"desc}
    '
}

# Main menu
MENU="  Output Devices (Speakers/Headphones)\n  Input Devices (Microphone)"
CHOICE=$(echo -e "$MENU" | rofi -dmenu -p "Audio Device" -theme "$THEME")

case "$CHOICE" in
    *"Output")
        SINKS=$(get_sinks)
        SELECTED=$(echo "$SINKS" | awk -F'|' '{print $2}' | rofi -dmenu -p "Select Output" -theme "$THEME")

        if [ -n "$SELECTED" ]; then
            SINK_ID=$(echo "$SINKS" | grep "$SELECTED" | cut -d'|' -f1)
            pactl set-default-sink "$SINK_ID"
            notify-send "Audio" "Switched to: $SELECTED"
        fi
        ;;

    *"Input")
        SOURCES=$(get_sources | grep -v "monitor")
        SELECTED=$(echo "$SOURCES" | awk -F'|' '{print $2}' | rofi -dmenu -p "Select Input" -theme "$THEME")

        if [ -n "$SELECTED" ]; then
            SOURCE_ID=$(echo "$SOURCES" | grep "$SELECTED" | cut -d'|' -f1)
            pactl set-default-source "$SOURCE_ID"
            notify-send "Audio" "Switched to: $SELECTED"
        fi
        ;;
esac
