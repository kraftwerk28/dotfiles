#!/bin/bash
#
# TODO: complete the script
parent=$(swaymsg -t get_tree | jq -r '
	recurse(.nodes[]?, .floating_nodes[]?) | select((.nodes[]?, .floating_nodes[]?) | .focused)
')
echo "$parent"
jq -r '"\(.orientation) \((.nodes // .floating_nodes) | length) \(.rect.width) \(.rect.height)"' <<< "$parent"
exit 0

echo "$layout $nchildren $parent_w $parent_h"
exit 0
if [[ $layout = vertical ]]; then
	(( ppt = 100 / nchildren ))
	(( desired = parent_h / nchildren ))
	for con_id in $(jq -r '.nodes[].id' <<< "$parent"); do
		cmd="[con_id=${con_id}] resize set height ${ppt} ppt"
		echo $cmd
		swaymsg $cmd
	done
elif [[ $layout = horizontal ]]; then
	(( desired = parent_w / nchildren ))
	for con_id in $(jq -r '.nodes[].id' <<< "$parent"); do
		swaymsg "[con_id=$con_id] resize set width $desired px"
	done
fi
