#!/bin/bash
if [[ -z $1 ]]; then
	exit 1
fi

tab_con=$(swaymsg -t get_tree | jq -r '
last(
	recurse(.nodes[]?)
	| select(.layout == "tabbed" and (recurse(.nodes[]?) | select(.focused)))
)
')
focused=$(jq -r '
.nodes
| map(recurse(.nodes[]?).focused // false)
| index(true)
' <<< "$tab_con")
total=$(jq -r '.nodes | length' <<< "$tab_con")

focus () {
	local con_id=$(jq '
		.nodes['$1'] | first(recurse(.nodes[]?) | select(has("app_id"))).id
	' <<< "$tab_con")
	swaymsg "[con_id=${con_id}] focus"
}

if [[ $1 == next ]]; then
	(( focused = (focused + 1) % total ))
	focus "$focused"
elif [[ $1 == prev ]]; then
	(( focused = (focused == 0) ? total - 1 : focused - 1 ))
	focus "$focused"
else
	if (( $1 < 1 || $1 > total )); then
		exit 1
	fi
	focus "$(( $1 - 1 ))"
fi
