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
	up|down)
		read -r l r \
			< <(pactl get-sink-volume $SINK \
			| grep -oP "[0-9]+(?=%)" \
			| xargs echo)
		case $1 in
			up)
				(( l += (l % STEP) ? (STEP - l % STEP) : STEP ))
				(( r += (r % STEP) ? (STEP - r % STEP) : STEP ))
				;;
			down)
				(( l -= (l % STEP) ? (l % STEP) : STEP ))
				(( r -= (r % STEP) ? (r % STEP) : STEP ))
				;;
		esac
		(( l = l > LIMIT ? LIMIT : l ))
		(( r = r > LIMIT ? LIMIT : r ))
		report "$(( (l + r) / 2 ))"
		pactl set-sink-volume $SINK "$l%" "$r%"
		;;
esac
