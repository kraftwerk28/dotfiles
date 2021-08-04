#!/usr/bin/env bash

pid=$(swaymsg -t get_tree \
	| jq '.. | (.nodes? // empty)[] | select(.focused == true) | .pid'
)
cwd=$(pwdx $pid | sed -r 's/^[0-9]+: //')
notify-send "$pid; $cwd"
tilix -w $cwd
