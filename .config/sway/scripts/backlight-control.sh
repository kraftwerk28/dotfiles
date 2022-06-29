#!/bin/bash
source "$(dirname "$0")/lib.sh"
if [[ ! $(groups) =~ i2c ]]; then
	echo "User '${USER}' must belong to 'i2c' group" >&2
	exit 1
fi
pgrep ddcutil && exit
output=$(swaymsg -t get_outputs | jq -r '.[]|select(.focused).name')
case $output in
	eDP-1) cur=$(brightnessctl info | grep -oP "\d+(?=%)");;
	DP-1) cur=$(ddcutil getvcp -t 10 | awk '{ print $4 }');;
esac
case ${1:-"up"} in
	up) cur=$(roundadd cur $(( cur < 5 ? 1 : 5 )));;
	down) cur=$(roundadd cur $(( cur <= 5 ? -1 : -5 )));;
	*) echo "Usage ${0} [up|down]" >&2; exit 1;;
esac
# Adjust to (0, 100]
(( cur = (cur <= 0 ? 1 : (cur > 100 ? 100 : cur)) ))
case $output in
	eDP-1) brightnessctl set "${cur}%" >/dev/null;;
	DP-1) ddcutil setvcp 10 $cur >/dev/null;;
esac
notify-send \
	-h "string:x-canonical-private-synchronous:backlight" \
	-h "int:value:${cur}" \
	-t "2000" \
	" ${cur}%"
