# i3 Dotfiles

This repository stores your i3 setup in a flat layout (not inside a `.config/` subfolder).

## Current layout

Config directories copied to `~/.config/`:

- `i3/`
- `polybar/`
- `picom/`
- `dunst/`
- `kitty/`
- `scripts/`

Shell files copied to `~/`:

- `.zshrc`

Optional fonts copied to `~/.local/share/fonts/`:

- `fonts/`

## Theme, font, and icon dependencies

From your current configs:

- **Fonts**
  - `JetBrainsMono Nerd Font` (used in Polybar + Dunst)
  - `FontAwesome` (used in Polybar)
  - `monospace` (i3 title font fallback)
- **GTK theme**
  - `Yaru` / `Yaru-dark`
- **Icon theme**
  - `Yaru`
- **Cursor/Icon fallback**
  - `Adwaita` (cursor + Dunst icon theme)
- **Kitty theme include**
  - `~/.config/kitty/kitty-themes/themes/Thayer_Bright.conf` (included under `kitty/kitty-themes/`)

## How to find/check fonts on Linux

Use these commands:

```bash
fc-list | grep -Ei "JetBrains|Nerd|Font Awesome|fontawesome"
fc-match "JetBrainsMono Nerd Font"
fc-match "FontAwesome"
fc-match monospace
```

Interpretation:

- If `fc-match` returns a file/family, that font (or fallback) is available.
- On this machine, `FontAwesome` resolves to `FontAwesome.otf` and `monospace` resolves to `DejaVu Sans Mono`.

## Runtime packages/binaries you should have

Core WM stack:

- `i3` (or `i3-gaps`)
- `polybar`
- `picom`
- `dunst`
- `kitty`
- `feh`

Commands/scripts referenced by the setup:

- `dex`
- `xss-lock`
- `i3lock`
- `nm-applet`
- `pactl`
- `dmenu_run` (from `dmenu`)
- `brightnessctl`
- `playerctl`
- `gnome-screenshot`
- `xclip`
- `xrandr`
- `jq`
- `wmctrl`
- `notify-send` (usually from `libnotify-bin`)
- `google-chrome` / `google-chrome-stable`
- `discord`
- `whatsapp-linux-desktop`
- `code` (VS Code)

## Important machine-specific items

- Wallpaper path in i3 config is hardcoded to:
  - `~/Pictures/wallpapers/sunset.jpg`
  - Make sure this file exists or edit `.config/i3/config`.
- One binding points to a placeholder path:
  - `bindsym XF86TouchpadToggle exec /some/path/toggletouchpad.sh`
  - Replace with a real script path or remove.
- `i3/i3blocks.conf` references scripts under `~/.config/i3/scripts/*`.
  - Those scripts are **not** present in this source config.
  - Your active bar is Polybar (`~/.config/polybar/launch.sh`), so this only matters if you switch to i3blocks.

## What is currently missing from this repo

Compared to your live machine setup, these important files exist but are not yet in this repo root:

- `gtk-2.0/`, `gtk-3.0/`, `gtk-4.0/`
- `mimeapps.list`, `xdg-terminals.list`, `GNOME-xdg-terminals.list`, `ubuntu-xdg-terminals.list`
- `.zshenv`, `.p10k.zsh`, `.zshrc.pre-oh-my-zsh`, `.shell.pre-oh-my-zsh`, `.oh-my-zsh/`

The installer handles missing files safely and reports skipped items.

## Install on another machine

Run from this `dotfiles` directory:

```bash
./install.sh
```

What `install.sh` does:

- Backs up existing target files/directories to `~/.dotfiles-backup/<timestamp>/`
- Installs available config folders into `~/.config/`
- Installs available shell files into `~/`
- Installs `fonts/*.{ttf,otf}` into `~/.local/share/fonts/` and refreshes font cache

Then restart i3:

```bash
i3-msg reload
i3-msg restart
```

If the bar or compositor does not start, test manually:

```bash
~/.config/polybar/launch.sh
picom --experimental-backends -b --config ~/.config/picom/picom.conf
```
