#!/bin/bash
set -e

wp_dir="${XDG_STATE_HOME:-$HOME/.local/state}/wallpapers"
# prev_wp="$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/wallpapers/.current")"
new_wp=$(find "$wp_dir" -type f | shuf -n 1)

echo "Setting $new_wp as wallpaper image"
while ! find "/run/user/${UID}" -maxdepth 1 -type s -name "sway-ipc.${UID}.*.sock" | grep -q .; do
	echo "Waiting for sway socket to appear..."
	sleep 1
done
swaymsg "output * background $new_wp fill"
