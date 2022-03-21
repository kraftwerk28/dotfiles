#!/bin/bash
get () {
	brightnessctl info | grep -oP "\d+(?=%)"
}
report () {
	local p=$(get)
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
		if (( $(get) > 5 )); then
			brightnessctl set "5%-" > /dev/null
			report
		fi
		;;
esac
