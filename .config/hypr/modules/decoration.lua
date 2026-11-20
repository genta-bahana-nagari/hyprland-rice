-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
local wallust = require("colors-wallust")

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        -- Matikan border sepenuhnya
        border_size = 0,

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 5,

        active_opacity   = 1.0,
        inactive_opacity = 0.85,

        shadow = {
                    enabled        = true,
                    range          = 20,
                    render_power   = 2,
                    offset         = { 0, 4 },

                    color          = "rgba(000000ff)",

                    color_inactive = "rgba(00000055)",
            },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})