#!/bin/bash
dx=10
dy=10
tree=$(swaymsg -t get_tree)
cur_window=$(jq -r 'recurse(.nodes[]?, .floating_nodes[]?) | select(.focused)' <<<"$tree")
if [[ $(jq -r '.type' <<<"$cur_window") != "floating_con" ]]; then
	echo "Script must be executed inside a floating window" 1>&2
	exit 1
fi
cur_ws=$(jq -r 'recurse(.nodes[]?) | select(.type == "workspace" and (recurse(.nodes[]?, .floating_nodes[]?) | select(.focused)))' <<<"$tree")
read -r wsx wsy wsw wsh < <(jq -r '.rect | "\(.x) \(.y) \(.width) \(.height)"' <<<"$cur_ws")
read -r con_id x y w h < <(jq -r '.id as $id | .rect | "\($id) \(.x) \(.y) \(.width) \(.height)"' <<<"$cur_window")
while sleep 0.05; do
	(( (x < wsx || x+w > wsx+wsw) && (dx *= -1), (y < wsy || y+h > wsy+wsh) && (dy *= -1), x += dx, y += dy ))
	swaymsg "[con_id=${con_id}] move position ${x} ${y}"
done
