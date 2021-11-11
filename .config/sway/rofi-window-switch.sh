#!/bin/bash
raw=$(swaymsg -t get_tree)

readarray -t ids < <(jq -r '.. | objects | select(has("app_id")).id' <<< "$raw")

titles=$(jq -r ' ..
| select(.type? == "workspace")
| .name as $wname
| ..
| objects
| select(has("app_id"))
| "[\($wname)] - \(.name)"' <<< "$raw")

index=$(rofi -i -dmenu -p "Select window" -format i <<< "$titles")

if [[ -n $index ]]; then
	swaymsg "[con_id=${ids[$index]}]" focus
fi
