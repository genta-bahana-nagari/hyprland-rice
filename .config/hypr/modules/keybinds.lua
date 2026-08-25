---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("modules.programs")
local mainMod = "SUPER"

--------------------------------------------------
-- Apps / Core
--------------------------------------------------

hl.bind(
    mainMod .. " + Return",
    hl.dsp.exec_cmd(programs.terminal)
)

hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(programs.fileManager)
)

hl.bind(
    mainMod .. " + B",
    hl.dsp.exec_cmd(programs.browser)
)

hl.bind(
    mainMod .. " + C",
    hl.dsp.exec_cmd(programs.code)
)

hl.bind(
    mainMod .. " + D",
    hl.dsp.exec_cmd(programs.menu)
)

hl.bind(
    mainMod .. " + P",
    hl.dsp.exec_cmd("command postman")
)

hl.bind(
    mainMod .. " + N",
    hl.dsp.exec_cmd("swaync-client -t")
)

hl.bind(
    mainMod .. " + SHIFT + N",
    hl.dsp.exec_cmd(programs.wifiManager)
)

hl.bind(
    mainMod .. " + CTRL + N",
    hl.dsp.exec_cmd(programs.wifiDisconnect)
)

-- Screen Record
hl.bind(
    mainMod .. " + SHIFT + R",
    hl.dsp.exec_cmd(programs.screenRecord)
)

-- Keybinds
hl.bind(
    mainMod .. " + K",
    hl.dsp.exec_cmd(programs.keybinds)
)

--------------------------------------------------
-- Window Management
--------------------------------------------------

-- Close active window
hl.bind(
    mainMod .. " + Q",
    hl.dsp.window.close()
)

-- Logout / Power menu
hl.bind(
    mainMod .. " + SHIFT + Delete",
    hl.dsp.exec_cmd(programs.rofiLogout)
)

-- Wallpaper switcher
hl.bind(
    mainMod .. " + W",
    hl.dsp.exec_cmd(programs.wallpaperSwitcher)
)

-- Toggle Waybar
hl.bind(
    mainMod .. " + SHIFT + W",
    hl.dsp.exec_cmd(
        "pgrep waybar && pkill waybar || waybar"
    )
)

-- Waybar theme switcher
hl.bind(
    mainMod .. " + CTRL + W",
    hl.dsp.exec_cmd(programs.waybarSwitcher)
)

-- Fullscreen
hl.bind(
    mainMod .. " + M",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "toggle"
    })
)

-- Toggle floating
hl.bind(
    mainMod .. " + SPACE",
    hl.dsp.window.float({
        action = "toggle"
    })
)

-- Toggle pseudo
hl.bind(
    mainMod .. " + SHIFT + P",
    hl.dsp.window.pseudo()
)

--------------------------------------------------
-- Focus Management
--------------------------------------------------

hl.bind(
    mainMod .. " + left",
    hl.dsp.focus({
        direction = "left"
    })
)

hl.bind(
    mainMod .. " + right",
    hl.dsp.focus({
        direction = "right"
    })
)

hl.bind(
    mainMod .. " + up",
    hl.dsp.focus({
        direction = "up"
    })
)

hl.bind(
    mainMod .. " + down",
    hl.dsp.focus({
        direction = "down"
    })
)

--------------------------------------------------
-- Resize Window
--------------------------------------------------

hl.bind(
    mainMod .. " + SHIFT + left",
    hl.dsp.window.resize({
        x = -50,
        y = 0,
        relative = true
    })
)

hl.bind(
    mainMod .. " + SHIFT + right",
    hl.dsp.window.resize({
        x = 50,
        y = 0,
        relative = true
    })
)

hl.bind(
    mainMod .. " + SHIFT + up",
    hl.dsp.window.resize({
        x = 0,
        y = -50,
        relative = true
    })
)

hl.bind(
    mainMod .. " + SHIFT + down",
    hl.dsp.window.resize({
        x = 0,
        y = 50,
        relative = true
    })
)

--------------------------------------------------
-- Move Window
--------------------------------------------------

hl.bind(
    mainMod .. " + CTRL + left",
    hl.dsp.window.move({
        direction = "left"
    })
)

hl.bind(
    mainMod .. " + CTRL + right",
    hl.dsp.window.move({
        direction = "right"
    })
)

hl.bind(
    mainMod .. " + CTRL + up",
    hl.dsp.window.move({
        direction = "up"
    })
)

hl.bind(
    mainMod .. " + CTRL + down",
    hl.dsp.window.move({
        direction = "down"
    })
)

--------------------------------------------------
-- Swap Window
--------------------------------------------------

hl.bind(
    mainMod .. " + ALT + left",
    hl.dsp.window.swap({
        direction = "left"
    })
)

hl.bind(
    mainMod .. " + ALT + right",
    hl.dsp.window.swap({
        direction = "right"
    })
)

hl.bind(
    mainMod .. " + ALT + up",
    hl.dsp.window.swap({
        direction = "up"
    })
)

hl.bind(
    mainMod .. " + ALT + down",
    hl.dsp.window.swap({
        direction = "down"
    })
)

--------------------------------------------------
-- Workspaces
--------------------------------------------------

-- Switch workspace
-- 0 = workspace 10

for i = 1, 10 do
    local key = i % 10

    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({
            workspace = i
        })
    )

    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i
        })
    )
end

--------------------------------------------------
-- Special Workspace
--------------------------------------------------

-- Disabled in old config
--
-- bind = $mainMod, S, togglespecialworkspace, magic
-- bind = $mainMod SHIFT, S, movetoworkspace, special:magic

--------------------------------------------------
-- Mouse
--------------------------------------------------

-- Next workspace
hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({
        workspace = "e+1"
    })
)

-- Previous workspace
hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({
        workspace = "e-1"
    })
)

-- Move window
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true
    }
)

-- Resize window
hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true
    }
)

--------------------------------------------------
-- Media and Screen Keys
--------------------------------------------------

-- Volume Up
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "swayosd-client --output-volume +2"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- Volume Down
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "swayosd-client --output-volume -2"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- Mute
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "swayosd-client --output-volume mute-toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- Microphone Mute
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "swayosd-client --input-volume mute-toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

--------------------------------------------------
-- Brightness
--------------------------------------------------

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(
        "swayosd-client --brightness +5"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(
        "swayosd-client --brightness -5"
    ),
    {
        locked = true,
        repeating = true
    }
)

--------------------------------------------------
-- Clipboard
--------------------------------------------------

hl.bind(
    mainMod .. " + V",
    hl.dsp.exec_cmd(
        'cliphist list | rofi -dmenu -display-columns 2 -p "Cliboard" -theme ~/.config/rofi/styles/simple.rasi | cliphist decode | wl-copy'
    )
)

--------------------------------------------------
-- Media Controls
--------------------------------------------------

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd(
        "playerctl next"
    ),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd(
        "playerctl play-pause"
    ),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd(
        "playerctl play-pause"
    ),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd(
        "playerctl previous"
    ),
    {
        locked = true
    }
)

--------------------------------------------------
-- Screenshot
--------------------------------------------------

local screenshotDir = "~/Pictures/Screenshots"

-- Screenshot output
hl.bind(
    mainMod .. " + S",
    hl.dsp.exec_cmd(
        "mkdir -p " .. screenshotDir ..
        " && hyprshot -m output -o " .. screenshotDir
    )
)

-- Screenshot region
hl.bind(
    mainMod .. " + SHIFT + S",
    hl.dsp.exec_cmd(
        "mkdir -p " .. screenshotDir ..
        " && hyprshot -m region -o " .. screenshotDir
    )
)

-- Screenshot active window
hl.bind(
    mainMod .. " + CTRL + S",
    hl.dsp.exec_cmd(
        "mkdir -p " .. screenshotDir ..
        " && hyprshot -m window -o " .. screenshotDir
    )
)
