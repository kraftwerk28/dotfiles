raw=$(swaymsg -t get_tree)

IFS=$'\n' ids=($(jq -r '
..
| objects
| select(has("app_id")).id' <<< $raw))

index=$(echo $raw | jq -r '
..
| select(.type? == "workspace")
| .name as $wname
| ..
| objects
| select(has("app_id"))
| "[\($wname)] - \(.name)"' | rofi -dmenu -format i)

if [[ -n $index ]]; then
	swaymsg "[con_id=${ids[$index]}]" focus
fi
