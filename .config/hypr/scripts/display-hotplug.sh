
#!/usr/bin/env bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat - "UNIX-CONNECT:$SOCKET" |
while IFS= read -r event; do
    case "$event" in
        monitoradded\>\>*)
            # Give Hyprland a moment to finish configuring the output.
            sleep 1

            # Open the popup; if it is cancelled, leave the layout alone.
            ~/.config/hypr/scripts/display-mode.sh
            ;;
    esac
done
