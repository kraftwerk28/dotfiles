#!/bin/bash
exec env -u XDG_CURRENT_DESKTOP \
	rofi -i -show drun \
	-run-command 'swaymsg exec "{cmd}"'
