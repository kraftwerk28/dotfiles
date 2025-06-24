#!/bin/bash
source "$(dirname "$0")/lib.sh"

output=$(swaymsg -t get_outputs | jq -r '.[]|select(.focused).name')

case "$output" in
	DP-1 | DP-3)
		method=ddc
		;;
	*)
		method=bctl
		;;
esac

case $method in
	bctl) cur=$(brightnessctl info | grep -oP "\d+(?=%)");;
	ddc)
		if [[ ! "$(groups)" =~ i2c ]]; then
			echo "User '${USER}' must belong to 'i2c' group" >&2
			exit 1
		fi
		if pgrep ddcutil; then exit; fi
		cur=$(ddcutil --brief getvcp 10 | awk '/^VCP/ { print $4 }')
		;;
esac

case ${1:-up} in
	up) cur=$(roundadd cur $(( cur < 5 ? 1 : 5 )));;
	down) cur=$(roundadd cur $(( cur <= 5 ? -1 : -5 )));;
	*) echo "Usage: $0 [up|down]" >&2; exit 1;;
esac
# Adjust to (0, 100]
(( cur = (cur <= 0 ? 1 : (cur > 100 ? 100 : cur)) ))

case $method in
	bctl) brightnessctl set "${cur}%" >/dev/null;;
	ddc) ddcutil --noverify setvcp 10 $cur >/dev/null;;
esac

notify-send \
	-e \
	-c progress \
	-h "string:x-canonical-private-synchronous:backlight" \
	-h "int:value:${cur}" \
	-t "2000" \
	"󰃞 ${cur}%"
