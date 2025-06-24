#!/bin/bash
set -e

wp_dir="${XDG_STATE_HOME:-$HOME/.local/state}/wallpapers"
current_wp=$(find "$wp_dir" -type f | shuf -n 1)
echo "Setting $current_wp as wallpaper image"
swaymsg "output * background $current_wp fill"
