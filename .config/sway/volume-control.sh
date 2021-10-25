#!/usr/bin/env bash

sink="@DEFAULT_SINK@"
source="@DEFAULT_SOURCE@"
LIMIT=150

if [[ $1 == "toggle-mic" ]]; then
	pactl set-source-mute $source toggle
	exit 0
fi

if [[ $1 = "toggle" ]]; then
	pactl set-sink-mute $sink toggle
	exit 0
fi

read l r < <(pactl get-sink-volume $sink | grep -oP "[0-9]+(?=%)" | xargs echo)

if [[ $1 = "up" ]]; then
	l=$(($l + 5))
	r=$(($r + 5))
elif [[ $1 = "down" ]]; then
	l=$(($l - 5))
	r=$(($r - 5))
fi
l=$(($l - ($l % 5)))
r=$(($r - ($r % 5)))
if (($l > $LIMIT)); then l=$LIMIT; fi
if (($r > $LIMIT)); then r=$LIMIT; fi

pactl set-sink-volume $sink "$l%" "$r%"
