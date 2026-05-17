#!/usr/bin/env bash
set -euo pipefail

# Theme target used when reloading GTK after m3wal deploy.
GTK_THEME_TARGET="${GTK_THEME_TARGET:-FlatColor-dark}"

run_if_cmd() {
  local cmd="$1"
  shift
  if command -v "$cmd" >/dev/null 2>&1; then
    "$@"
  fi
}

mkdir -p "$HOME/.config/gtk-3.0/gtk-3.20" "$HOME/.config/gtk-4.0" "$HOME/.config/m3-colors"

if command -v xrdb >/dev/null 2>&1 && [ -f "$HOME/.Xresources" ]; then
  xrdb -merge "$HOME/.Xresources" || true
fi

if [ -x "$HOME/.config/polybar/launch.sh" ]; then
  "$HOME/.config/polybar/launch.sh" >/dev/null 2>&1 || true
fi

if command -v dunst >/dev/null 2>&1; then
  if pgrep -x dunst >/dev/null 2>&1; then
    pkill -x dunst || true
    sleep 0.2
  fi
  nohup dunst >/dev/null 2>&1 &
fi

if pgrep -x kitty >/dev/null 2>&1; then
  pkill -USR1 kitty || true
fi

mkdir -p "$HOME/.config/xsettingsd"
cat > "$HOME/.config/xsettingsd/xsettingsd.conf" <<EOF
Net/ThemeName "${GTK_THEME_TARGET}"
Net/IconThemeName "Yaru-dark"
Gtk/CursorThemeName "Yaru-dark"
EOF

# Keep xsettingsd config in sync with active theme target.
if command -v xsettingsd >/dev/null 2>&1; then
  pkill xsettingsd >/dev/null 2>&1 || true
  nohup xsettingsd >/dev/null 2>&1 &
fi

gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_TARGET" >/dev/null 2>&1 || true

# Keep GTK config files in sync so tools like neofetch report the active theme.
if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
  sed -i "s/^gtk-theme-name=.*/gtk-theme-name=${GTK_THEME_TARGET}/" "$HOME/.config/gtk-3.0/settings.ini" || true
fi

if [ -f "$HOME/.gtkrc-2.0" ]; then
  sed -i "s/^gtk-theme-name=.*/gtk-theme-name=\"${GTK_THEME_TARGET}\"/" "$HOME/.gtkrc-2.0" || true
fi

# Force GTK theme reload in GNOME sessions by toggling away and back.
if command -v gsettings >/dev/null 2>&1; then
  current_theme="$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'" || true)"
  if [ "$current_theme" = "$GTK_THEME_TARGET" ]; then
    fallback_theme="Yaru-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "$fallback_theme" >/dev/null 2>&1 || true
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_TARGET" >/dev/null 2>&1 || true
  else
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_TARGET" >/dev/null 2>&1 || true
  fi
fi

run_if_cmd i3-msg i3-msg reload >/dev/null 2>&1 || true

run_if_cmd notify-send notify-send "m3wal" "Theme reapplied (polybar/dunst/xrdb/i3/gtk reload)."
