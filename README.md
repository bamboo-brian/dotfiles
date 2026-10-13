# Dotfiles

Personal dotfiles managed with GNU Stow. Run `./install.sh` to install the
package-manifest dependencies and apply the configuration. Shell, editor, and
terminal configuration lives in the always-installed `home` package.

## AeroSpace on macOS

The separate `aerospace` package provides Command-based window navigation and
Command+Option workspace navigation. `install.sh` applies it only on macOS
when the `aerospace` CLI is on `PATH`. Linux skips it.

Install AeroSpace and apply just its configuration on your Mac:

```sh
brew install --cask nikitabobko/tap/aerospace
bash scripts/install-aerospace.sh
```

Start AeroSpace and grant its requested Accessibility permission, then run
`aerospace reload-config`. The config enables startup at login. It uses the
current configuration version 2; see the [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide).

| Shortcut | Action |
| --- | --- |
| Command+H/J/K/L | Focus left/down/up/right across monitors |
| Command+Shift+H/J/K/L | Move the window left/down/up/right |
| Command+Control+H/J/K/L | Join the window with its neighbor left/down/up/right |
| Command+Control+Option+H/L | Move the entire workspace to the previous/next monitor and follow |
| Command+Option+H/L | Previous/next workspace on the focused monitor |
| Command+Option+1–9 / 0 | Focus workspace 1–9 / 10 |
| Command+Option+Shift+H/L | Move to previous/next workspace and follow |
| Command+Option+Shift+1–9 / 0 | Move to workspace 1–9 / 10 without following |

Empty workspaces disappear when no longer visible; all ten number shortcuts
recreate their workspaces on demand. Physical key positions
use QWERTY notation, including number-row keys on AZERTY keyboards. Workspaces
are AeroSpace workspaces, separate from native macOS Spaces. Monitor assignment
is automatic; the config contains no machine-specific monitor names.

Directional focus crosses monitor boundaries and stops at the outer screen
edges. The pointer follows focus into the new window, staying put if already
inside it. Empty workspaces use the monitor center as a fallback.

These global bindings replace the corresponding app shortcuts while AeroSpace
is active, including Hide Application, Hide Others, and Command+L for an address
bar. Copy, Paste, Save, Undo, Spotlight, and Command+Tab remain available.

Edit [aerospace/.aerospace.toml](aerospace/.aerospace.toml) in this repository.
The installer links it to `~/.aerospace.toml` and moves conflicting configs to
`~/.aerospace.backup.XXXXXX`. It also backs up an existing config in
`${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml`, since AeroSpace
rejects configurations in both locations. Repeat installs preserve the link
without creating another backup. To restore, unstow the `aerospace` package and
move the saved file back to its original location.

Run `python3 scripts/test-aerospace.py` for isolated installer checks and TOML
validation. Full AeroSpace validation requires a Mac running AeroSpace.

## Hyprland

The separate `hyprland` package shares Lua keybinds, gestures, appearance, layout
preferences, and generic window rules. `install.sh` applies it only on Linux
when `Hyprland` is on `PATH`; it skips macOS and machines without Hyprland.
It does not install Hyprland, Noctalia, UWSM, or applications.

To apply just this configuration without installing other packages:

```sh
bash scripts/install-hyprland.sh
```

The installer honors `XDG_CONFIG_HOME` (default: `~/.config`). It creates
individual Stow links and leaves the `hypr` directory writable for local files.
Plain `stow --target="$HOME" home` does not install Hyprland settings.
Use a Lua-capable Hyprland version; these files target the 0.56 Lua API.

### Machine-local files

The entrypoint loads defaults, `local-options.lua`, shared modules, and finally
`local-settings.lua`. Create these files inside your local Hyprland directory;
they are optional and are never linked into the repository or replaced by the
installer. Invalid local Lua produces a configuration error.

Example `~/.config/hypr/local-options.lua` for a machine without UWSM or Noctalia:

```lua
return {
    modifier = "SUPER",
    workspace_count = 3, -- integer from 1 to 10
    monitors = { "eDP-1" }, -- ordered list for Super+1, Super+2, etc.
    commands = {
        terminal = "ghostty",
        file_manager = "thunar",
        launcher = "wofi --show drun",
        lock = "hyprlock",
        screenshot_region = "hyprshot -m region",
        volume_up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
        volume_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
        volume_mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    },
}
```

Defaults are Super, three workspaces, no named monitors, and no app commands.
Commands are complete shell commands: include `uwsm app -- ` here when needed.
Unset, false, or empty commands omit their shortcuts. Available command keys
and their shortcuts are defined in [shared/binds.lua](hyprland/.config/hypr/shared/binds.lua):

| Commands | Default shortcuts |
| --- | --- |
| `terminal`, `file_manager`, `editor`, `calculator` | Super+Return, E, T, C; XF86Calculator |
| `system_monitor`, `window_switcher` | Ctrl+Shift+Escape; Super+Tab |
| `settings`, `control_center`, `launcher`, `emoji` | Super+Z, X, Space, Period |
| `lock`, `session` | Super+Ctrl+L; Super+Alt+C |
| `volume_up`, `volume_down`, `volume_mute`, `mic_mute` | Corresponding XF86 audio keys |
| `media_toggle`, `media_next`, `media_previous` | XF86 Play/Pause, Next, Previous |
| `brightness_up`, `brightness_down` | Corresponding XF86 brightness keys |
| `color_picker`, `screenshot_region`, `screenshot_fullscreen` | Super+Shift+P, Super+P, Super+Print |
| `wallpaper`, `clipboard`, `notifications` | Super+Shift+W, Super+V, Super+A |
| `monitor_toggle` | Ctrl+Alt+F |

Number-row bindings use physical keycodes so they work with your AZERTY layout.
Super+number focuses configured monitors and Super+Shift+number moves windows
to them. Workspace navigation retains the existing Alt/Control combinations.
Without named monitors, relative monitor controls still work.

Use `local-settings.lua` for monitor positions, workspace assignments, startup
programs, environment, VRR, direct scanout, scaling, and application-specific
rules. The shared fallback chooses preferred monitor modes and automatic
position/scale. Explicit local monitor rules override that fallback.

```lua
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = "1" })

-- Remove a shared shortcut before replacing it.
hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.window.close())
```

### Backups and verification

When managed files conflict, the installer snapshots the complete existing
directory into `$XDG_CONFIG_HOME/hypr.backup.XXXXXX/original` before moving the
conflicting files aside. Unrelated files and local hooks stay in place.
Repeating installation with the correct links creates no new backup.
It refuses to write through a symlinked `hypr` directory.

For an existing distro configuration, move its hardware and session settings
into local hooks before installing. The installer backs up an existing
entrypoint but does not automatically convert arbitrary distro configurations.

Verify before explicitly reloading:

```sh
Hyprland --verify-config -c "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.lua"
hyprctl reload
```

Hyprland may also automatically reload watched files when they change.
To restore a backup, move the current `hypr` directory aside and copy the
backup's entire `original` directory back as `hypr`, then verify it.

Run isolated installer and configuration checks with:

```sh
python3 scripts/test-hyprland.py
```

The checks require GNU Stow; Lua and Hyprland checks run when those executables
are available. Temporary homes cover platform gating, repeat installs,
backups, custom config paths, optional commands, and local binding overrides.
