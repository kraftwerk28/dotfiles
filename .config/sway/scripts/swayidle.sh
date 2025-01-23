#!/bin/bash
exec swayidle -w \
	timeout $((3 * 60)) 'swaymsg "output * power off"' \
	resume 'swaymsg "output * power on"' \
	after-resume 'swaymsg "output * power on"'
