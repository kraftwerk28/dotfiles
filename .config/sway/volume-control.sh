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

adjust () {
	if [[ "$1" = "up" ]]; then
		(( l += (l % STEP) ? (STEP - l % STEP) : STEP ))
		(( r += (r % STEP) ? (STEP - r % STEP) : STEP ))
	elif [[ "$1" = "down" ]]; then
		(( l -= (l % STEP) ? (l % STEP) : STEP ))
		(( r -= (r % STEP) ? (r % STEP) : STEP ))
	fi
	(( l > LIMIT )) && (( l = LIMIT ))
	(( r > LIMIT )) && (( r = LIMIT ))
}

if [[ $1 == "toggle-mic" ]]; then
	pactl set-source-mute $SOURCE toggle
	exit 0
fi

if [[ $1 == "toggle" ]]; then
	pactl set-sink-mute $SINK toggle
	exit 0
fi

if [[ $1 == "unmute-down" ]]; then
	pactl set-source-mute $SOURCE 0
	exit 0
fi

if [[ $1 == "unmute-up" ]]; then
	pactl set-source-mute $SOURCE 1
	exit 0
fi

read -r l r \
	< <(pactl get-sink-volume $SINK | grep -oP "[0-9]+(?=%)" | xargs echo)
adjust "$1"
report "$(( (l + r) / 2 ))"
pactl set-sink-volume $SINK "$l%" "$r%"
