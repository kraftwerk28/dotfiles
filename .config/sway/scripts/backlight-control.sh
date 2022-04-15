#!/bin/bash
get () {
	brightnessctl info | grep -oP "\d+(?=%)"
}
cur=$(get)
case ${1:-up} in
	up) cur=$(( cur + (cur < 5 ? 1 : 5) ));;
	down) cur=$(( cur - (cur <= 5 ? 1 : 5) ));;
	*) echo "Usage ${0} [up|down]" >&2; exit 1;;
esac
# Adjust to (0, 100]
(( cur = (cur <= 0 ? 1 : (cur > 100 ? 100 : cur)) ))
brightnessctl set "${cur}%" > /dev/null
notify-send \
	-h "string:x-canonical-private-synchronous:backlight" \
	-h "int:value:${cur}" \
	-t "2000" \
	" ${cur}%"
