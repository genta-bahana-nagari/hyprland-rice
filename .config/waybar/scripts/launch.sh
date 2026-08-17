#!/usr/bin/env bash

pkill waybar
pkill swaync

while pgrep -x waybar >/dev/null; do
    sleep 0.2
done

waybar &
swaync &