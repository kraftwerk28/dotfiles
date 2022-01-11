#!/bin/bash

SINK="@DEFAULT_SINK@"
SOURCE="@DEFAULT_SOURCE@"
LIMIT=150
STEP=5

report () {
	notify-send \
		-h "string:x-canonical-private-synchronous:volume" \
		-h "int:value:${1}" \
		-t 2000 \
		"墳 ${1}%"
}

read l r < <(pactl get-sink-volume $SINK | grep -oP "[0-9]+(?=%)" | xargs echo)

case $1 in
    up)   if [ $l < $LIMIT -a $r < $LIMIT ]; then
              pactl set-sink-volume $SINK +$STEP%
              read l r < <(pactl get-sink-volume $SINK | grep -oP "[0-9]+(?=%)" | xargs echo)
              report "$(( ($l + $r) / 2 ))"
          fi
          ;;
    down) if [ $l < $LIMIT -a $r < $LIMIT ]; then
              pactl set-sink-volume $SINK -$STEP%
              read l r < <(pactl get-sink-volume $SINK | grep -oP "[0-9]+(?=%)" | xargs echo)
              report "$(( ($l + $r) / 2 ))"
          fi
          ;;
    toggle-mic)
          pactl set-source-mute $SOURCE toggle
          exit 0
          ;;
    toggle)
          pactl set-sink-mute $SINK toggle
          exit 0
          ;;
    unmute-down)
          pactl set-source-mute $SOURCE 0
          exit 0
          ;;
    unmute-up)
          pactl set-source-mute $SOURCE 1
          exit 0
          ;;
esac

