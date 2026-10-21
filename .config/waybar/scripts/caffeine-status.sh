#!/bin/bash
# Waybar caffeine mode status widget

STATUS_FILE="/tmp/caffeine-status"

if [ -f "$STATUS_FILE" ] && [ "$(cat "$STATUS_FILE")" = "active" ]; then
    echo '{"text": "☕", "tooltip": "Caffeine Mode: Active", "class": "active"}'
else
    echo '{"text": "", "tooltip": "Caffeine Mode", "class": "inactive"}'
fi
