-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Cursor
hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")

-- GTK / Theme
hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")
hl.env("GDK_BACKEND", "wayland,x11")

-- Qt
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Other toolkits
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
