#!/bin/bash

percentage () {
	brightnessctl info | grep -oP "\d+(?=%)"
}

report () {
	local p=$(percentage)
	notify-send \
		-h "string:x-canonical-private-synchronous:backlight" \
		-h "int:value:${p}" \
		-t 2000 \
		" ${p}%"
}

case ${1:-up} in
	up)
		brightnessctl set "+5%" > /dev/null
		report
		;;
	down)
		if (( $(percentage) > 5 )); then
			brightnessctl set "5%-" > /dev/null
			report
		fi
		;;
esac
