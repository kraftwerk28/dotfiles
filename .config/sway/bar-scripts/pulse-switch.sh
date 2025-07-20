#!/bin/bash
set -e

kind=$1
if [[ $kind != "sink" && $kind != "source" ]]; then
	echo "Specify either sink or source" >&2
	exit 1
fi

current=$(pactl "get-default-${kind}")
next="$(pactl -f json list short "${kind}s" \
	| jq -r --arg current "$current" '
		last(to_entries[] | select(.value.name == $current)).key as $active_idx
		| ($active_idx + 1) % length as $next_idx
		| .[$next_idx].name
	')"
echo "$current -> $next"
pactl "set-default-${kind}" "$next"
