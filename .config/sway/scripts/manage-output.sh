#!/bin/bash
# NOTE: deprecated, replaced with native commands
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
