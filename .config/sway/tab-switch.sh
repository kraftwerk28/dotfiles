#!/bin/bash
if [[ -z $1 ]]; then
	exit 1
fi

IFS=$'\n' read -r -d '' tab_con focused total < \
	<(swaymsg -t get_tree | jq -r '
	last(
		recurse(.nodes[]?)
		| select(
			.layout == "tabbed" and (recurse(.nodes[]?)
			| select(.focused))
		)
	) as $tc
	| ($tc
		| .nodes
		| map(recurse(.nodes[]?).focused // false)
		| index(true)) as $fc
	| ($tc | .nodes | length) as $cnt
	| "\($tc)\n\($fc)\n\($cnt)"')

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
