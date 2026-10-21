---------------------
---- MY PROGRAMS ----
---------------------

local programs = {
    terminal = "kitty",
    browser = "firefox",
    code = "code",
    menu = "~/.config/rofi/launcher.sh",
    fileManager = "nautilus",
    postman = "postman",
    discord = "flatpak run com.discordapp.Discord",
    spotify = "flatpak run com.spotify.Client",
    wifiManager = "~/.config/hypr/scripts/wifi-mananger.sh",
    wifiDisconnect = "~/.config/hypr/scripts/wifi-disconnect.sh",
    displayMode = "~/.config/hypr/scripts/display-mode.sh",

    rofiLogout = "~/.config/hypr/scripts/power-menu.sh",
    wallpaperSwitcher = "~/.config/hypr/scripts/wallpaper-switch.sh",
    screenRecord = "~/.config/hypr/scripts/screen-record.sh",

    waybarSwitcher = "~/.config/waybar/scripts/theme-switcher.sh",

    keybinds = "~/.config/hypr/scripts/keybinds.sh",
}

-- Installer-selected applications. Kept in a separate file so
-- update.sh does not overwrite the user's choices.
local ok, overrides = pcall(require, "modules.programs.local")
if ok and type(overrides) == "table" then
    for key, value in pairs(overrides) do
        programs[key] = value
    end
end

return programs
