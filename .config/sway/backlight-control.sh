#!/bin/bash

report () {
	value=$(brightnessctl set "$1" | grep -oP "\d+(?=%)")
	notify-send \
		-h "string:x-canonical-private-synchronous:backlight" \
		-h "int:value:$value" \
		-t 2000 \
		" ${p}%"
}

case ${1:-up} in
	up)
		report "5%+"
		;;
	down)
		if (( $(brightnessctl info | grep -oP "\d+(?=%)") > 5 )); then
            report "5%-"
		fi
		;;
esac
