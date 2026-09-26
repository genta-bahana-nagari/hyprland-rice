--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = {
        class = "hyprland-run",
    },

    move  = "20 monitor_h-120",
    float = true,
})

-- nwg-look
hl.window_rule({
    name = "ngw-look-float",
    match = {
        class = "nwg-look",
    },

    float = true,
})

-- GNOME Loupe image viewer
hl.window_rule({
    name = "imageviewer-float",
    match = {
        class = "org.gnome.Loupe",
    },

    float = true,
})

-- Pavucontrol
hl.window_rule({
    name = "pavucontrol-float",
    match = {
        class = "org.pulseaudio.pavucontrol",
    },

    float = true,
})

-- Spotify
hl.window_rule({
    name = "spotify-float",
    match = {
        class = "spotify",
    },

    float = true,
    size   = "1366 768",
    center = true,
})

-- Kitty floating window
-- Disabled in the original configuration.
--
-- hl.window_rule({
--     name = "kitty-float",
--     match = {
--         class = "kitty",
--     },
--
--     float  = true,
--     size   = "900 450",
--     center = true,
-- })

-- Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
--
-- Disabled in the original configuration.
--
-- workspace = w[tv1], gapsout:0, gapsin:0
-- workspace = f[1], gapsout:0, gapsin:0
--
-- hl.window_rule({
--     name = "no-gaps-wtv1",
--     match = {
--         float     = false,
--         workspace = "w[tv1]",
--     },
--
--     border_size = 0,
--     rounding   = 0,
-- })
--
-- hl.window_rule({
--     name = "no-gaps-f1",
--     match = {
--         float     = false,
--         workspace = "f[1]",
--     },
--
--     border_size = 0,
--     rounding   = 0,
-- })
