#!/bin/bash
source "$(dirname "$0")/lib.sh"
SINK="@DEFAULT_SINK@"
SOURCE="@DEFAULT_SOURCE@"
MAX_VOL=150

report () {
	local volume=$1
	local muted=$2
	local progress=$(( (volume > 100) ? 100 : volume ))
	case $muted in
		yes) icon=" ";;
		no) icon=" ";;
	esac
	notify-send \
		-e \
		-c progress \
		-h "string:x-canonical-private-synchronous:volume" \
		-h "int:value:${progress}" \
		-t 2000 \
		"${icon} ${volume}%"
}

# get_volume() {
# 	pactl -f json list 
# }

cmd="$1"
shift

case "$cmd" in
	toggle-mic)
		pactl set-source-mute "$SOURCE" toggle
		;;
	unmute-press)
		pactl set-source-mute $SOURCE 0
		;;
	unmute-release)
		pactl set-source-mute $SOURCE 1
		;;
	toggle)
		pactl set-sink-mute "$SINK" toggle
		read -r l r \
			< <(pactl get-sink-volume $SINK \
			| grep -oP "[0-9]+(?=%)" \
			| xargs echo)
		muted="$(pactl get-sink-mute $SINK | grep -oP "yes|no$")"
		report "$(( (l + r) / 2 ))" "$muted"
		;;
	up|down)
		read -r l r \
			< <(pactl get-sink-volume $SINK \
			| grep -oP "[0-9]+(?=%)" \
			| xargs echo)
		muted="$(pactl get-sink-mute $SINK | grep -oP "yes|no$")"
		case "$cmd" in
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
		echo "Usage: $0 [toggle-mic|toggle|unmute-down|unmute-up|up|down]" >&2
		exit 1
		;;
esac
