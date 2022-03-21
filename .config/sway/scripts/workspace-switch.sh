#!/bin/bash
# Switch to N±1 workspace, where N is current workspace
cur=$(swaymsg -rt get_workspaces | jq -r '.[] | select(.focused).num')
case "$1" in
	prev)
		if (( cur <= 1 )); then exit 0; fi
		swaymsg "workspace $(( cur - 1 ))"
		;;
	next)
		swaymsg "workspace $(( cur + 1 ))"
		;;
	*)
		echo "Usage $0 prev|next" >&2
		exit 1
esac
