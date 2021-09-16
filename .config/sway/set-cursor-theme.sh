#!/usr/bin/env bash
cursor_theme=$(awk -F= '/Inherits/{print $2}' ~/.icons/default/index.theme)
cursor_theme=${cursor_theme:-Adwaita}
swaymsg seat seat0 xcursor_theme $cursor_theme
gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme
