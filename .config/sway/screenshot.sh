#!/bin/sh
WHAT=${1:-output}
if [[ $WHAT = "area" && $(pgrep slurp) ]]; then
	exit 0
fi
img_name="$HOME/Pictures/grimshot-$(date +"%x-%X").png"
fname=$(mktemp -u --suffix .png)

if grimshot save "$WHAT" "$fname"; then
     swaynag \
        -t warning \
        -m "What to do with the screenshot?" \
        -y overlay \
        -Z Copy "\
            wl-copy -n < "$fname";\
            notify-send "Screenshot copied to clipboard";\
            "\
        -Z Save " \
            name="$(img_name)";\
            mv "$fname" "$name";\
            notify-send "Screenshot saved to $name";\
            "\
        -Z Edit "swappy -f "$fname"" \
        --no-dock
else
        exit 0
fi
