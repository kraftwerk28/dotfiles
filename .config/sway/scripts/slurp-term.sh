#!/bin/bash
read -r x y w h < <(jq -jrR '. | splits("[, x]") | . + " "' <<<"$(slurp)")
{
	exec 3< <(swaymsg -mt subscribe '["window"]')
	pid="$!"
	read -r < <(jq --unbuffered -r 'select(.change == "new")' <&3)
	swaymsg "floating enable"
	sleep 0.1
	swaymsg "resize set ${w} ${h}, move position ${x} ${y}"
	kill "$pid"
} &
exec "$@"
