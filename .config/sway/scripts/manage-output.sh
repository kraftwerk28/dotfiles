#!/bin/bash
focused=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')
case $1 in
	toggle_current)
		swaymsg output "$focused" toggle;;
	enable_all)
		swaymsg output "*" enable;;
	disable_all)
		swaymsg output "*" disable;;
esac
