#!/bin/sh
WHAT=${1:-output}
if [[ $WHAT = "area" && $(pgrep slurp) ]]; then
	exit 0
fi
img_name () {
	echo "$HOME/Pictures/grimshot-$(date +"%x-%X").png"
}
fname=$(mktemp -u --suffix .png)
grimshot save "$WHAT" "$fname" > /dev/null
[[ $? == 1 ]] && exit 0 # Cancelled
case $(swaynag \
	-t warning \
	-m "What to do with the screenshot?" \
	-y overlay \
	-Z Copy "echo copy" \
	-Z Save "echo save" \
	-Z Edit "echo edit")
in
	copy)
		wl-copy -n < "$fname"
		notify-send "Screenshot copied to clipboard"
		;;
	save)
		name="$(img_name)"
		mv "$fname" "$name"
		notify-send "Screenshot saved to $name"
		;;
	edit)
		swappy -f "$fname"
		;;
	*)
		exit 0;;
esac
