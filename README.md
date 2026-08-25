# My Custom Dotfiles

Minimal and customizable **Hyprland dotfiles** focused on a clean Wayland desktop experience, modular configuration, convenient scripts, and multiple themes.

> 🚧 **Status:** Work in progress.
> New features, improvements, themes, and configuration changes may be added over time.

---

## Features

* 🪟 **Hyprland** — Tiling Wayland compositor configuration
* 🧩 **Modular Hyprland configuration** using Lua modules
* 🎨 **Multiple themes** for Waybar, Rofi, CAVA, and SwayNC
* 🚀 **Automated installation** for Arch Linux and Fedora
* 🖥️ **Waybar** — Status bar and system information
* 🔔 **SwayNC** — Notification daemon and control center
* 🔎 **Rofi** — Application launcher and custom menus
* 🐱 **Kitty** — Terminal configuration
* 🎵 **CAVA** — Audio visualizer with custom shaders
* ⚡ **Fastfetch** — System information display
* 🔒 **Hyprlock** — Lock screen configuration
* 💤 **Hypridle** — Idle and power-management configuration
* 🖼️ **Wallpaper management**
* 📶 **Wi-Fi management scripts**
* 🎥 **Screen-recording script**
* 🔋 **Power menu**
* 🎨 **Theme switching**
* ⌨️ **Keybind helper**

---

## Requirements

This configuration is designed for a **Linux system running Wayland**.

### Supported distributions

The repository currently provides installation scripts for:

* Arch Linux
* Fedora Linux

The installer scripts are responsible for installing the required packages and setting up the configuration.

> The exact package requirements may change as the project develops.

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/genta-bahana-nagari/hyprland-rice.git
cd hyprland-rice
```

### 2. Run the installer

The main entry point is:

```bash
./install.sh
```

The installer can be used to set up the appropriate configuration for your system.

If the script is not executable, run:

```bash
chmod +x install.sh
```

Then:

```bash
./install.sh
```

### Distribution-specific installers

The repository also contains dedicated installation scripts:

```text
installer-script/
├── arch-install.sh
└── fedora-install.sh
```

#### Arch Linux

```bash
./installer-script/arch-install.sh
```

#### Fedora

```bash
./installer-script/fedora-install.sh
```

> **Note:** Review installation scripts before executing them, especially when installing on an existing system. Package names, dependencies, and commands may change as the project evolves.

---

# Repository Structure

```text
.
├── .config/
│   ├── cava/
│   ├── fastfetch/
│   ├── hypr/
│   ├── kitty/
│   ├── rofi/
│   ├── swaync/
│   └── waybar/
│
├── Wallpaper/
│   ├── wallpaper-0.jpg
│   └── wallpaper-1.jpg
│
├── installer-script/
│   ├── arch-install.sh
│   └── fedora-install.sh
│
├── install.sh
└── README.md
```

The `.config` directory mirrors the user's `~/.config` directory.

---

# Configuration

## Hyprland

The main Hyprland configuration is located at:

```text
.config/hypr/
├── modules/
├── scripts/
├── hypridle.conf
├── hyprland.lua
└── hyprlock.conf
```

The configuration is divided into modules to make it easier to maintain and customize.

### Hyprland modules

```text
modules/
├── animations.lua
├── autostart.lua
├── decoration.lua
├── environment.lua
├── input.lua
├── keybinds.lua
├── layout.lua
├── misc.lua
├── monitors.lua
├── permissions.lua
├── programs.lua
└── windowrules.lua
```

| Module            | Purpose                                         |
| ----------------- | ----------------------------------------------- |
| `animations.lua`  | Animation configuration                         |
| `autostart.lua`   | Applications and services started with Hyprland |
| `decoration.lua`  | Window decorations and visual effects           |
| `environment.lua` | Environment variables                           |
| `input.lua`       | Keyboard, mouse, and input settings             |
| `keybinds.lua`    | Keyboard shortcuts                              |
| `layout.lua`      | Window layout behavior                          |
| `misc.lua`        | Miscellaneous Hyprland settings                 |
| `monitors.lua`    | Monitor configuration                           |
| `permissions.lua` | Permission-related settings                     |
| `programs.lua`    | Program/application definitions                 |
| `windowrules.lua` | Window-specific rules                           |

The main configuration is:

```text
hyprland.lua
```

### Hypridle

```text
hypridle.conf
```

Contains idle-related configuration such as inactivity behavior and power-management actions.

### Hyprlock

```text
hyprlock.conf
```

Contains the lock-screen appearance and behavior.

---

# Hyprland Scripts

Scripts used by the Hyprland configuration are stored in:

```text
.config/hypr/scripts/
```

| Script                  | Purpose                                 |
| ----------------------- | --------------------------------------- |
| `keybinds.sh`           | Displays or manages keybind information |
| `power-menu.sh`         | Provides power-management actions       |
| `screen-record.sh`      | Starts screen recording                 |
| `show-current-theme.sh` | Displays the currently selected theme   |
| `wallpaper-switch.sh`   | Changes the wallpaper                   |
| `wifi-disconnect.sh`    | Disconnects from Wi-Fi                  |
| `wifi-mananger.sh`      | Provides Wi-Fi management functionality |

These scripts are intended to be used through Hyprland keybindings and/or other desktop components.

> `wifi-mananger.sh` is kept with its current filename for compatibility with the repository. Consider renaming it to `wifi-manager.sh` in a future cleanup if the filename is not referenced elsewhere.

---

# Waybar

Waybar configuration is located at:

```text
.config/waybar/
```

```text
waybar/
├── scripts/
├── themes/
├── config.jsonc
└── style.css
```

### Scripts

```text
scripts/
├── launch.sh
├── system-update.sh
└── theme-switcher.sh
```

These scripts provide functionality for launching Waybar, handling system updates, and switching themes.

### Themes

The repository currently includes:

```text
themes/
├── default/
│   ├── config.jsonc
│   └── style.css
│
├── nord/
│   ├── config.jsonc
│   └── style.css
│
└── retro/
    ├── config.jsonc
    └── style.css
```

Each theme contains its own Waybar configuration and stylesheet.

The default configuration is:

```text
config.jsonc
```

and the default styling is:

```text
style.css
```

---

# Rofi

Rofi is used for application launching and several custom desktop menus.

```text
.config/rofi/
├── colors/
├── shared/
├── styles/
└── launcher.sh
```

### Colors

```text
colors/
└── onedark.rasi
```

Contains the One Dark color configuration.

### Shared styles

```text
shared/
├── colors.rasi
└── fonts.rasi
```

Common colors and font definitions shared between Rofi interfaces.

### Rofi interfaces

```text
styles/
├── keybind-dictionary.rasi
├── launcher.rasi
├── powermenu-style.rasi
├── simple.rasi
├── theme-switcher.rasi
├── wallpaper-switch.rasi
├── wifimanager-style.rasi
└── wifipassword-style.rasi
```

These styles correspond to different interfaces such as:

* Application launcher
* Power menu
* Keybind dictionary
* Theme switcher
* Wallpaper selector
* Wi-Fi manager
* Wi-Fi password prompt

The launcher entry point is:

```text
launcher.sh
```

---

# SwayNC

SwayNC provides notifications and the desktop control center.

```text
.config/swaync/
├── colors/
├── icons/
├── themes/
├── config.json
└── style.css
```

### Icons

The `icons/` directory contains custom icons for desktop controls such as:

* Brightness
* Volume
* Microphone
* Music
* Gaming mode
* Timer
* Battery/power-related controls
* Theme and wallpaper controls

### Theme

The current SwayNC theme is:

```text
themes/
└── nova-dark/
    ├── central_control.css
    └── notifications.css
```

General SwayNC configuration is stored in:

```text
config.json
```

while the main stylesheet is:

```text
style.css
```

---

# CAVA

CAVA is configured in:

```text
.config/cava/
```

```text
cava/
├── shaders/
├── themes/
├── config
└── config.bak
```

### Shaders

The repository includes several custom GLSL shaders:

```text
shaders/
├── bar_spectrum.frag
├── eye_of_phi.frag
├── northern_lights.frag
├── pass_through.vert
├── spectrogram.frag
└── winamp_line_style_spectrum.frag
```

These shaders provide different visual styles for the audio visualizer.

### Themes

```text
themes/
├── solarized_dark
└── tricolor
```

CAVA's primary configuration is:

```text
config
```

with:

```text
config.bak
```

kept as a backup configuration.

---

# Kitty

Kitty configuration is located at:

```text
.config/kitty/
├── custom-theme.omp.json
└── kitty.conf
```

### `kitty.conf`

Contains the main Kitty terminal configuration.

### `custom-theme.omp.json`

Contains custom Oh My Posh configuration used for the terminal prompt.

---

# Fastfetch

Fastfetch configuration:

```text
.config/fastfetch/
├── config.jsonc
└── logo.txt
```

`config.jsonc` controls the Fastfetch output, while `logo.txt` contains the custom ASCII logo.

---

# Wallpapers

Wallpapers are stored in:

```text
Wallpaper/
├── wallpaper-0.jpg
└── wallpaper-1.jpg
```

The wallpaper switching functionality is handled by:

```text
.config/hypr/scripts/wallpaper-switch.sh
```

Additional wallpapers can be added to this directory and integrated into the wallpaper-selection workflow.

---

# Theme System

The dotfiles are designed around multiple themes.

Currently supported theme collections include:

### Waybar

* Default
* Retro

### CAVA

* Solarized Dark
* Tricolor

### SwayNC

* Nova Dark

### Rofi

* One Dark color scheme

Theme-related scripts include:

```text
.config/waybar/scripts/theme-switcher.sh
.config/hypr/scripts/show-current-theme.sh
```

The exact theme-switching behavior is controlled by the scripts and configuration files in the repository.

---

# Customization

The easiest way to customize the setup is to modify the relevant component rather than changing everything at once.

### Change keybindings

Edit:

```text
.config/hypr/modules/keybinds.lua
```

### Change monitors

Edit:

```text
.config/hypr/modules/monitors.lua
```

### Change window rules

Edit:

```text
.config/hypr/modules/windowrules.lua
```

### Change animations

Edit:

```text
.config/hypr/modules/animations.lua
```

### Change Waybar appearance

Edit:

```text
.config/waybar/style.css
```

or modify one of the theme directories:

```text
.config/waybar/themes/
```

### Change Rofi appearance

Modify the appropriate `.rasi` file inside:

```text
.config/rofi/
```

### Change SwayNC appearance

Modify:

```text
.config/swaync/style.css
```

or the relevant theme files inside:

```text
.config/swaync/themes/
```

### Change CAVA appearance

Modify:

```text
.config/cava/config
```

and/or the files inside:

```text
.config/cava/themes/
.config/cava/shaders/
```

---

# Applying Configuration Changes

After changing configuration files, some applications need to be restarted or reloaded.

For Hyprland configuration changes, use Hyprland's reload functionality or restart the relevant component.

For Waybar, SwayNC, Rofi, or other applications, restart the affected application when necessary.

> The exact reload command can vary depending on the component and how it is launched.

---

# Installation Architecture

The repository uses two levels of installation:

```text
install.sh
    │
    ├── Arch Linux
    │      └── installer-script/arch-install.sh
    │
    └── Fedora
           └── installer-script/fedora-install.sh
```

The distribution-specific scripts handle OS-specific package installation and setup, while the repository itself contains the desktop configuration.

This separation makes it easier to maintain support for multiple distributions.

---

# Important Notes

## Existing configurations

If you already have files under:

```text
~/.config/
```

be careful when installing these dotfiles.

Existing configurations may be overwritten, replaced, or modified depending on how the installer is implemented.

**Back up your existing configuration before installation.**

For example:

```bash
cp -r ~/.config ~/.config.backup
```

You should also back up any important Hyprland, Waybar, Kitty, Rofi, or SwayNC configuration you already have.

## Hardware-specific configuration

Some settings are inherently machine-specific, particularly:

* Monitor configuration
* Input devices
* Graphics-related settings
* Audio devices
* Network configuration
* Environment variables

The configuration may therefore require adjustment after installation.

The most likely place to start is:

```text
.config/hypr/modules/monitors.lua
```

and:

```text
.config/hypr/modules/input.lua
```

---

# Troubleshooting

### Hyprland does not start

Check:

```text
.config/hypr/hyprland.lua
.config/hypr/modules/
```

Look for configuration errors, especially after modifying Lua files.

### Waybar does not appear

Check:

```text
.config/waybar/config.jsonc
.config/waybar/style.css
```

and make sure Waybar is being launched by the Hyprland configuration or the appropriate startup script.

### Rofi menu looks incorrect

Check the relevant `.rasi` files under:

```text
.config/rofi/
```

Make sure referenced colors, fonts, and styles exist.

### SwayNC styling is broken

Check:

```text
.config/swaync/style.css
.config/swaync/config.json
```

and the selected theme under:

```text
.config/swaync/themes/
```

### Wallpaper does not change

Check:

```text
Wallpaper/
.config/hypr/scripts/wallpaper-switch.sh
```

Make sure the wallpaper files exist and that the script has executable permissions.

### A script cannot be executed

Make sure scripts have executable permissions:

```bash
chmod +x .config/hypr/scripts/*.sh
chmod +x .config/waybar/scripts/*.sh
chmod +x .config/rofi/launcher.sh
```

The installation process may already handle these permissions.

---

# Project Philosophy

These dotfiles are intended to be:

* **Minimal** — Avoid unnecessary configuration and visual clutter.
* **Modular** — Keep related settings separated into manageable files.
* **Customizable** — Make themes, keybindings, and behavior easy to modify.
* **Practical** — Provide useful scripts for everyday desktop tasks.
* **Maintainable** — Keep distribution-specific installation logic separate from desktop configuration.

---

# Contributing

Contributions, improvements, bug fixes, themes, and suggestions are welcome.

Before submitting changes:

1. Test the relevant configuration.
2. Make sure scripts still work.
3. Avoid breaking existing themes.
4. Keep the configuration modular.
5. Document significant changes.

---

# Disclaimer

These dotfiles are provided for personal use and experimentation.

They may not work perfectly on every machine or hardware configuration. Review the installation scripts and configuration before applying them to an existing system.

Always keep a backup of your current configuration.

---

# License

No license has currently been specified for this project.

If you intend to allow others to reuse, modify, or redistribute the dotfiles, consider adding an appropriate open-source license.

---

## Status

**Work in progress 🚧**

This project is actively being developed. Configuration structure, scripts, themes, and supported distributions may change over time.
