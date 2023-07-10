#!/bin/bash
# focused=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')
# echo "[$(date)] cmd=$1 focused=$focused" >> ~/manage-output.log
case $1 in
	toggle_current)
		focused=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')
		swaymsg "output $focused toggle";;
	enable_all)
		swaymsg "output * enable";;
	disable_all)
		swaymsg "output * disable";;
	*)
		echo "Unknown action '$1'" >&2
		exit 1;;
esac
