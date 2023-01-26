#!/bin/bash

if [[ -z $DISPLAY ]] || ! hash swaymsg jq &>/dev/null; then
	exec systemctl suspend
fi

if swaymsg -t get_outputs | jq -e '.[] | select(.focused) | .power and .dpms'; then
	# If focused output is enabled & powered...
	exec systemctl suspend
else
	# Otherwise, enable it, don't suspend
	swaymsg output "*" power on
	swaymsg output "*" enable
fi
