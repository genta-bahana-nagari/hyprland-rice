#!/bin/bash
# Bluetooth manager with Rofi interface

# Check if bluetooth is enabled
if ! bluetoothctl show | grep -q "Powered: yes"; then
    ENABLE=$(echo -e "Yes\nNo" | rofi -dmenu -p "Bluetooth is off. Enable?" -theme ~/.config/rofi/styles/simple.rasi)
    if [ "$ENABLE" = "Yes" ]; then
        bluetoothctl power on
        sleep 1
    else
        exit 0
    fi
fi

# Main menu
MENU="  Paired Devices\n  Scan & Pair New\n  Disconnect All\n  Power Off"
CHOICE=$(echo -e "$MENU" | rofi -dmenu -p "Bluetooth" -theme ~/.config/rofi/styles/simple.rasi)

case "$CHOICE" in
    *"Paired Devices")
        # List paired devices with connection status
        DEVICES=$(bluetoothctl devices Paired | while read -r _ mac name; do
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                echo "  $name|$mac|connected"
            else
                echo "  $name|$mac|disconnected"
            fi
        done)
        
        if [ -z "$DEVICES" ]; then
            notify-send "Bluetooth" "No paired devices"
            exit 0
        fi
        
        SELECTED=$(echo "$DEVICES" | rofi -dmenu -p "Select Device" -theme ~/.config/rofi/styles/simple.rasi | cut -d'|' -f2)
        
        if [ -n "$SELECTED" ]; then
            if bluetoothctl info "$SELECTED" | grep -q "Connected: yes"; then
                bluetoothctl disconnect "$SELECTED"
                notify-send "Bluetooth" "Disconnected"
            else
                bluetoothctl connect "$SELECTED" && notify-send "Bluetooth" "Connected" || notify-send "Bluetooth" "Connection failed"
            fi
        fi
        ;;
        
    *"Scan")
        notify-send "Bluetooth" "Scanning for devices..."
        bluetoothctl scan on &
        SCAN_PID=$!
        sleep 5
        
        DEVICES=$(bluetoothctl devices | awk '{print substr($0, index($0,$3)) "|" $2}')
        kill $SCAN_PID 2>/dev/null
        bluetoothctl scan off
        
        if [ -z "$DEVICES" ]; then
            notify-send "Bluetooth" "No devices found"
            exit 0
        fi
        
        SELECTED=$(echo "$DEVICES" | rofi -dmenu -p "Select to Pair" -theme ~/.config/rofi/styles/simple.rasi | cut -d'|' -f2)
        
        if [ -n "$SELECTED" ]; then
            bluetoothctl pair "$SELECTED" && \
            bluetoothctl trust "$SELECTED" && \
            bluetoothctl connect "$SELECTED" && \
            notify-send "Bluetooth" "Paired and connected" || \
            notify-send "Bluetooth" "Pairing failed"
        fi
        ;;
        
    *"Disconnect All")
        bluetoothctl devices | awk '{print $2}' | xargs -I {} bluetoothctl disconnect {}
        notify-send "Bluetooth" "All devices disconnected"
        ;;
        
    *"Power Off")
        bluetoothctl power off
        notify-send "Bluetooth" "Powered off"
        ;;
esac
