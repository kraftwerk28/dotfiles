#!/bin/bash
source "$(dirname "$0")/lib.sh"
SINK="@DEFAULT_SINK@"
SOURCE="@DEFAULT_SOURCE@"
MAX_VOL=150

report () {
	local v=$(( $1 > 100 ? 100 : $1 ))
	case $2 in
		yes) icon="";;
		no) icon="墳";;
	esac
	notify-send \
		-h "string:x-canonical-private-synchronous:volume" \
		-h "int:value:${v}" \
		-t 2000 \
		"${icon} ${1}%"
}

case $1 in
	toggle-mic) pactl set-source-mute $SOURCE toggle;;
	toggle)
		pactl set-sink-mute $SINK toggle
		read -r l r \
			< <(pactl get-sink-volume $SINK \
			| grep -oP "[0-9]+(?=%)" \
			| xargs echo)
		muted="$(pactl get-sink-mute $SINK | grep -oP "yes|no$")"
		report "$(( (l + r) / 2 ))" "$muted"
		;;
	unmute-down) pactl set-source-mute $SOURCE 0;;
	unmute-up) pactl set-source-mute $SOURCE 1;;
	up|down)
		read -r l r \
			< <(pactl get-sink-volume $SINK \
			| grep -oP "[0-9]+(?=%)" \
			| xargs echo)
		muted="$(pactl get-sink-mute $SINK | grep -oP "yes|no$")"
		case $1 in
			up)
				l=$(roundadd "$l" $(( l < 5 ? 1 : 5 )))
				r=$(roundadd "$r" $(( r < 5 ? 1 : 5 )))
				;;
			down)
				l=$(roundadd "$l" $(( l <= 5 ? -1 : -5 )))
				r=$(roundadd "$r" $(( r <= 5 ? -1 : -5 )))
				;;
		esac
		(( l = l > MAX_VOL ? MAX_VOL : l ))
		(( r = r > MAX_VOL ? MAX_VOL : r ))
		report "$(( (l + r) / 2 ))" "$muted"
		pactl set-sink-volume $SINK "$l%" "$r%"
		;;
	*)
		echo "Usage: $1 [toggle-mic|toggle|unmute-down|unmute-up|up|down]" >&2
		exit 1
		;;
esac
