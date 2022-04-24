#!/bin/bash
WHAT=${1:-"output"}
if [[ $WHAT == "area" ]] && pgrep grimshot || pgrep swaynag; then
	exit
fi
fname=$(mktemp -u --suffix ".png")
if ! grimshot save "$WHAT" "$fname" > /dev/null; then
	exit 0
fi
case $(swaynag \
	-t warning \
	-m "What to do with the screenshot?" \
	-y overlay \
	-Z Copy "echo copy" \
	-Z Save "echo save" \
	-Z Edit "echo edit" \
	--no-dock)
in
	copy)
		wl-copy -n < "$fname"
		notify-send "Screenshot copied to clipboard"
		rm "$fname"
		;;
	save)
		name="$HOME/Pictures/grimshot-$(date +"%x-%X").png"
		mv "$fname" "$name"
		notify-send "Screenshot saved" "$name"
		;;
	edit)
		swappy -f "$fname"
		rm "$fname"
		;;
	*)
		notify-send "Screenshot cancelled"
		exit 0
		;;
esac
