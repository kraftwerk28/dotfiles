#!/bin/bash

SINK="@DEFAULT_SINK@"
SOURCE="@DEFAULT_SOURCE@"
LIMIT=150
STEP=5

report () {
	local v=$(( $1 > 100 ? 100 : $1 ))
	notify-send \
		-h "string:x-canonical-private-synchronous:volume" \
		-h "int:value:${v}" \
		-t 2000 \
		"墳 ${1}%"
}

case "$1" in
	toggle-mic) pactl set-source-mute $SOURCE toggle;;
	toggle) pactl set-sink-mute $SINK toggle;;
	unmute-down) pactl set-source-mute $SOURCE 0;;
	unmute-up) pactl set-source-mute $SOURCE 1;;
	*)
		read -r l r \
			< <(pactl get-sink-volume $SINK \
			| grep -oP "[0-9]+(?=%)" \
			| xargs echo)
		if [[ $1 == up ]]; then
			(( l += (l % STEP) ? (STEP - l % STEP) : STEP ))
			(( r += (r % STEP) ? (STEP - r % STEP) : STEP ))
		elif [[ $1 == down ]]; then
			(( l -= (l % STEP) ? (l % STEP) : STEP ))
			(( r -= (r % STEP) ? (r % STEP) : STEP ))
		fi
		(( l > LIMIT )) && (( l = LIMIT ))
		(( r > LIMIT )) && (( r = LIMIT ))
		report "$(( (l + r) / 2 ))"
		pactl set-sink-volume $SINK "$l%" "$r%"
		;;
esac
