#!/bin/bash

read -r wx wy ww wh < <(swaymsg -rt get_tree | jq -r '
recurse(.nodes[], .floating_nodes[])
| select(.floating_nodes | length > 0).floating_nodes[]
| select(.focused).rect
| "\(.x) \(.y) \(.width) \(.height)"')

read -r wsx wsy wsw wsh < <(swaymsg -rt get_workspaces | jq -r '
map(select(.focused))[0].rect
| "\(.x) \(.y) \(.width) \(.height)"')

if [[ -z $wx ]]; then
	echo "Focused window is not floating"
	exit 1
fi

(( x = wx - wsx ))
(( y = wy - wsy ))

while (($#)); do
	case $1 in
		left) (( x = 0 ));;
		top) (( y = 0 ));;
		right) (( x = wsw - ww ));;
		bottom) (( y = wsh - wh ));;
		*) echo "Unrecognized direction" >&2; exit 1;;
	esac
	shift
done

swaymsg "move position $x $y"
