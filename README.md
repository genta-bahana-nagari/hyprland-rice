# Hyprland Rice 🌌

A personal **Hyprland** setup for Arch Linux and Fedora: modular Hyprland
configuration, Waybar, SwayNC, Rofi, CAVA, Kitty, Fastfetch, Hyprlock,
Hypridle, wallpapers and a set of small desktop scripts.

The goal is a clean, fast Wayland desktop that is easy to read, re-theme and
extend — not a giant all-in-one distribution.

> [!WARNING]
> **This project is under active development.**
> Configuration structure, scripts, packages, themes and keybindings may
> change at any time. Expect rough edges, and always keep a backup of your
> existing `~/.config`. If something breaks after an update, the previous
> configs are in `~/.config-backup-<timestamp>`.

---

## Table of Contents

- [What you get](#what-you-get)
- [Supported systems](#supported-systems)
- [Requirements](#requirements)
- [Installation](#installation)
- [What the installer actually does](#what-the-installer-actually-does)
- [The installer scripts](#the-installer-scripts)
- [Updating](#updating)
- [Repository structure](#repository-structure)
- [Configuration](#configuration)
- [Themes](#themes)
- [Keybindings](#keybindings)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Backup and restore](#backup-and-restore)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)
- [License](#license)

---

## What you get

| Component | Description |
| --- | --- |
| **Hyprland** | Tiling Wayland compositor, configured with Lua modules |
| **Waybar** | Status bar with 46 themes and a Rofi theme switcher |
| **SwayNC** | Notification daemon and control center (Nova Dark theme) |
| **Rofi** | Application launcher, power menu, clipboard, Wi-Fi, wallpaper, theme, emoji, and window switchers |
| **CAVA** | Audio visualizer with custom GLSL shaders and two themes |
| **Kitty** | Default terminal with a custom Oh My Posh prompt (swappable) |
| **Apps** | Optional browser, file manager, editor, viewer, player and calculator |
| **Dev tools** | Optional VS Code, Postman, Discord and Spotify (Flatpak) |
| **Fastfetch** | System information with a custom ASCII logo |
| **Hyprlock** | Lock screen |
| **Hypridle** | Idle and power management |
| **SwayOSD** | On-screen display for volume and brightness |
| **Wallpapers** | Wallpaper switcher, automatic rotation and optional wallpaper collections |
| **Scripts** | Wi-Fi management, screen recording, display modes, keybind helper, power menu, screenshot, Bluetooth, audio switcher, emoji picker, window switcher, caffeine mode |

Also configured: clipboard history (Cliphist), dark GTK theme (Adw GTK),
JetBrains Mono and Rubik fonts, and automatic start of the desktop components.

---

## Supported systems

| Distribution | Status | Installer |
| --- | --- | --- |
| **Arch Linux** | Supported | `installer-script/arch-install.sh` |
| **Fedora Linux (tested on 43)** | Supported (script warns on other versions) | `installer-script/fedora-install.sh` |

The configuration itself is generic Wayland/Hyprland config and may work on
other distributions, but the installers only handle Arch and Fedora.

Other distributions are not officially supported. You can still copy the
files from `.config/` manually, but you must install the dependencies
yourself.

---

## Requirements

- A Linux machine with **Wayland** support.
- A **normal user account with sudo** (do not run the installer as root).
- An **internet connection** for packages, fonts, AUR packages and wallpapers.
- At least **5 GB of free space** on your home partition.
- An existing graphical login is recommended: the installer enables **SDDM**.
- **Back up your current `~/.config`** — the installer overwrites files there.

The installer installs packages but does **not** partition disks, install a
bootloader, configure GPU drivers, or create user accounts. Start from a
working Arch or Fedora installation.

### Optional applications

The installer asks which applications you want instead of forcing one set.
Press **Enter** to accept the recommended choice in each category:

| Category | Options | Recommended |
| --- | --- | --- |
| Browser | Firefox, Chromium, Brave*, Google Chrome* | Firefox |
| File manager | Nautilus, Dolphin, Thunar, Nemo | Nautilus |
| Terminal | Kitty, Foot, Alacritty, WezTerm* | Kitty |
| Code editor | Visual Studio Code, Kate, GNOME Text Editor, Gedit | Visual Studio Code |
| Image viewer | Loupe, imv, Gwenview | Loupe |
| Video player | VLC, mpv, Haruna*, GNOME Videos** | VLC |
| Calculator | Qalculate-GTK, GNOME Calculator, KCalc | Qalculate-GTK |

`*` Arch only (AUR packages for Brave/Chrome, plus WezTerm and Haruna).
On Fedora use Flatpak if you need Brave or Chrome.
`**` Fedora only (GNOME Videos).

It also asks about **Postman**, **Discord** and **Spotify**:

- Postman: native AUR package on Arch, Flatpak on Fedora.
- Discord and Spotify: Flatpak from Flathub.
- Flatpak itself is always installed, so these apps work out of the box.

Your choices are written to
`~/.config/hypr/modules/programs.local.lua`, so `Super + B`, `Super + E`,
`Super + Return`, `Super + C` and the Postman/Discord/Spotify keybinds launch
what you picked. `update.sh` does not touch that file.

Clipboard history (`wl-clipboard`, `wl-clip-persist`), media keys
(`playerctl`) and CAVA on Arch are now installed by default.

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/genta-bahana-nagari/hyprland-rice.git
cd hyprland-rice
```

### 2. Review the installer (recommended)

The scripts install packages, copy configs and enable services. Read them
before running, especially on an existing system:

```bash
less install.sh
less installer-script/arch-install.sh
less installer-script/fedora-install.sh
```

### 3. Run the installer

```bash
./install.sh
```

If the file is not executable:

```bash
chmod +x install.sh
./install.sh
```

You will see a menu:

```text
Please select your distribution:

  1) Arch Linux
  2) Fedora Linux
  3) Cancel
```

Choose your distribution and confirm the prompt. The selected installer takes
over from there.

Next you get the **application selection** menu. Press **Enter** to accept
every recommended choice, or type a number to switch browser, file manager,
terminal, editor, viewer, player and calculator. See
[Optional applications](#optional-applications) for the list.

You can also run a distribution installer directly:

```bash
# Arch Linux
./installer-script/arch-install.sh

# Fedora Linux
./installer-script/fedora-install.sh
```

### 4. Reboot

At the end the installer asks whether to reboot. After rebooting, choose the
**Hyprland** session in SDDM.

### 5. First login

A few things are machine-specific and will probably need a small edit:

- **Monitors** — `.config/hypr/modules/monitors.lua`
- **Input devices** — `.config/hypr/modules/input.lua`

The default monitor config targets `eDP-1` at `1920x1080@60`. If your display
has a different name or resolution, Hyprland may fall back to auto-detection,
or you can edit the file and reload:

```bash
hyprctl reload
```

---

## What the installer actually does

Both installers follow the same basic flow:

1. Check that the system is the expected distribution and that there is enough
   disk space.
2. Ask which applications you want (Enter accepts the recommendations).
3. Update the system and install the required packages.
4. Add the Microsoft VS Code repository on Fedora if VS Code was selected.
5. Install Flatpak apps (Postman on Fedora, Discord, Spotify) from Flathub.
6. Install fonts and rebuild the font cache.
7. Copy `.config/*` into `~/.config/` (**overwriting existing files**).
8. Save your app choices to `~/.config/hypr/modules/programs.local.lua`.
9. Copy Hyprland systemd user services into `~/.config/systemd/user/`.
10. Copy the bundled wallpapers into `~/Pictures/Wallpaper/`.
11. Optionally clone extra wallpaper collections and copy them into the same
    folder (existing files are not overwritten).
12. Install **Oh My Posh** and append its init line to `~/.bashrc`.
13. Enable `sddm`, `NetworkManager` and `power-profiles-daemon`.
14. Offer to reboot.

> [!NOTE]
> The installer does not create a backup of your existing configuration.
> Back it up yourself before the first install:
>
> ```bash
> cp -a ~/.config "$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"
> ```

---

## The installer scripts

### `install.sh`

Small entry point. Shows the ASCII banner, asks for the distribution, then
`exec`s the matching script:

```text
install.sh
    ├── Arch Linux   → installer-script/arch-install.sh
    └── Fedora Linux → installer-script/fedora-install.sh
```

### `installer-script/arch-install.sh`

Arch-specific installer. Main steps:

| Step | Details |
| --- | --- |
| Checks | Not root, sudo available, `/etc/arch-release` present, 5 GB free |
| App selection | Browser, file manager, terminal, editor, viewers, Postman, Discord, Spotify |
| System update | `pacman -Syu` |
| AUR helper | Installs `yay` from the AUR if missing |
| Official packages | Hyprland, portals, Hypridle/Hyprlock/Hyprshot, Waybar, Rofi, SwayNC, SDDM, NetworkManager, CAVA, Flatpak, fonts, clipboard/media utilities |
| AUR packages | `ttf-rubik`, `ttf-rubik-vf`, plus selected AUR apps (Brave, Chrome, Postman) |
| Flatpak | Flathub remote + selected Flatpak apps |
| Verification | Checks important packages and commands, then font matching |
| Deployment | Configs, app choices, user services, wallpapers, Oh My Posh |
| Services | Enables `sddm`, `NetworkManager`, `power-profiles-daemon` |

### `installer-script/fedora-install.sh`

Fedora-specific installer, written for **Fedora 43**. Main steps:

| Step | Details |
| --- | --- |
| Checks | `/etc/fedora-release`, Fedora version (warns if not 43), 5 GB free |
| App selection | Browser, file manager, terminal, editor, viewers, Postman, Discord, Spotify |
| System update | `dnf upgrade` |
| Repositories | RPM Fusion Free/Nonfree and the `lionheartp/Hyprland` COPR |
| VS Code repo | Microsoft repo, only when VS Code was selected |
| Packages | Hyprland stack, Waybar, Rofi, SwayNC, SDDM, CAVA, Flatpak, fonts, clipboard/media utilities |
| Flatpak | Flathub remote + selected Flatpak apps (Postman, Discord, Spotify) |
| Fonts | `jetbrains-mono-fonts`, `google-rubik-fonts`, font cache rebuild |
| Deployment | Configs, app choices, user services, wallpapers, Oh My Posh |
| Services | Enables `sddm`, `NetworkManager`, `power-profiles-daemon` |

Both installers are idempotent for packages: already-installed packages are
skipped. Configuration files are **not** merged — files from the repo replace
the files in `~/.config`.

---

## Updating

Use the updater when you have installed from this repository and want the
latest configs without reinstalling packages.

```bash
cd hyprland-rice
./update.sh
```

If needed:

```bash
chmod +x update.sh
```

### What `update.sh` does

1. Verifies it is running inside a git clone of this repository.
2. Warns if the clone has uncommitted local changes.
3. Backs up the currently deployed configs to
   `~/.config-backup-<YYYYMMDD-HHMMSS>/`.
4. Runs `git pull --ff-only`.
5. Copies the latest `.config/*` into `~/.config/`.
6. Restores your selected Waybar theme (or uses `default`).
7. Leaves `programs.local.lua` alone, so your browser/terminal/editor choices
   survive the update.
8. Makes shell scripts executable, updates user systemd services and reloads
   the user systemd manager.
9. Adds new bundled wallpapers **without overwriting** wallpapers you already
   have.
10. Reloads Hyprland, Waybar and SwayNC if they are running.

It does **not** update packages, install new dependencies, re-enable services,
or modify `~/.bashrc`. If an update introduces a new dependency, re-run the
installer or install the package with your package manager.

### Manual update

If you prefer to do it yourself:

```bash
cd hyprland-rice
git pull
cp -rf .config/* ~/.config/
hyprctl reload
```

> [!WARNING]
> `update.sh` overwrites the config files it manages. Your backup is the
> `~/.config-backup-*` directory printed at the end of the run. Local edits to
> files that exist in the repository **will be replaced**.

### If `git pull` fails

- Local changes in the clone: `git status`, then commit, stash or discard them.
- No network: retry later.
- Not a git clone (for example, a downloaded ZIP): delete it and clone the
  repository again, then run `./update.sh`.

---

## Repository structure

```text
.
├── .config/                     # Mirrors ~/.config after installation
│   ├── awww/
│   │   └── scripts/wallpaper-rotate.sh
│   ├── cava/
│   │   ├── shaders/             # Custom GLSL shaders
│   │   ├── themes/              # solarized_dark, tricolor
│   │   ├── config
│   │   └── config.bak
│   ├── fastfetch/
│   │   ├── config.jsonc
│   │   └── logo.txt
│   ├── hypr/
│   │   ├── modules/             # Lua configuration modules
│   │   ├── scripts/             # Desktop helper scripts
│   │   ├── service/             # systemd user services
│   │   ├── hyprland.lua         # Entry point
│   │   ├── hypridle.conf
│   │   └── hyprlock.conf
│   ├── kitty/
│   │   ├── kitty.conf
│   │   └── custom-theme.omp.json
│   ├── rofi/
│   │   ├── colors/              # onedark
│   │   ├── shared/              # colors and fonts
│   │   ├── styles/              # .rasi interfaces
│   │   └── launcher.sh
│   ├── swaync/
│   │   ├── colors/
│   │   ├── icons/
│   │   ├── themes/nova-dark/
│   │   ├── config.json
│   │   └── style.css
│   ├── swayosd/
│   │   └── style.css
│   └── waybar/
│       ├── scripts/
│       ├── themes/              # 46 Waybar themes
│       ├── config.jsonc         # symlink to the active theme
│       └── style.css            # symlink to the active theme
├── Wallpaper/
├── installer-script/
│   ├── apps.sh                  # shared application menu
│   ├── arch-install.sh
│   └── fedora-install.sh
├── install.sh
├── update.sh
└── README.md
```

---

## Configuration

### Hyprland

Entry point:

```text
.config/hypr/hyprland.lua
```

It only loads the modules:

| Module | Purpose |
| --- | --- |
| `animations.lua` | Animation configuration |
| `autostart.lua` | Applications and services started with Hyprland |
| `decoration.lua` | Decorations, blur, rounding, visual effects |
| `environment.lua` | Environment variables |
| `input.lua` | Keyboard, mouse and touchpad settings |
| `keybinds.lua` | Keyboard and mouse shortcuts |
| `layout.lua` | Window layout behavior |
| `misc.lua` | Miscellaneous Hyprland settings |
| `monitors.lua` | Monitor configuration |
| `permissions.lua` | Permission-related settings |
| `programs.lua` | Program/command definitions used by keybinds |
| `windowrules.lua` | Window-specific rules |

Hyprland starts Waybar, SwayNC, Hypridle, SwayOSD, the clipboard watchers,
`awww-daemon`, wallpaper rotation and display hotplug detection.

### Hyprland scripts

```text
.config/hypr/scripts/
├── display-hotplug.sh
├── display-mode.sh
├── keybinds.sh
├── power-menu.sh
├── screen-record.sh
├── show-current-theme.sh
├── wallpaper-switch.sh
├── wifi-disconnect.sh
└── wifi-mananger.sh
```

| Script | Purpose |
| --- | --- |
| `display-hotplug.sh` | Reacts to monitor hotplug events |
| `display-mode.sh` | Display mode helpers |
| `keybinds.sh` | Rofi keybind dictionary |
| `power-menu.sh` | Power menu actions |
| `screen-record.sh` | Screen recording with `wf-recorder` |
| `show-current-theme.sh` | Shows the active wallpaper theme |
| `wallpaper-switch.sh` | Wallpaper picker |
| `wifi-disconnect.sh` | Disconnects from Wi-Fi |
| `wifi-mananger.sh` | Wi-Fi manager |
| `screenshot-menu.sh` | Screenshot menu with edit options |
| `bluetooth-menu.sh` | Bluetooth device manager |
| `audio-device-switcher.sh` | Audio device (sink/source) switcher |
| `emoji-picker.sh` | Emojis picker with favorites |
| `window-switcher.sh` | Search and switch to open windows |
| `caffeine-mode.sh` | Toggle caffeine mode (disable auto-lock) |

> `wifi-mananger.sh` keeps its original filename for compatibility with the
> keybinds. Renaming it would require updating the references as well.

### Waybar

- `scripts/launch.sh` — restarts Waybar and SwayNC.
- `scripts/system-update.sh` — update action for the bar.
- `scripts/theme-switcher.sh` — Rofi picker; switches `config.jsonc` and
  `style.css` to the selected theme, then restarts Waybar.
- `themes/` — 46 themes, each with its own `config.jsonc` and `style.css`.

The top-level `config.jsonc` and `style.css` are symlinks to the active theme.

### Rofi

- `launcher.sh` — application launcher entry point.
- `colors/onedark.rasi` — One Dark palette.
- `shared/colors.rasi`, `shared/fonts.rasi` — shared colors and fonts.
- `styles/` — launcher, power menu, keybind dictionary, theme switcher,
  wallpaper picker, Wi-Fi manager, Wi-Fi password prompt, display mode,
  Bluetooth, audio device and window switcher themes.

All Rofi menus use the same pattern: each script references its theme with an
absolute path, `$HOME/.config/rofi/styles/<name>.rasi`. The menu pickers
(display mode, Bluetooth, audio device and window switcher) share the themed
`wifimanager-style.rasi` look instead of the plain default.

### SwayNC

- `config.json` — notification and control-center behavior.
- `style.css` — main stylesheet.
- `colors/colors.css` — color variables.
- `themes/nova-dark/` — central control and notification styles.
- `icons/` — custom icons for volume, brightness, microphone, music, gaming
  mode, timer, theme and wallpaper controls.

### CAVA

- `config` — main configuration (a backup is kept as `config.bak`).
- `themes/solarized_dark`, `themes/tricolor` — color themes.
- `shaders/` — GLSL shaders: bar spectrum, eye of phi, northern lights,
  spectrogram, Winamp-style line spectrum and a vertex pass-through shader.

### Kitty and Fastfetch

- `.config/kitty/kitty.conf` — terminal configuration.
- `.config/kitty/custom-theme.omp.json` — Oh My Posh prompt theme.
- `.config/fastfetch/config.jsonc` — Fastfetch layout.
- `.config/fastfetch/logo.txt` — custom ASCII logo.

### Wallpapers

Bundled wallpapers live in `Wallpaper/` and are deployed to
`~/Pictures/Wallpaper/`. The installer can optionally download extra
wallpaper collections from
[`wp-collection`](https://github.com/genta-bahana-nagari/wp-collection).
Wallpaper rotation runs in the background and changes the wallpaper
periodically.

---

## Themes

| Component | Themes |
| --- | --- |
| **Waybar** | 46 themes in `waybar/themes/`, including `default`, `nord`, `retro`, `dracula`, `ocean`, `aurora`, `coffee`, `cyber`, `forest`, `sakura`, `terminal`, `frost` and `minimalist`, with `simple`/`maximum` and `v1`/`v2` variants |
| **CAVA** | `solarized_dark`, `tricolor` |
| **SwayNC** | `nova-dark` |
| **Rofi** | One Dark color scheme |

Switch the Waybar theme with **Super + Ctrl + W** (or run
`.config/waybar/scripts/theme-switcher.sh`). The script updates the symlinks
and restarts Waybar.

---

## Keybindings

The main modifier is **Super** (Windows key). The full list is in
`.config/hypr/modules/keybinds.lua` and in the in-desktop keybind dictionary
(**Super + K**).

| Shortcut | Action |
| --- | --- |
| `Super + Return` | Terminal (choice) |
| `Super + D` | Application launcher (Rofi) |
| `Super + E` | File manager (choice) |
| `Super + B` | Browser (choice) |
| `Super + C` | Code editor (choice) |
| `Super + Shift + P` | Postman |
| `Super + Shift + D` | Discord (Flatpak) |
| `Super + Shift + M` | Spotify (Flatpak) |
| `Super + Q` | Close window |
| `Super + M` | Toggle fullscreen |
| `Super + Space` | Toggle floating |
| `Super + Alt + P` | Toggle pseudo-tiling |
| `Super + P` | Display mode helper |
| `Super + V` | Clipboard history |
| `Super + W` | Wallpaper switcher |
| `Super + Ctrl + W` | Waybar theme switcher (Caffeine mode also has Waybar widget) |
| `Super + N` | Notifications (SwayNC) |
| `Super + Shift + N` | Wi-Fi manager |
| `Super + Ctrl + N` | Disconnect Wi-Fi |
| `Super + S` | Screenshot (output) |
| `Super + Shift + S` | Screenshot (region) |
| `Super + Ctrl + S` | Screenshot (window) |
| `Super + Shift + R` | Screen recording |
| `Super + Shift + Delete` | Power menu |
| `Super + R` | Reload Hyprland |
| `Super + K` | Keybind dictionary |
| `Super + Tab` | Window switcher/search |
| `Super + Shift + E` | Emoji picker |
| `Super + Ctrl + B` | Bluetooth manager |
| `Super + Ctrl + A` | Audio device switcher |
| `Super + Ctrl + Shift + C` | Caffeine mode (toggle auto-lock) |
| `Super + Ctrl + Shift + S` | Screenshot menu (with edit options) |

---

## Customization

Change only the component you care about:

| What | Where |
| --- | --- |
| Keybindings | `.config/hypr/modules/keybinds.lua` |
| Monitors | `.config/hypr/modules/monitors.lua` |
| Input devices | `.config/hypr/modules/input.lua` |
| Window rules | `.config/hypr/modules/windowrules.lua` |
| Animations | `.config/hypr/modules/animations.lua` |
| Autostart | `.config/hypr/modules/autostart.lua` |
| Program defaults | `.config/hypr/modules/programs.lua` |
| Selected apps | `~/.config/hypr/modules/programs.local.lua` (installer-generated) |
| Waybar | `.config/waybar/style.css` or `.config/waybar/themes/` |
| Rofi | `.config/rofi/styles/`, `.config/rofi/colors/` |
| SwayNC | `.config/swaync/style.css`, `.config/swaync/themes/` |
| CAVA | `.config/cava/config`, `.config/cava/themes/`, `.config/cava/shaders/` |
| Kitty | `.config/kitty/kitty.conf` |
| Fastfetch | `.config/fastfetch/config.jsonc` |

After changing Hyprland configuration:

```bash
hyprctl reload
```

After changing Waybar, SwayNC or Rofi styles, restart the affected component
(or switch the Waybar theme, which restarts it for you).

> Local edits in `~/.config` are overwritten by `install.sh` and `update.sh`
> if the same file exists in the repository. Keep personal overrides in a
> separate file or commit them to your own fork.

To change a browser/terminal/editor after installation, rerun the installer or
edit `~/.config/hypr/modules/programs.local.lua`, then reload:

```bash
hyprctl reload
```

---

## Troubleshooting

### Hyprland does not start

Check the entry point and modules:

```text
.config/hypr/hyprland.lua
.config/hypr/modules/
```

Look for Lua syntax errors. Start Hyprland from a TTY to read the error
output:

```bash
Hyprland
```

### Waybar does not appear

```bash
waybar
```

Check the error output, then inspect:

```text
.config/waybar/config.jsonc
.config/waybar/style.css
```

If those symlinks point to a missing theme, switch to a valid theme:

```bash
ln -sfn themes/default/config.jsonc ~/.config/waybar/config.jsonc
ln -sfn themes/default/style.css ~/.config/waybar/style.css
```

### Rofi menus look wrong

Check the `.rasi` files under `.config/rofi/styles/`. Make sure referenced
colors and fonts exist; Rofi fails silently or falls back when an `@import` is
missing. Menu scripts must point to `$HOME/.config/rofi/styles/<name>.rasi` —
if a script still uses `-theme .../simple.rasi` or no theme at all, update it
to follow the shared pattern.

### SwayNC styling is broken

Check:

```text
.config/swaync/style.css
.config/swaync/config.json
.config/swaync/themes/
```

Then reload:

```bash
swaync-client -rs
```

### Wallpaper does not change

Check `Wallpaper/`, `~/Pictures/Wallpaper/`, `awww-daemon` and
`.config/hypr/scripts/wallpaper-switch.sh`. Make sure the files exist and the
scripts are executable:

```bash
chmod +x .config/hypr/scripts/*.sh
chmod +x .config/waybar/scripts/*.sh
chmod +x .config/rofi/launcher.sh
```

### Monitors are wrong or one screen is black

Edit `.config/hypr/modules/monitors.lua`. Get the output names with:

```bash
hyprctl monitors
```

### Fonts look different

```bash
fc-cache -f
fc-match "JetBrains Mono"
fc-match "Rubik"
```

Install `ttf-jetbrains-mono-nerd` (Arch) or `jetbrains-mono-fonts` +
`google-rubik-fonts` (Fedora) if they are missing.

### An update broke something

Restore the backup created by `update.sh`:

```bash
cp -a ~/.config-backup-<timestamp>/. ~/.config/
hyprctl reload
```

### I want to start over

Back up `~/.config`, delete the directories managed by this repo, and run
`./install.sh` again.

---

## Backup and restore

Before the first install:

```bash
cp -a ~/.config "$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"
```

`update.sh` creates `~/.config-backup-<timestamp>/` automatically and backs up
only the top-level `~/.config` directories that this repository manages.

Restore a single component:

```bash
cp -a ~/.config-backup-<timestamp>/waybar ~/.config/
```

Restore everything from that backup:

```bash
cp -a ~/.config-backup-<timestamp>/. ~/.config/
```

---

## Contributing

Contributions, fixes and new themes are welcome.

1. Test the relevant configuration or script.
2. Keep Hyprland configuration modular.
3. Do not break existing themes or keybinds.
4. Update documentation when behavior changes.
5. Keep installer changes working on both Arch and Fedora where applicable.

---

## Disclaimer

These dotfiles are provided for personal use and experimentation. They are not
a supported distribution and may not work on every machine. Review the
scripts before running them, back up your configuration, and expect changes
while the project is under development.

Use at your own risk.

---

## License

No license has been specified yet. Until one is added, treat this as personal
configuration rather than a package you can freely redistribute. If you want
others to reuse it, add an open-source license such as MIT or GPL-3.0.

---

## Status

**Work in progress 🚧**

Configuration structure, scripts, themes, package lists and supported
distributions may change without notice. Check the repository, read the
scripts, and keep backups. Bug reports and suggestions are welcome.
