#!/bin/bash

if ! name=$(rofi -dmenu \
	-p "New workspace name" \
	-theme-str "listview {enabled: false;}"); then
	exit 1
fi
num=$(swaymsg -rt get_workspaces | jq -r '.[] | select(.focused==true).num')
if [[ -z $name ]]; then
	swaymsg rename workspace to "${num}"
else
	swaymsg rename workspace to "${num}:${name}"
fi
