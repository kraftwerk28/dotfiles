#!/bin/bash
# shellcheck disable=2154

eval "$(swaymsg -t get_tree | jq -r \
	' (
		recurse(.nodes[])
		| select(.type == "workspace")
		| select(recurse(.nodes[], .floating_nodes[]).focused).rect
		| "wsx=\(.x); wsy=\(.y); wsw=\(.width); wsh=\(.height); "
	) + (
		recurse(.nodes[]) | select(.floating_nodes | length > 0)
		| .floating_nodes[]
		| select(.focused)
		| "wx=\(.rect.x); wy=\(.rect.y); ww=\(.rect.width); wh=\(.rect.height)"
	)')"

# eval "$(swaymsg -rt get_tree | jq -r \
# 	' recurse(.nodes[], .floating_nodes[])
# 	| select(.floating_nodes | length > 0).floating_nodes[]
# 	| select(.focused)
# 	| "wx=\(.rect.x); wy=\(.rect.y); ww=\(.rect.width); wh=\(.rect.height+.deco_rect.height)"')"

# eval "$(swaymsg -rt get_workspaces | jq -r \
# 	' map(select(.focused))[0].rect
# 	| "wsx=\(.x); wsy=\(.y); wsw=\(.width); wsh=\(.height)"')"

if [[ -z $wx ]]; then
	echo "Focused window is not floating"
	exit 1
fi

(( x = wx - wsx ))
(( y = wy - wsy ))

while (( $# > 0 )); do
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
