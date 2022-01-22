#!/bin/bash
raw=$(swaymsg -t get_tree)
index=$(jq -r \
	' recurse(.nodes[]?)
	| select(.type? == "workspace")
	| .name as $wname
	| recurse(.nodes[], .floating_nodes[])
	| select(has("app_id"))
	| "[\($wname)] - \(.name)"' <<<"$raw" \
	| rofi -i -dmenu -p "Choose window" -format i)
if [[ -n $index && $index -ne -1 ]]; then
	readarray -t ids < <(jq -r \
	' recurse(.nodes[]?, .floating_nodes[]?)
	| select(has("app_id")).id' <<<"$raw")
	swaymsg "[con_id=${ids[$index]}] focus"
fi
