#!/bin/bash
raw=$(swaymsg -t get_tree)

readarray -t ids < <(jq -r \
' recurse(.nodes[]?, .floating_nodes[]?)
| select(has("app_id")).id
' <<< "$raw")
titles=$(jq -r \
' recurse(.nodes[]?)
| select(.type? == "workspace")
| .name as $wname
| recurse(.nodes[], .floating_nodes[])
| select(has("app_id"))
| "[\($wname)] - \(.name)"' <<< "$raw")
index=$(rofi -i -dmenu -p "Select window" -format i <<< "$titles")
if [[ -n $index && $index -ne -1 ]]; then
	swaymsg "[con_id=${ids[$index]}] focus"
fi
