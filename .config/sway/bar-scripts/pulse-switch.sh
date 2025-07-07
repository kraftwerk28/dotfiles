#!/bin/bash
set -e

kind=$1
if [[ $kind != sink && $kind != source ]]; then
	echo "Specify either sink or souce" >&2
	exit 1
fi

next_sink="$(pactl -f json list short "${kind}s" \
	| jq -e -r '
		last(to_entries[] | select(.value.state == "RUNNING")).key as $active_idx
		| ($active_idx + 1) % length as $next_idx
		| .[$next_idx].name
	')"
pactl "set-default-${kind}" "$next_sink"
