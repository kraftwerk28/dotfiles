#!/usr/bin/env bash
cur=$(swaymsg -rt get_workspaces | jq -r '.[] | select(.focused==true) | .num')
if [[ $cur -le 1 ]] && [[ $1 = "prev" ]]; then
	exit 0
fi
if [[ $1 = "next" ]]; then
	((cur++))
elif [[ $1 = "prev" ]]; then
	((cur--))
fi
swaymsg workspace $cur
