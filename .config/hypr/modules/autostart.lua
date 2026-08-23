-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes
-- (notification daemons, status bars, etc.)

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")

    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")

    hl.exec_cmd("hypridle")
    hl.exec_cmd("swayosd-server")

    hl.exec_cmd(
        "wl-paste --type text --watch cliphist store"
    )

    hl.exec_cmd(
        "wl-paste --type image --watch cliphist store"
    )

    hl.exec_cmd(
        "wl-clip-persist --clipboard regular"
    )

    hl.exec_cmd(
        "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'"
    )

    hl.exec_cmd(
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
    )

    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )

    hl.exec_cmd(
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )
end)
