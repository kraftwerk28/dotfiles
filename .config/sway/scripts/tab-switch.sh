#!/bin/bash
# NOTE: This is now replaced with enhance.lua script

if [[ -z $1 ]]; then
	exit 1
fi

IFS=$'\n' read -r -d '' tab_con focused total < \
	<(swaymsg -t get_tree | jq -r '
	first(
		recurse(.nodes[]?)
		| select(
			.layout == "tabbed"
			and (recurse(.nodes[]?) | select(.focused))
		)
	) as $tc
	| ($tc
		| .nodes
		| map(recurse(.nodes[]?).focused // false)
		| index(true)) as $fc
	| ($tc | .nodes | length) as $cnt
	| "\($tc)\n\($fc)\n\($cnt)"')

(( total == 0 )) && exit 0

focus () {
	local con_id=$(jq '
	.nodes['"$1"']
	| last(recurse(.focus[0] as $f | .nodes[] | select(.id == $f)).id)
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
