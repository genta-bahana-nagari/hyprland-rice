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
| **Rofi** | Application launcher, power menu, clipboard, Wi-Fi, wallpaper and theme pickers |
| **CAVA** | Audio visualizer with custom GLSL shaders and two themes |
| **Kitty** | Terminal with a custom Oh My Posh prompt |
| **Fastfetch** | System information with a custom ASCII logo |
| **Hyprlock** | Lock screen |
| **Hypridle** | Idle and power management |
| **SwayOSD** | On-screen display for volume and brightness |
| **Wallpapers** | Wallpaper switcher, automatic rotation and optional wallpaper collections |
| **Scripts** | Wi-Fi management, screen recording, display modes, keybind helper, power menu |

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

### Optional extras

A few features rely on packages that are not in every installer package list:

- `wl-clipboard` and `wl-clip-persist` for clipboard history
- `playerctl` for media keys
- `cava` on Arch (installed on Fedora)
- `postman`, Discord and Spotify keybinds are optional; edit or remove them
  if you do not use those applications.

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
2. Update the system and install the required packages.
3. Install fonts and rebuild the font cache.
4. Copy `.config/*` into `~/.config/` (**overwriting existing files**).
5. Copy Hyprland systemd user services into `~/.config/systemd/user/`.
6. Copy the bundled wallpapers into `~/Pictures/Wallpaper/`.
7. Optionally clone extra wallpaper collections and copy them into the same
   folder (existing files are not overwritten).
8. Install **Oh My Posh** and append its init line to `~/.bashrc`.
9. Enable `sddm`, `NetworkManager` and `power-profiles-daemon`.
10. Offer to reboot.

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
| System update | `pacman -Syu` |
| AUR helper | Installs `yay` from the AUR if missing |
| Official packages | Hyprland, portals, Hypridle/Hyprlock/Hyprshot, Waybar, Rofi, SwayNC, Kitty, SDDM, NetworkManager, fonts, utilities |
| AUR packages | `ttf-rubik`, `ttf-rubik-vf` |
| Verification | Checks important packages and commands, then font matching |
| Deployment | Configs, user services, wallpapers, Oh My Posh |
| Services | Enables `sddm`, `NetworkManager`, `power-profiles-daemon` |

### `installer-script/fedora-install.sh`

Fedora-specific installer, written for **Fedora 43**. Main steps:

| Step | Details |
| --- | --- |
| Checks | `/etc/fedora-release`, Fedora version (warns if not 43), 5 GB free |
| System update | `dnf upgrade` |
| Repositories | RPM Fusion Free/Nonfree and the `lionheartp/Hyprland` COPR |
| Packages | Hyprland stack, Waybar, Rofi, SwayNC, Kitty, SDDM, CAVA, fonts, utilities |
| Fonts | `jetbrains-mono-fonts`, `google-rubik-fonts`, font cache rebuild |
| Deployment | Configs, user services, wallpapers, Oh My Posh |
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
7. Makes shell scripts executable, updates user systemd services and reloads
   the user systemd manager.
8. Adds new bundled wallpapers **without overwriting** wallpapers you already
   have.
9. Reloads Hyprland, Waybar and SwayNC if they are running.

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
  wallpaper picker, Wi-Fi manager, Wi-Fi password prompt.

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
| `Super + Return` | Terminal (Kitty) |
| `Super + D` | Application launcher (Rofi) |
| `Super + E` | File manager |
| `Super + B` | Browser |
| `Super + C` | Code editor |
| `Super + Q` | Close window |
| `Super + M` | Toggle fullscreen |
| `Super + Space` | Toggle floating |
| `Super + V` | Clipboard history |
| `Super + W` | Wallpaper switcher |
| `Super + Ctrl + W` | Waybar theme switcher |
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
| Program commands | `.config/hypr/modules/programs.lua` |
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

Check the `.rasi` files under `.config/rofi/`. Make sure referenced colors and
fonts exist; Rofi fails silently or falls back when an `@import` is missing.

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
