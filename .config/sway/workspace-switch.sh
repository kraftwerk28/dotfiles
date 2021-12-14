#!/bin/bash
# Switch to N±1 workspace, where N is current workspace
if [[ -z "$1" ]]; then
	exit 1
fi
cur=$(swaymsg -rt get_workspaces | jq -r '.[] | select(.focused == true).num')
if [[ $cur -le 1 ]] && [[ $1 = "prev" ]]; then
	exit 0
fi
if [[ $1 = "next" ]]; then
	((cur++))
elif [[ $1 = "prev" ]]; then
	((cur--))
fi
swaymsg "workspace ${cur}"
