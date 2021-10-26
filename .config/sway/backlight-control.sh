#!/usr/bin/env bash

perc () {
	brightnessctl info | grep -oP "\d+(?=%)"
}

report () {
	local p=$(perc)
	notify-send \
		-h "string:x-canonical-private-synchronous:bri" \
		-h "int:value:${p}" \
		-t 1000 \
		" ${p}%"
}

case ${1:-up} in
	up)
		brightnessctl set "+5%" > /dev/null
		report
		;;
	down)
		if (( $(perc) > 5 )); then
			brightnessctl set "5%-" > /dev/null
			report
		fi
		;;
esac
