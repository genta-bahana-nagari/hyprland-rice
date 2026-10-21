#!/bin/bash
# Caffeine mode - prevent auto-lock and screen-off

STATUS_FILE="/tmp/caffeine-status"

if [ -f "$STATUS_FILE" ] && [ "$(cat "$STATUS_FILE")" = "active" ]; then
    # Caffeine is active, turn it off
    systemctl --user start hypridle.service
    rm -f "$STATUS_FILE"
    notify-send "☕ Caffeine Mode" "Disabled - Auto-lock restored"
else
    # Activate caffeine mode
    systemctl --user stop hypridle.service
    echo "active" > "$STATUS_FILE"
    notify-send "☕ Caffeine Mode" "Enabled - Auto-lock disabled"
fi
